import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:t_chain_payment_sdk/config/config.dart';

import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/gas_fee.dart';
import 'package:t_chain_payment_sdk/data/pancake_swap.dart';
import 'package:t_chain_payment_sdk/data/payment_discount_fee.dart';
import 'package:t_chain_payment_sdk/common/tokoin_number.dart';
import 'package:t_chain_payment_sdk/services/blockchain_service.dart';
import 'package:t_chain_payment_sdk/services/gas_station_api.dart';
import 'package:t_chain_payment_sdk/smc/bep_20_smc.dart';
import 'package:t_chain_payment_sdk/smc/pancake_swap_smc.dart';
import 'package:t_chain_payment_sdk/smc/payment_smc.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';
import 'package:web3dart/web3dart.dart';

const kWaitForReceiptTimeoutInSecond = 300;

class WalletRepository {
  final gasStationAPI = GasStationAPI();
  final BlockchainService blockchainService;
  Web3Client? _web3Client;
  final Map<String, Bep20Smc> _bep20SmcMap = {};
  PaymentSmc? _paymentSmc;
  PancakeSwapSmc? _pancakeSwapSmc;

  bool get isReady => _web3Client != null;

  WalletRepository({required this.blockchainService}) {
    setup();
  }

  Future<bool> setup() async {
    _web3Client ??=
        await blockchainService.createWeb3Client(Config.binanceDataSeed);

    return isReady;
  }

  Future<Bep20Smc> getBep20Smc(String addressHex) async {
    final smc = _bep20SmcMap[addressHex];

    if (smc != null) return smc;

    EthereumAddress address = EthereumAddress.fromHex(addressHex);
    final newSmc = await blockchainService.createBep20Smc(
      address: address,
      client: _web3Client!,
      chainId: TChainPaymentSDK.instance.chainID,
    );

    _bep20SmcMap[addressHex] = newSmc;

    return newSmc;
  }

  Future<PaymentSmc> getPaymentSmc() async {
    if (_paymentSmc != null) return _paymentSmc!;

    EthereumAddress address =
        EthereumAddress.fromHex(Config.paymentContractAddress);
    final newSmc = await blockchainService.createPaymentSmc(
      address: address,
      client: _web3Client!,
      chainId: TChainPaymentSDK.instance.chainID,
    );

    _paymentSmc = newSmc;
    return newSmc;
  }

  Future<PancakeSwapSmc> getPancakeSwapSmc() async {
    if (_pancakeSwapSmc != null) return _pancakeSwapSmc!;

    EthereumAddress address = EthereumAddress.fromHex(Config.pancakeRouter);
    final newSmc = await blockchainService.createPancakeSwapSmc(
      address: address,
      client: _web3Client!,
      chainId: TChainPaymentSDK.instance.chainID,
    );

    _pancakeSwapSmc = newSmc;
    return newSmc;
  }

  Future<num> balanceOf({
    required String smcAddressHex,
    required String privateKeyHex,
  }) async {
    final privateKey = EthPrivateKey.fromHex(privateKeyHex);

    if (smcAddressHex == Config.bnbContractAddress) {
      EtherAmount balance = await _web3Client!.getBalance(privateKey.address);
      return balance.getValueInUnit(EtherUnit.ether);
    }
    final smc = await getBep20Smc(smcAddressHex);

    final value = await smc.getBalance(privateKey.address);

    return TokoinNumber.fromBigInt(value,
        exponent: TokoinNumber.getExponentWithAssetContractAddress(
          smcAddressHex,
        )).doubleValue;
  }

  Future<num> allowance({
    required Asset asset,
    required String privateKeyHex,
    required String contractAddress,
  }) async {
    final tokenContractAddress =
        asset.isBnb ? Asset.wbnb().contractAddress : asset.contractAddress;
    final smc = await getBep20Smc(tokenContractAddress);

    final privateKey = EthPrivateKey.fromHex(privateKeyHex);
    return await smc.allowance(
      walletAddress: privateKey.address.hex,
      contractAddress: contractAddress,
    );
  }

  Future<TransactionReceipt?> getTransactionReceipt(
      Asset asset, String txHash) async {
    return await _web3Client!.getTransactionReceipt(txHash);
  }

  Future<TransactionInformation?> getTransactionByHash(
      Asset asset, String txHash) async {
    return await _web3Client!.getTransactionByHash(txHash);
  }

  Future<Transaction> buildApproveTransaction({
    required String privateKeyHex,
    required Asset asset,
    required String contractAddress,
    required BigInt amount,
    num gasPrice = 0,
    int? nonce,
  }) async {
    final tokenContractAddress =
        asset.isBnb ? Asset.wbnb().contractAddress : asset.contractAddress;
    final smc = await getBep20Smc(tokenContractAddress);

    return await smc.buildApprovalTransaction(
      privateKeyHex: privateKeyHex,
      contractAddress: contractAddress,
      amount: amount,
      gasPrice: gasPrice,
      nonce: nonce,
    );
  }

  Future<String> sendApproval({
    required String privateKeyHex,
    required Asset asset,
    required String contractAddress,
    num gasPrice = 0,
    int? nonce,
  }) async {
    final tokenContractAddress =
        asset.isBnb ? Asset.wbnb().contractAddress : asset.contractAddress;
    final smc = await getBep20Smc(tokenContractAddress);

    final tnx = await buildApproveTransaction(
      privateKeyHex: privateKeyHex,
      asset: asset,
      contractAddress: contractAddress,
      amount: TokoinNumber.fromNumber(
        kDefaultApprovedValue,
        exponent: TokoinNumber.getExponentWithAssetContractAddress(
            tokenContractAddress),
      ).bigIntValue,
      gasPrice: gasPrice,
      nonce: nonce,
    );

    return await smc.sendRawTransaction(
      privateKeyHex: privateKeyHex,
      transaction: tnx,
    );
  }

  Future<bool> isEnoughBnb({
    required String privateKeyHex,
    required Asset asset,
    required num amount,
    required num gasPrice,
    required num estimatedGas,
  }) async {
    var isEnoughBnb = true;

    if (estimatedGas > Config.maxGas) {
      estimatedGas = Config.maxGas;
    }

    final privateKey = EthPrivateKey.fromHex(privateKeyHex);
    final balance = await _web3Client!.getBalance(privateKey.address);
    var balanceOfBnb = balance.getValueInUnit(EtherUnit.ether);
    if (asset.isBnb) {
      if (balanceOfBnb == 0 ||
          balanceOfBnb <
              amount +
                  num.parse(GasFee(gasPrice, 0).toEthString(estimatedGas))) {
        isEnoughBnb = false;
      }
    } else {
      if (balanceOfBnb == 0 ||
          balanceOfBnb <
              num.parse(GasFee(gasPrice, 0).toEthString(estimatedGas))) {
        isEnoughBnb = false;
      }
    }

    return isEnoughBnb;
  }

  Future<List<GasFee>> getBSCGasFees() async {
    /*
    The current minimum gas price is 15 Gwei.
    Since the latest adjustment of gas price, BNB price has doubled.
    The proposed minimum gas price is 10 Gwei.
     */
    const minimumGasPriceInBsc = 10;

    var response = await gasStationAPI.getBscGas();
    var map = response.data;

    int gasPrice = GasFee.parseBscGasPrice(map['result'] ?? 0);
    if (gasPrice < minimumGasPriceInBsc) {
      gasPrice = minimumGasPriceInBsc;
    }
    GasFee gasFee = GasFee(gasPrice, kDefaultBscWaitMinutes);

    return [gasFee];
  }

  Future setupPaymentContract() async {
    getPaymentSmc();
  }

  Future<Transaction> buildDepositTransaction({
    required String privateKeyHex,
    required List parameters,
    required num gasPrice,
  }) async {
    final smc = await getPaymentSmc();
    return await smc.buildDepositTransaction(
      privateKeyHex: privateKeyHex,
      parameters: parameters,
      gasPrice: gasPrice,
    );
  }

  Future<num> getPaymentDepositFee() async {
    final smc = await getPaymentSmc();
    return await smc.getDepositFee();
  }

  Future<PaymentDiscountInfo?> getPaymentDiscountFee({
    required String contractAddress,
    required num amount,
  }) async {
    final smc = await getPaymentSmc();
    return await smc.getDiscountFee(
      tokenAddress: contractAddress,
      amount: amount,
    );
  }

  Future<BigInt> debugPaymentDepositFee({
    required Asset asset,
    required num amount,
  }) async {
    final smc = await getPaymentSmc();

    return await smc.debugDepositFee(
      tokenAddress: asset.contractAddress,
      amount: amount,
    );
  }

  Future<String> sendPaymentTransaction({
    required String privateKeyHex,
    required Transaction tx,
  }) async {
    final smc = await getPaymentSmc();
    final hash = await smc.sendRawTransaction(
      privateKey: privateKeyHex,
      transaction: tx,
    );

    debugPrint('sendPaymentTransaction hash $hash');

    return hash;
  }

  Future<num> estimateGas({
    required EthereumAddress address,
    required Transaction transaction,
  }) async {
    final estimatedGas = await _web3Client!.estimateGas(
      sender: address,
      to: transaction.to,
      data: transaction.data,
      value: transaction.value,
      gasPrice: transaction.gasPrice,
      amountOfGas: BigInt.from(Config.maxGas),
    );

    num gas = estimatedGas.toInt();

    // by * 20%, we'll make sure the gas limit is enough for covering this transaction
    gas = gas + (gas * 20 / 100);

    return gas;
  }

  Future<BigInt?> getSwapAmountOut({required PancakeSwap pancakeSwap}) async {
    final smc = await getPancakeSwapSmc();

    return await smc.getAmountOut(
      amountIn: pancakeSwap.amountIn!,
      paths: _getPaths(pancakeSwap),
    );
  }

  Future<BigInt?> getSwapAmountIn({required PancakeSwap pancakeSwap}) async {
    final smc = await getPancakeSwapSmc();

    return await smc.getAmountIn(
      amountOut: pancakeSwap.amountOut!,
      paths: _getPaths(pancakeSwap),
    );
  }

  Future<String> swap({
    required String privateKeyHex,
    required num gasPrice,
    required num gasLimit,
    required PancakeSwap pancakeSwap,
    required Transaction tx,
  }) async {
    final smc = await getPancakeSwapSmc();

    /*
      To avoid the error of decimal number
      If user send value = current balance, we subtract the value with epsilon number
    */
    num balance = await balanceOf(
      smcAddressHex: pancakeSwap.assetIn.contractAddress,
      privateKeyHex: privateKeyHex,
    );

    if (pancakeSwap.amountIn == balance) {
      var epsilon = 0.000000001;
      pancakeSwap.amountIn = (pancakeSwap.amountIn! - epsilon);
    }

    var hash = await smc.sendRawTransaction(
      privateKey: privateKeyHex,
      transaction: tx,
    );
    return hash;
  }

  // the `swapExactETHForTokens` function requires input amountIn as value in transaction
  _isPayableFunction(String functionName) =>
      functionName == 'swapExactETHForTokens';

  Future<Transaction> buildSwapContractTransaction({
    required String privateKeyHex,
    required PancakeSwap pancakeSwap,
    required num gasPrice,
    int? nonce,
  }) async {
    final smc = await getPancakeSwapSmc();
    final privateKey = EthPrivateKey.fromHex(privateKeyHex);

    List parameters = [
      TokoinNumber.fromNumber(
              pancakeSwap.amountOut! * (100 - kMaxSlippage) / 100)
          .toTokoinNumberWithAsset(pancakeSwap.assetOut)
          .bigIntValue,
      _getPaths(pancakeSwap).map((e) => EthereumAddress.fromHex(e)).toList(),
      privateKey.address,
      PancakeSwapSmc.deadline
    ];
    String functionName = _getFunctionName(pancakeSwap);
    bool isPayableFunction = _isPayableFunction(functionName);
    BigInt amountIn = TokoinNumber.fromNumber(pancakeSwap.amountIn ?? 0)
        .toTokoinNumberWithAsset(pancakeSwap.assetIn)
        .bigIntValue;
    if (!isPayableFunction) parameters.insert(0, amountIn);
    return await smc.buildSwapTransaction(
        privateKeyHex: privateKeyHex,
        functionName: _getFunctionName(pancakeSwap),
        parameters: parameters,
        gasPrice: gasPrice,
        nonce: nonce,
        value: isPayableFunction ? amountIn : null);
  }

  String _getFunctionName(PancakeSwap pancakeSwap) {
    if (pancakeSwap.assetIn.isBnb) {
      return 'swapExactETHForTokens';
    } else if (pancakeSwap.assetOut.isBnb) {
      return 'swapExactTokensForETH';
    } else {
      return 'swapExactTokensForTokens';
    }
  }

  List<String> _getPaths(PancakeSwap pancakeSwap) {
    Asset assetOut = pancakeSwap.assetOut;
    Asset assetIn = pancakeSwap.assetIn;
    bool withoutBridge =
        assetOut.isUsdt || assetIn.isUsdt || assetIn.isTko || assetOut.isTko;

    if (assetOut.isBnb) assetOut = Asset.wbnb();
    if (assetIn.isBnb) assetIn = Asset.wbnb();
    return withoutBridge
        ? [assetIn.contractAddress, assetOut.contractAddress]
        : [
            assetIn.contractAddress,
            Config.bscUsdtContractAddress,
            assetOut.contractAddress
          ];
  }

  Future<bool> waitForReceiptResult(Asset asset, String txHash) async {
    late TransactionReceipt? receipt;
    int count = 1;
    do {
      await Future.delayed(const Duration(seconds: 1));
      receipt = await getTransactionReceipt(asset, txHash);
    } while (receipt == null && count++ < kWaitForReceiptTimeoutInSecond);
    return receipt?.status ?? false;
  }
}
