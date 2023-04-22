import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/common/tokoin_number.dart';
import 'package:t_chain_payment_sdk/common/utils.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/exchange_rate.dart';
import 'package:t_chain_payment_sdk/data/gas_fee.dart';
import 'package:t_chain_payment_sdk/data/payment_discount_fee.dart';
import 'package:t_chain_payment_sdk/repo/payment_repo.dart';
import 'package:t_chain_payment_sdk/repo/wallet_repos.dart';
import 'package:t_chain_payment_sdk/services/blockchain_service.dart';
import 'package:t_chain_payment_sdk/services/t_chain_api.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(const SimpleApp());
}

class SimpleApp extends StatelessWidget {
  const SimpleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String result = '---';
  bool isLoading = false;
  String _tnxHash = '';
  String logs = '';
  final apiKey = '3e093592-3e0e-4a52-9601-ead49f794586';
  final privateKey = EthPrivateKey.fromHex(
      '0097ad7d1294e0268bbaaf4642c6ccb4c4a76421bff0285023716e354c605513ee');
  final qrCode =
      'TCHAIN.29f5520f929c599412586be97e27b6c226c38365ebd727ac46fdc7a5ef854bf6';
  late PaymentRepository _paymentRepo;
  late WalletRepository _walletRepo;
  MerchantInfo? _merchantInfo;
  late Asset depositedAsset;
  ExchangeRate _exchangeRate = ExchangeRate({});
  GasFee? _gasFee;
  double _serviceFeePercent = 0;
  PaymentDiscountInfo? _discountInfo;

  @override
  void initState() {
    super.initState();

    Config.setEnvironment(TChainPaymentEnv.dev);
    depositedAsset = Asset.createAsset(shortName: 'USDT')!;
    TChainPaymentSDK.shared.configWallet(
      apiKey: apiKey,
      env: TChainPaymentEnv.dev,
    );

    final api = TChainAPI.standard(Config.baseURL);
    _paymentRepo = PaymentRepository(api: api);
    _walletRepo = WalletRepository(blockchainService: BlockchainService());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test API & SMC'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      result,
                      key: const Key('result'),
                    ),
                  ),
                  if (isLoading) const CircularProgressIndicator(),
                ],
              ),
              ElevatedButton(
                key: const Key('btnStart'),
                onPressed: _onStart,
                child: const Text('Start'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(logs),
                ),
              ),
              if (_tnxHash.isNotEmpty)
                ElevatedButton(
                  key: const Key('btnOpenTnx'),
                  onPressed: () => launchUrlString(
                      'https://testnet.bscscan.com/tx/$_tnxHash'),
                  child: Text('Open Tnx: $_tnxHash'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _onStart() async {
    setState(() {
      isLoading = true;
    });

    await _onGetMerchantInfo();
    if (_merchantInfo == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    await _onGetOtherInfo();

    if (_discountInfo == null || _gasFee == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    await _onDeposit();
    setState(() {
      isLoading = false;
    });
  }

  _onGetMerchantInfo() async {
    setState(() {
      logs = '---------------------------\n';
    });

    try {
      final response = await _paymentRepo.getMerchantInfo(
        qrCode: qrCode,
      );

      if (response?.error != null) {
        setState(() {
          logs += response!.error!.message + '\n';
        });

        return;
      }

      if (response?.result != null) {
        setState(() {
          _merchantInfo = response?.result;
          logs += 'MerchantInfo: ${_merchantInfo!.toJson().toString()}\n';
        });
        return;
      }
    } catch (e) {
      setState(() {
        logs += e.toString() + '\n';
      });
    }

    setState(() {
      result = 'FAIL';
    });
  }

  _onGetOtherInfo() async {
    setState(() {
      logs += '---------------------------\n';
    });

    try {
      await Future.wait([
        _paymentRepo.getExchangeRate().then((value) {
          _exchangeRate = ExchangeRate(
            value?.result ?? {},
          );
          logs += 'ExchangeRate: ${_exchangeRate.map}\n';
        }),
        _walletRepo.getBSCGasFees().then((value) {
          if (value.length == 1) {
            _gasFee = value.first;
            logs += 'GasFee: $_gasFee\n';
          }
        }),
        _walletRepo.getPaymentDepositFee().then((value) {
          _serviceFeePercent = value.toDouble();
          logs += 'ServiceFee: $_serviceFeePercent\n';
        }),
        _walletRepo
            .getPaymentDiscountFee(
          contractAddress: depositedAsset.contractAddress,
          amount: _merchantInfo!.amount ?? 0,
        )
            .then((value) {
          _discountInfo = value;
          logs += 'DiscountInfo: $_discountInfo\n';
        }),
        _walletRepo
            .balanceOf(
          smcAddressHex: depositedAsset.contractAddress,
          privateKey: privateKey,
        )
            .then((value) {
          depositedAsset = depositedAsset.copyWith(balance: value.toDouble());
          logs += 'balance: $value\n';
        })
      ]);

      setState(() {});
    } catch (e) {
      setState(() {
        logs += e.toString() + '\n';
        result = 'FAIL';
      });
    }
  }

  _onDeposit() async {
    setState(() {
      logs += '---------------------------\n';
    });

    try {
      final amount = _merchantInfo!.amount!.toDouble();
      final currency = _merchantInfo!.currency.toCurrency();
      const useToko = false;
      final assetAmount = _exchangeRate.calculateAssetAmount(
        amountCurrency: amount,
        currency: currency,
        asset: depositedAsset,
      );
      final feeAmount = _discountInfo!.getDiscountedServiceFee(
        serviceFeePercent: _serviceFeePercent,
        amount: assetAmount!,
        useToko: useToko,
      );

      final transactionSignedHash =
          await _paymentRepo.createMerchantTransaction(
        address: privateKey.address.hex,
        amount: amount,
        currency: _merchantInfo!.currency.toCurrency(),
        notes: 'test',
        tokenName: depositedAsset.shortName,
        externalMerchantId: _merchantInfo!.merchantId,
        chainId: _merchantInfo!.chainId.toString(),
      );

      var signatureBytes = hexToBytes(transactionSignedHash!.signedHash);
      final merchantIdBytes32 = keccakUtf8(transactionSignedHash.merchantId);
      var offchainBytes32 = transactionSignedHash.offchain.toBytes32();

      final params = [
        EthereumAddress.fromHex(depositedAsset.contractAddress),
        useToko,
        signatureBytes,
        merchantIdBytes32,
        offchainBytes32,
        TokoinNumber.fromNumber(assetAmount).bigIntValue,
        TokoinNumber.fromNumber(feeAmount).bigIntValue,
        BigInt.from(transactionSignedHash.expiredTime),
      ];

      setState(() {
        logs += 'contractAddress: ${depositedAsset.contractAddress}\n';
        logs += 'useToko: $useToko\n';
        logs += 'signature: ${transactionSignedHash.signedHash}\n';
        logs += 'merchantId: ${transactionSignedHash.merchantId}\n';
        logs += 'offchain: ${transactionSignedHash.offchain}\n';
        logs += 'assetAmount: $assetAmount\n';
        logs += 'feeAmount: $feeAmount\n';
        logs += 'expiredTime: ${transactionSignedHash.expiredTime}\n';
        logs += '---------------------------\n';
      });

      Transaction tnx = await _walletRepo.buildDepositTransaction(
        privateKey: privateKey,
        parameters: [params],
        gasPrice: _gasFee!.toGwei(),
      );

      if (await _isEnoughBalance(
        asset: depositedAsset,
        tnx: tnx,
        amount: assetAmount,
        gasFee: _gasFee!.fee,
      )) {
        _tnxHash = await _walletRepo.sendPaymentTransaction(
          privateKey: privateKey,
          tx: tnx,
        );
        setState(() {
          logs += 'tnx: $_tnxHash\n';
          logs += 'Wait for Receipt result\n';
        });
        debugPrint('tx: $_tnxHash');

        bool isSuccess =
            await _walletRepo.waitForReceiptResult(depositedAsset, _tnxHash);
        if (!isSuccess) {
          setState(() {
            logs += 'tnx status is FAIL\n';
            result = 'FAIL';
          });
          return;
        }

        setState(() {
          logs += 'Success\n';
          result = 'SUCCESS';
        });
      } else {
        setState(() {
          logs += 'Not enough balance\n';
          result = 'FAIL';
        });
      }
    } catch (e) {
      setState(() {
        logs += e.toString() + '\n';
        result = 'FAIL';
      });
    }
  }

  Future<bool> _isEnoughBalance({
    required Asset asset,
    required Transaction tnx,
    required num amount,
    required num gasFee,
  }) async {
    if (!asset.isBnb) {
      final balance = await _walletRepo.balanceOf(
        smcAddressHex: asset.contractAddress,
        privateKey: privateKey,
      );

      if (balance < amount) {
        return false;
      }
    }

    num estimatedGas = await _walletRepo.estimateGas(
      address: privateKey.address,
      transaction: tnx,
    );

    bool isEnoughBalance = await _walletRepo.isEnoughBnb(
      privateKey: privateKey,
      asset: asset,
      amount: amount,
      gasPrice: gasFee,
      estimatedGas: estimatedGas,
    );

    return isEnoughBalance;
  }
}
