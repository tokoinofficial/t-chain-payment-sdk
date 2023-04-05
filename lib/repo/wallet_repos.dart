import 'dart:async';
import 'dart:convert';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/config/const.dart';
import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/gas_fee.dart';
import 'package:t_chain_payment_sdk/data/payment_discount_fee.dart';
import 'package:t_chain_payment_sdk/services/blockchain_service.dart';
import 'package:uuid/uuid.dart';
import 'package:web3dart/web3dart.dart' as web3dart;

class WalletRepository {
  final BlockchainService blockchainService;
  late web3dart.Web3Client? web3Client;

  WalletRepository({required this.blockchainService}) {
    setup();
  }

  setup() async {
    web3Client ??=
        await blockchainService.createWeb3Client(Config.binanceDataSeed);
  }

  Future<num> balanceOf(Asset asset) async {
    return 10;
    // TODO
    // final wallet = asset.wallet;
    // if (wallet == null) return 0;
    // return await web3Client?.getBalance(address).balanceOf(
    //       privateKey: asset.wallet!.privateKey!,
    //       address: asset.wallet!.address,
    //     );
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
    // TODO
    // return await web3Client.getTxReceipt(txHash);
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

  /*
    Get gas fees based on wallet type
  */

  static const k_BSC_GAS_STATION = 'k_BSC_GAS_STATION';
  static const k_BSC_STORED_TIME = 'k_BSC_STORED_TIME';

  _isNeedToCallBscGasStation() {
    // TODO
    // var timeInCache = Storage.instance.getInt(k_BSC_STORED_TIME);
    // var dat = Storage.instance.getString(k_BSC_GAS_STATION);

    // if (timeInCache > 0 &&
    //     timeInCache + kFIFTEEN_SECONDS >
    //         Utils.instance.currentTimeInSeconds()) {
    //   if (!Utils.instance.isEmptyString(dat)) {
    //     return false;
    //   }
    // }

    // return true;
  }

  Future<bool> isEnoughBnb(
    Asset asset,
    num amount,
    num gasPrice,
    num estimatedGas,
  ) async {
    return true;
    // TODO
    // var isEnoughBnb = true;
    // Wallet wallet = asset.wallet!;
    // if (wallet.isBSC) {
    //   if (estimatedGas > Config.maxGas) {
    //     estimatedGas = Config.maxGas;
    //   }
    //   var bscClient = BnbBsc.instance;
    //   var balanceOfBnb = await bscClient.balanceOf(
    //       privateKey: wallet.privateKey!, address: wallet.address);
    //   if (asset is BnbAsset) {
    //     if (balanceOfBnb == 0 ||
    //         balanceOfBnb <
    //             amount +
    //                 num.parse(
    //                     GasFeeAverage(gasPrice, 0).toEthString(estimatedGas))) {
    //       isEnoughBnb = false;
    //     }
    //   } else {
    //     if (balanceOfBnb == 0 ||
    //         balanceOfBnb <
    //             num.parse(
    //                 GasFeeAverage(gasPrice, 0).toEthString(estimatedGas))) {
    //       isEnoughBnb = false;
    //     }
    //   }
    // }

    // return isEnoughBnb;
  }

  Future<List<GasFee>> getBSCGasFees() async {
    return [GasFeeAverage(10, 100000)];
    /*
    The current minimum gas price is 15 Gwei.
    Since the latest adjustment of gas price, BNB price has doubled.
    The proposed minimum gas price is 10 Gwei.
     */
    // TODO
    // const MINIMUM_GAS_PRICE_IN_BSC = 10;
    // var map;
    // if (_isNeedToCallBscGasStation()) {
    //   var response = await gasStationAPI.bscGas();
    //   map = response.data;

    //   await Storage.instance.saveString(k_BSC_GAS_STATION, json.encode(map));
    //   await Storage.instance
    //       .saveInt(k_BSC_STORED_TIME, Utils.instance.currentTimeInSeconds());
    // } else {
    //   var dat = Storage.instance.getString(k_BSC_GAS_STATION);
    //   map = json.decode(dat);
    // }

    // int gasPrice = GasFee.parseBscGasPrice(map['result'] ?? 0);
    // if (gasPrice < MINIMUM_GAS_PRICE_IN_BSC) {
    //   gasPrice = MINIMUM_GAS_PRICE_IN_BSC;
    // }
    // GasFee gasFee = GasFeeAverage(gasPrice, DEFAULT_BSC_WAIT_MINUTES);

    // return [gasFee];
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
    // TODO
    // await TChainPayment.instance.initiatePaymentContract(
    //   Config.binanceDataSeed,
    //   Config.paymentContractAddress,
    // );
  }

  Future<web3dart.Transaction> buildPaymentContractTransaction({
    required Asset asset,
    required String functionName,
    required List parameters,
    required num gasPrice,
  }) async {
    return web3dart.Transaction();
    // TODO
    // Wallet wallet = asset.wallet!;
    // return await TChainPayment.instance.buildContractTransaction(
    //   privateKey: wallet.privateKey!,
    //   functionName: functionName,
    //   parameters: parameters,
    //   gasPrice: gasPrice,
    // );
  }

  Future<num> getPaymentDepositFee() async {
    return 0;
    // TODO
    // return await TChainPayment.instance.getDepositFee();
  }

  Future<PaymentDiscountInfo?> getPaymentDiscountFee({
    required String contractAddress,
    required num amount,
  }) async {
    return const PaymentDiscountInfo(discountFeePercent: 0, deductAmount: 0);
    // TODO
    // return await TChainPayment.instance.getDiscountFee(
    //   tokenAddress: contractAddress,
    //   amount: amount,
    // );
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

  Future<String> sendPaymentTransaction(
    Asset asset,
    web3dart.Transaction tx,
  ) async {
    return '';
    // TODO
    // var hash = await TChainPayment.instance.sendRawTransaction(
    //     privateKey: asset.wallet!.privateKey!, transaction: tx);
    // log.d('sendPaymentTransaction hash $hash');
    // return hash;
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
    } while (receipt == null && count++ < WAIT_FOR_RECEIPT_TIMEOUT_IN_SECOND);
    return receipt?.status ?? false;
  }
}
