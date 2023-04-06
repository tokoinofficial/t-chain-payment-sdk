import 'dart:async';
import 'dart:convert';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/config/const.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/gas_fee.dart';
import 'package:t_chain_payment_sdk/data/payment_discount_fee.dart';
import 'package:t_chain_payment_sdk/services/blockchain_service.dart';
import 'package:t_chain_payment_sdk/services/gas_station_api.dart';
import 'package:t_chain_payment_sdk/smc/bep_20_smc.dart';
import 'package:t_chain_payment_sdk/smc/payment_smc.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart' as web3dart;
import 'package:web3dart/web3dart.dart';

const kWaitForReceiptTimeoutInSecond = 300;

class WalletRepository {
  final gasStationAPI = GasStationAPI();
  final BlockchainService blockchainService;
  web3dart.Web3Client? _web3Client;
  final Map<String, Bep20Smc> _bep20SmcMap = {};
  PaymentSmc? _paymentSmc;

  WalletRepository({required this.blockchainService}) {
    _setup();
  }

  _setup() async {
    _web3Client ??=
        await blockchainService.createWeb3Client(Config.binanceDataSeed);
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
    return value.toDouble();
  }

  Future<String> sendTransaction(
    Asset asset,
    String destAddress,
    num value,
    num gasPrice,
    num gasLimit,
    int? nonce,
  ) async {
    return '';
    // TODO
    // Wallet wallet = asset.wallet!;
    // return await asset.client.transfer(
    //   privateKey: wallet.privateKey!,
    //   fromAddress: wallet.address,
    //   destAddress: destAddress,
    //   value: value,
    //   gasPrice: gasPrice,
    //   gasLimit: gasLimit,
    //   nonce: nonce,
    // );
  }

  Future<num> allowance(Asset asset, String contractAddress) async {
    return 100000;
    // TODO
    // BaseToken client = asset is BnbBscAsset ? WbnbAsset().client : asset.client;
    // return await client.allowance(
    //     address: asset.wallet!.address!, contractAddress: contractAddress);
  }

  Future<web3dart.TransactionReceipt?> getTransactionReceipt(
      Asset asset, String txHash) async {
    return await _web3Client!.getTransactionReceipt(txHash);
  }

  Future<String> approveDeposit(
    Asset asset,
    num gasPrice,
    num gasLimit,
    String contractAddress,
  ) async {
    return '';
    // TODO
    // // crowdfunding uses token registry contract for sending TOKO token
    // BaseToken client = asset is BnbBscAsset ? WbnbAsset().client : asset.client;
    // return await client.approve(
    //   privateKey: asset.wallet!.privateKey!,
    //   contractAddress: contractAddress,
    //   gasPrice: gasPrice,
    //   gasLimit: gasLimit,
    // );
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
                  num.parse(
                      GasFeeAverage(gasPrice, 0).toEthString(estimatedGas))) {
        isEnoughBnb = false;
      }
    } else {
      if (balanceOfBnb == 0 ||
          balanceOfBnb <
              num.parse(GasFeeAverage(gasPrice, 0).toEthString(estimatedGas))) {
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
    GasFee gasFee = GasFeeAverage(gasPrice, DEFAULT_BSC_WAIT_MINUTES);

    return [gasFee];
  }

  Future<web3dart.Transaction> buildTransferTransaction(
    Asset asset,
    String destAddress,
    num value,
    num gasPrice,
    int? nonce,
  ) async {
    return web3dart.Transaction();
    // TODO
    // Wallet wallet = asset.wallet!;
    // return await asset.client.buildTransferTransaction(
    //   privateKey: wallet.privateKey!,
    //   fromAddress: wallet.address!,
    //   destAddress: destAddress,
    //   value: value,
    //   gasPrice: gasPrice,
    //   nonce: nonce,
    // );
  }

  Future setupPaymentContract() async {
    getPaymentSmc();
  }

  Future<web3dart.Transaction> buildDepositTransaction({
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
    return BigInt.zero;
    // TODO
    // return await TChainPayment.instance.debugDepositFee(
    //   tokenAddress: asset is BnbBscAsset
    //       ? Config.bnbContractAddress
    //       : asset.contractAddress,
    //   amount: amount,
    // );
  }

  Future<String> sendPaymentTransaction({
    required String privateKeyHex,
    required web3dart.Transaction tx,
  }) async {
    final smc = await getPaymentSmc();
    final hash = await smc.sendRawTransaction(
        privateKey: privateKeyHex, transaction: tx);

    debugPrint('sendPaymentTransaction hash $hash');

    return hash;
  }

  Future<web3dart.Transaction> buildContractTransaction(
    Asset asset,
    String functionName,
    List parameters,
    num gasPrice,
    int? nonce,
  ) async {
    return web3dart.Transaction();
    // TODO
    // Wallet wallet = asset.wallet!;
    // return await asset.stakeClient.buildContractTransaction(
    //   privateKey: wallet.privateKey!,
    //   functionName: functionName,
    //   parameters: parameters,
    //   gasPrice: gasPrice,
    //   nonce: nonce,
    // );
  }

  Future<web3dart.Transaction> buildApproveTransaction(
    Asset asset,
    String functionName,
    List parameters,
    num gasPrice,
    int? nonce,
  ) async {
    return web3dart.Transaction();
    // TODO
    // Wallet wallet = asset.wallet!;
    // BaseToken client = asset is BnbBscAsset ? WbnbAsset().client : asset.client;
    // return await client.buildContractTransaction(
    //   privateKey: wallet.privateKey!,
    //   functionName: functionName,
    //   parameters: parameters,
    //   gasPrice: gasPrice,
    //   nonce: nonce,
    // );
  }

  Future<num> estimateGas(
    Asset asset,
    web3dart.Transaction transaction,
  ) async {
    return 0;
    // TODO
    // num gas = await asset.client.estimateGas(
    //   sender: asset.wallet!.address!,
    //   transaction: transaction,
    // );
    // // by * 20%, we'll make sure the gas limit is enough for covering this transaction
    // gas = gas + (gas * 20 / 100);
    // print('>>>>>>>>> estimateGas = $gas');
    // return gas;
  }

  // Future setupSwapContractSupportBNB() async {
  //   await Wbnb.instance.initiateContract(
  //     Config.binanceDataSeed,
  //     Config.wbnbContractAddress,
  //     abiName: 'bep20.json',
  //   );
  // }

  // Future<BigInt?> getSwapAmountOut({required PancakeSwap pancakeSwap}) async {
  //   BaseSwap client = Asset().swapClient;
  //   return await client.getAmountOut(
  //     amountIn: pancakeSwap.amountIn!,
  //     paths: _getPaths(pancakeSwap),
  //   );
  // }

  // Future<BigInt?> getSwapAmountIn({required PancakeSwap pancakeSwap}) async {
  //   BaseSwap client = Asset().swapClient;
  //   return await client.getAmountIn(
  //     amountOut: pancakeSwap.amountOut!,
  //     paths: _getPaths(pancakeSwap),
  //   );
  // }

  // Future<String> swap(
  //     {required num gasPrice,
  //     required num gasLimit,
  //     required PancakeSwap pancakeSwap,
  //     required web3dart.Transaction tx}) async {
  //   BaseSwap client = pancakeSwap.assetIn.swapClient;
  //   Wallet wallet = pancakeSwap.assetIn.wallet!;
  //   /*
  //     To avoid the error of decimal number
  //     If user send value = current balance, we subtract the value with epsilon number
  //   */
  //   num balance = await pancakeSwap.assetIn.client
  //       .balanceOf(address: wallet.address, privateKey: wallet.privateKey!);
  //   if (pancakeSwap.amountIn == balance) {
  //     var epsilon = 0.000000001;
  //     pancakeSwap.amountIn = (pancakeSwap.amountIn! - epsilon);
  //   }

  //   var hash = await client.sendRawTransaction(
  //       privateKey: wallet.privateKey!, transaction: tx);
  //   return hash;
  // }

  // the `swapExactETHForTokens` function requires input amountIn as value in transaction
  // _isPayableFunction(String functionName) =>
  //     functionName == 'swapExactETHForTokens';

  // Future<web3dart.Transaction> buildSwapContractTransaction(
  //     {required PancakeSwap pancakeSwap,
  //     required num gasPrice,
  //     int? nonce}) async {
  //   Wallet wallet = pancakeSwap.assetIn.wallet!;
  //   List parameters = [
  //     TokoinNumber.fromNumber(
  //             pancakeSwap.amountOut! * (100 - MAX_SLIPPAGE) / 100)
  //         .toTokoinNumberWithAsset(pancakeSwap.assetOut)
  //         .bigIntValue,
  //     _getPaths(pancakeSwap)
  //         .map((e) => web3dart.EthereumAddress.fromHex(e))
  //         .toList(),
  //     web3dart.EthereumAddress.fromHex(wallet.address ?? ''),
  //     BaseSwap.deadline
  //   ];
  //   String functionName = _getFunctionName(pancakeSwap);
  //   bool isPayableFunction = _isPayableFunction(functionName);
  //   BigInt amountIn = TokoinNumber.fromNumber(pancakeSwap.amountIn ?? 0)
  //       .toTokoinNumberWithAsset(pancakeSwap.assetIn)
  //       .bigIntValue;
  //   if (!isPayableFunction) parameters.insert(0, amountIn);
  //   return await pancakeSwap.assetIn.swapClient.buildContractTransaction(
  //       privateKey: wallet.privateKey!,
  //       functionName: _getFunctionName(pancakeSwap),
  //       parameters: parameters,
  //       gasPrice: gasPrice,
  //       nonce: nonce,
  //       value: isPayableFunction ? amountIn : null);
  // }

  // String _getFunctionName(PancakeSwap pancakeSwap) {
  //   if (pancakeSwap.assetIn is BnbBscAsset)
  //     return 'swapExactETHForTokens';
  //   else if (pancakeSwap.assetOut is BnbBscAsset)
  //     return 'swapExactTokensForETH';
  //   else
  //     return 'swapExactTokensForTokens';
  // }

  // List<String> _getPaths(PancakeSwap pancakeSwap) {
  //   Asset assetOut = pancakeSwap.assetOut;
  //   Asset assetIn = pancakeSwap.assetIn;
  //   bool withoutBridge = (assetOut is UsdtBscAsset ||
  //       assetIn is UsdtBscAsset ||
  //       assetIn is TkoBscAsset ||
  //       assetOut is TkoBscAsset);

  //   if (assetOut is BnbBscAsset) assetOut = WbnbAsset();
  //   if (assetIn is BnbBscAsset) assetIn = WbnbAsset();
  //   return withoutBridge
  //       ? [assetIn.contractAddress, assetOut.contractAddress]
  //       : [
  //           assetIn.contractAddress,
  //           Config.bscUsdtContractAddress,
  //           assetOut.contractAddress
  //         ];
  // }

  Future<bool> waitForReceiptResult(Asset asset, String txHash) async {
    late web3dart.TransactionReceipt? receipt;
    int count = 1;
    do {
      await Future.delayed(const Duration(seconds: 1));
      receipt = await getTransactionReceipt(asset, txHash);
    } while (receipt == null && count++ < kWaitForReceiptTimeoutInSecond);
    return receipt?.status ?? false;
  }
}
