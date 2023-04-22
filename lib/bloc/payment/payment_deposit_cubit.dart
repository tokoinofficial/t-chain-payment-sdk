import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/config/const.dart';
import 'package:t_chain_payment_sdk/common/utils.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/exchange_rate.dart';
import 'package:t_chain_payment_sdk/data/gas_fee.dart';
import 'package:t_chain_payment_sdk/data/payment_discount_fee.dart';
import 'package:t_chain_payment_sdk/data/transfer_data.dart';
import 'package:t_chain_payment_sdk/common/tokoin_number.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations_en.dart';
import 'package:t_chain_payment_sdk/repo/payment_repo.dart';
import 'package:t_chain_payment_sdk/repo/wallet_repos.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart' as web3dart;

part 'payment_deposit_state.dart';

class PaymentDepositCubit extends Cubit<PaymentDepositState> {
  PaymentDepositCubit({
    required this.walletRepository,
    required this.paymentRepository,
    required this.amount,
    required this.currency,
    required this.account,
  }) : super(PaymentDepositInitial());

  final WalletRepository walletRepository;
  final PaymentRepository paymentRepository;
  TChainPaymentLocalizations localizations = TChainPaymentLocalizationsEn();
  final Account account;

  final double amount;
  final Currency currency;

  List<Asset> _supportedAssets = [];
  double? _serviceFeePercent;
  GasFee? _gasFee;
  final Map<String, PaymentDiscountInfo?> _discountInfoMap = {};
  ExchangeRate _exchangeRate = ExchangeRate({});

  Future setup() async {
    emit(PaymentDepositWaitForSetup());
    try {
      final address = account.privateKey.address.hex;

      if (!Utils.isValidEthereumAddress(address)) {
        emit(PaymentDepositUnsupportedWallet());
        return;
      }
    } catch (e) {
      emit(PaymentDepositUnsupportedWallet());
      return;
    }

    if (!walletRepository.isReady) {
      final isReady = await walletRepository.setup();

      if (!isReady) {
        emit(PaymentDepositError(
          error: localizations.something_went_wrong_please_try_later,
        ));
        return;
      }
    }

    await walletRepository.setupPaymentContract();

    emit(PaymentDepositSetUpCompleted());
  }

  Future deposit({
    required Asset asset,
    required bool useToko,
    required String notes,
    required String merchantId,
    required String chainId,
  }) async {
    try {
      final discountInfo = _discountInfoMap[asset.shortName];
      final assetAmount = _exchangeRate.calculateAssetAmount(
        amountCurrency: amount,
        currency: currency,
        asset: asset,
      );
      if (_serviceFeePercent == null ||
          discountInfo == null ||
          _gasFee == null ||
          assetAmount == null ||
          discountInfo.discountFeePercent > _serviceFeePercent!) {
        throw Exception(localizations.something_went_wrong_please_try_later);
      }

      final feeAmount = discountInfo.getDiscountedServiceFee(
        serviceFeePercent: _serviceFeePercent!,
        amount: assetAmount,
        useToko: useToko,
      );

      emit(
        PaymentDepositShowInfo(
          status: PaymentDepositStatus.depositing,
          isEnoughBnb: _isEnoughBnb(),
          transferDataList: _createTransferDataList(),
        ),
      );

      Asset tokoAsset = _getTokoinAsset();
      if (useToko && !asset.isToko) {
        bool hasTokoAllowance = await _hasEnoughAllowance(
          discountInfo.deductAmount,
          tokoAsset,
          Config.paymentContractAddress,
        );

        if (!hasTokoAllowance) {
          emit(PaymentDepositAddAllowance(
            asset: tokoAsset,
            amount: discountInfo.deductAmount,
            contractAddress: Config.paymentContractAddress,
            transferDataList: _createTransferDataList(),
          ));
          emit(PaymentDepositShowInfo(
            status: PaymentDepositStatus.loaded,
            isEnoughBnb: _isEnoughBnb(),
            transferDataList: _createTransferDataList(),
          ));
          return;
        }
      }

      if (!asset.isStableCoin && !asset.isToko) {
        Asset toAsset = _getSwappingAsset();

        emit(PaymentDepositSwapRequest(
          fromAsset: asset,
          toAsset: toAsset,
          amount: assetAmount + feeAmount,
          gasFee: _gasFee!,
          transferDataList: _createTransferDataList(),
        ));
        return;
      }

      var hasEnoughAllowance = await _hasEnoughAllowance(
        assetAmount,
        asset,
        Config.paymentTokenRegistry,
      );

      if (!hasEnoughAllowance) {
        emit(PaymentDepositAddAllowance(
          asset: asset,
          amount: assetAmount + feeAmount,
          contractAddress: Config.paymentTokenRegistry,
          transferDataList: _createTransferDataList(),
        ));
        emit(PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: _isEnoughBnb(),
          transferDataList: _createTransferDataList(),
        ));
        return;
      }

      final transactionSignedHash =
          await paymentRepository.createMerchantTransaction(
        address: account.privateKey.address.hex,
        amount: amount.toDouble(),
        currency: currency,
        notes: notes,
        tokenName: asset.shortName,
        externalMerchantId: merchantId,
        chainId: chainId,
      );

      if (transactionSignedHash == null) {
        throw Exception(localizations.something_went_wrong_please_try_later);
      }

      var signatureBytes = hexToBytes(transactionSignedHash.signedHash);
      final merchantIdBytes32 = keccakUtf8(transactionSignedHash.merchantId);
      var offchainBytes32 = transactionSignedHash.offchain.toBytes32();

      final params = [
        web3dart.EthereumAddress.fromHex(asset.contractAddress),
        useToko,
        signatureBytes,
        merchantIdBytes32,
        offchainBytes32,
        TokoinNumber.fromNumber(assetAmount).bigIntValue,
        TokoinNumber.fromNumber(feeAmount).bigIntValue,
        BigInt.from(transactionSignedHash.expiredTime),
      ];

      web3dart.Transaction tnx = await walletRepository.buildDepositTransaction(
        privateKey: account.privateKey,
        parameters: [params],
        gasPrice: _gasFee!.toGwei(),
      );

      if (await _isEnoughBalance(
        asset: asset,
        tnx: tnx,
        amount: assetAmount,
        gasFee: _gasFee!.fee,
      )) {
        String hash = await walletRepository.sendPaymentTransaction(
          privateKey: account.privateKey,
          tx: tnx,
        );
        emit(PaymentDepositProceeding(txn: hash));

        bool isSuccess =
            await walletRepository.waitForReceiptResult(asset, hash);
        if (!isSuccess) {
          emit(PaymentDepositFailed(txn: hash));
          return;
        }

        emit(PaymentDepositCompleted(txn: hash));
      } else {
        emit(PaymentDepositError(error: localizations.you_are_not_enough_bnb));
        emit(PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: _isEnoughBnb(),
          transferDataList: _createTransferDataList(),
        ));
      }
    } catch (e) {
      emit(PaymentDepositError(error: Utils.getErrorMsg(e)));
      emit(PaymentDepositShowInfo(
        status: PaymentDepositStatus.loaded,
        isEnoughBnb: _isEnoughBnb(),
        transferDataList: _createTransferDataList(),
      ));
    }
  }

  Future<bool> _isEnoughBalance({
    required Asset asset,
    required web3dart.Transaction tnx,
    required num amount,
    required num gasFee,
  }) async {
    if (!asset.isBnb) {
      final balance = await walletRepository.balanceOf(
        smcAddressHex: asset.contractAddress,
        privateKey: account.privateKey,
      );

      account.updateAsset(
        asset.copyWith(balance: balance.toDouble()),
      );

      if (balance < amount) {
        return false;
      }
    }

    num estimatedGas = await walletRepository.estimateGas(
      address: account.privateKey.address,
      transaction: tnx,
    );

    bool isEnoughBalance = await walletRepository.isEnoughBnb(
      privateKey: account.privateKey,
      asset: asset,
      amount: amount,
      gasPrice: gasFee,
      estimatedGas: estimatedGas,
    );

    return isEnoughBalance;
  }

  Future getAllInfo() async {
    if (state is PaymentDepositUnsupportedWallet) return;

    if (state is PaymentDepositShowInfo &&
        (state as PaymentDepositShowInfo).status ==
            PaymentDepositStatus.loading) return;

    emit(PaymentDepositShowInfo(
      isEnoughBnb: _isEnoughBnb(),
      status: PaymentDepositStatus.loading,
      transferDataList: _createTransferDataList(),
    ));

    try {
      // get exchange rate
      final response = await paymentRepository.getExchangeRate();
      _exchangeRate = ExchangeRate(response?.result ?? {});

      emit(PaymentDepositShowInfo(
        isEnoughBnb: _isEnoughBnb(),
        status: PaymentDepositStatus.loading,
        transferDataList: _createTransferDataList(),
      ));

      // get smc info
      await Future.wait([
        walletRepository.getBSCGasFees().then((value) {
          if (value.length == 1) {
            _gasFee = value.first;
          }
        }),
        walletRepository
            .getPaymentDepositFee()
            .then((value) => _serviceFeePercent = value.toDouble()),
        ..._supportedAssets.map(
          (asset) {
            String contractAddress = asset.contractAddress;
            return walletRepository
                .getPaymentDiscountFee(
                  contractAddress: contractAddress,
                  amount: amount,
                )
                .then((value) => _discountInfoMap[asset.shortName] = value)
                .catchError((e) {
              debugPrint(e.toString());

              return null;
            });
          },
        ),
        ..._supportedAssets.toList().asMap().entries.map(
          (entry) {
            return walletRepository
                .balanceOf(
              smcAddressHex: entry.value.contractAddress,
              privateKey: account.privateKey,
            )
                .then(
              (value) {
                final asset = entry.value.copyWith(balance: value.toDouble());
                TChainPaymentSDK.shared.account.updateAsset(asset);
              },
            ).catchError((e) {
              debugPrint(e.toString());

              return null;
            });
          },
        )
      ]);

      emit(PaymentDepositShowInfo(
        status: PaymentDepositStatus.loaded,
        isEnoughBnb: _isEnoughBnb(),
        transferDataList: _createTransferDataList(),
      ));
    } catch (e) {
      emit(PaymentDepositError(error: Utils.getErrorMsg(e)));
    }
  }

  Future getExchangeRate() async {
    if (state is PaymentDepositShowInfo || state is PaymentDepositError) {
      if ((state as PaymentDepositShowInfo).status ==
              PaymentDepositStatus.loading ||
          (state as PaymentDepositShowInfo).status ==
              PaymentDepositStatus.depositing) return;

      _exchangeRate = ExchangeRate({});
      emit(PaymentDepositShowInfo(
        status: PaymentDepositStatus.loading,
        isEnoughBnb: _isEnoughBnb(),
        transferDataList: _createTransferDataList(),
      ));

      try {
        final response = await paymentRepository.getExchangeRate();
        if (response == null) {
          throw Exception(localizations.invalid_exchange_rate);
        }

        _exchangeRate = ExchangeRate(response.result ?? {});

        emit(PaymentDepositShowInfo(
          status: PaymentDepositStatus.loaded,
          isEnoughBnb: _isEnoughBnb(),
          transferDataList: _createTransferDataList(),
        ));
      } catch (e) {
        emit(PaymentDepositError(error: Utils.getErrorMsg(e)));
      }
    }
  }

  num getTotal({
    required Asset asset,
    required num amount,
    required bool useToko,
  }) {
    final discountInfo = _discountInfoMap[asset.shortName];
    final safeServiceFee = _serviceFeePercent ?? 0;

    num total = amount + amount * safeServiceFee / 100;
    if (useToko) {
      if (safeServiceFee == 0) return total;

      final discountFeePercent = discountInfo?.discountFeePercent ?? 0;
      return TokoinNumber.fromNumber(total -
              amount *
                  safeServiceFee /
                  100 *
                  discountFeePercent /
                  safeServiceFee)
          .getClosestDoubleValue();
    }

    return total;
  }

  Asset _getTokoinAsset() {
    return TChainPaymentSDK.shared.account.getAsset(
      name: CONST.kAssetNameTOKO,
    )!;
  }

  Asset _getSwappingAsset() {
    return TChainPaymentSDK.shared.account.getAsset(
      name: CONST.kAssetNameUSDT,
    )!;
  }

  bool _isEnoughBnb() {
    Asset? asset =
        TChainPaymentSDK.shared.account.getAsset(name: CONST.kAssetNameBNB);
    if (asset == null || _gasFee == null) return false;

    return asset.balance >=
        num.parse(GasFee(_gasFee!.fee, 0).toEthString(_gasFee!.estimatedGas));
  }

  Future<bool> _hasEnoughAllowance(
    num amount,
    Asset asset,
    String contractAddress,
  ) async {
    double depositAmount = amount.toDouble();
    var allowance = await walletRepository.allowance(
      privateKey: account.privateKey,
      asset: asset,
      contractAddress: contractAddress,
    );
    return allowance >= depositAmount;
  }

  List<TransferData> _createTransferDataList() {
    Asset tokoAsset = _getTokoinAsset();

    final usdPerFiat = _exchangeRate.getUsdPerFiatCurrency(currency);

    _supportedAssets = _exchangeRate.map.keys
        .map((e) {
          return TChainPaymentSDK.shared.account.getAsset(name: e);
        })
        .where((element) => element != null)
        .cast<Asset>()
        .toList();

    return _supportedAssets.where((asset) {
      final assetPerUsd = _exchangeRate.getAssetPerUsd(asset);
      final isAbleToLoadExchangeRate =
          !_exchangeRate.hasData || (usdPerFiat != null && assetPerUsd != null);
      return isAbleToLoadExchangeRate;
    }).map((asset) {
      final discountInfo = _discountInfoMap[asset.shortName];
      double? serviceFeePercent = _serviceFeePercent;

      if (asset.isToko) {
        serviceFeePercent = 0;
      }

      double? exchangeRate;
      final assetPerUsd = _exchangeRate.getAssetPerUsd(asset);
      if (assetPerUsd != null &&
          assetPerUsd != 0 &&
          usdPerFiat != null &&
          usdPerFiat != 0) {
        exchangeRate = 1 / (assetPerUsd * usdPerFiat);
      }

      return TransferData(
        asset: asset,
        tokoAsset: tokoAsset,
        discountInfo: discountInfo,
        serviceFeePercent: serviceFeePercent,
        gasFee: _gasFee,
        exchangeRate: exchangeRate,
        amount: amount,
        currency: currency,
      );
    }).toList();
  }
}
