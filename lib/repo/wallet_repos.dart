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
        await blockchainService.createWeb3Client(Config.binanceRpcNodes);

    return isReady;
  }

  Future<Bep20Smc> getBep20Smc(String addressHex) async {
    final smc = _bep20SmcMap[addressHex];

    if (smc != null) return smc;

    EthereumAddress address = EthereumAddress.fromHex(addressHex);
    final newSmc = await blockchainService.createBep20Smc(
      address: address,
      client: _web3Client!,
      chainId: Config.bscChainId,
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
      chainId: Config.bscChainId,
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
      chainId: Config.bscChainId,
    );

    _pancakeSwapSmc = newSmc;
    return newSmc;
  }

  Future<num> balanceOf({
    required String smcAddressHex,
    required EthPrivateKey privateKey,
  }) async {
    if (smcAddressHex.isEmpty) {
      // BNB
      EtherAmount balance = await _web3Client!.getBalance(privateKey.address);
      return balance.getValueInUnit(EtherUnit.ether);
    }
    final smc = await getBep20Smc(smcAddressHex);

    final value = await smc.getBalance(privateKey.address);

    return TokoinNumber.fromBigInt(value, exponent: kEthPowExponent)
        .doubleValue;
  }

  Future<num> allowance({
    required Asset asset,
    required EthPrivateKey privateKey,
    required String contractAddress,
  }) async {
    if (asset.isBnb) {
      // only check allowance if asset is bep20
      return double.maxFinite;
    }

    final smc = await getBep20Smc(asset.contractAddress);

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
    required EthPrivateKey privateKey,
    required Asset asset,
    required String contractAddress,
    required BigInt amount,
    num gasPrice = 0,
    int? nonce,
  }) async {
    if (asset.isBnb) {
      throw Exception('Required a bep20 token');
    }

    final smc = await getBep20Smc(asset.contractAddress);

    return await smc.buildApprovalTransaction(
      privateKey: privateKey,
      contractAddress: contractAddress,
      amount: amount,
      gasPrice: gasPrice,
      nonce: nonce,
    );
  }

  Future<String> sendApproval({
    required EthPrivateKey privateKey,
    required Asset asset,
    required String contractAddress,
    num gasPrice = 0,
    int? nonce,
  }) async {
    if (asset.isBnb) {
      throw Exception('Required a bep20 token');
    }

    final smc = await getBep20Smc(asset.contractAddress);

    final tnx = await buildApproveTransaction(
      privateKey: privateKey,
      asset: asset,
      contractAddress: contractAddress,
      amount: TokoinNumber.fromNumber(
        kDefaultApprovedValue,
        exponent: kEthPowExponent,
      ).bigIntValue,
      gasPrice: gasPrice,
      nonce: nonce,
    );

    return await smc.sendRawTransaction(
      privateKey: privateKey,
      transaction: tnx,
    );
  }

  Future<bool> isEnoughBnb({
    required EthPrivateKey privateKey,
    required Asset asset,
    required num amount,
    required num gasPrice,
    required num estimatedGas,
  }) async {
    var isEnoughBnb = true;

    if (estimatedGas > Config.maxGas) {
      estimatedGas = Config.maxGas;
    }

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
    int minimumGasPriceInBsc = Config.minGasPrice;

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
    required EthPrivateKey privateKey,
    required List parameters,
    required num gasPrice,
  }) async {
    final smc = await getPaymentSmc();
    return await smc.buildDepositTransaction(
      privateKey: privateKey,
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
      tokenAddress:
          contractAddress.isEmpty ? Config.bnbTokenAddress : contractAddress,
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
    required EthPrivateKey privateKey,
    required Transaction tx,
  }) async {
    final smc = await getPaymentSmc();
    final hash = await smc.sendRawTransaction(
      privateKey: privateKey,
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
    final paths = await _getPaths(pancakeSwap);
    return await smc.getAmountOut(
      amountIn: pancakeSwap.amountIn!,
      paths: paths,
    );
  }

  Future<BigInt?> getSwapAmountIn({required PancakeSwap pancakeSwap}) async {
    final smc = await getPancakeSwapSmc();
    final paths = await _getPaths(pancakeSwap);
    return await smc.getAmountIn(
      amountOut: pancakeSwap.amountOut!,
      paths: paths,
    );
  }

  Future<String> swap({
    required EthPrivateKey privateKey,
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
      privateKey: privateKey,
    );

    if (pancakeSwap.amountIn == balance) {
      var epsilon = 0.000000001;
      var amountIn = (pancakeSwap.amountIn! - epsilon);
      pancakeSwap.copyWith(amountIn: amountIn);
    }

    var hash = await smc.sendRawTransaction(
      privateKey: privateKey,
      transaction: tx,
    );
    return hash;
  }

  // the `swapExactETHForTokens` function requires input amountIn as value in transaction
  _isPayableFunction(String functionName) =>
      functionName == 'swapExactETHForTokens';

  Future<Transaction> buildSwapContractTransaction({
    required EthPrivateKey privateKey,
    required PancakeSwap pancakeSwap,
    required num gasPrice,
    int? nonce,
  }) async {
    final smc = await getPancakeSwapSmc();
    final paths = await _getPaths(pancakeSwap);

    List parameters = [
      TokoinNumber.fromNumber(
              pancakeSwap.amountOut! * (100 - kMaxSlippage) / 100)
          .bigIntValue,
      paths.map((e) => EthereumAddress.fromHex(e)).toList(),
      privateKey.address,
      PancakeSwapSmc.deadline
    ];
    String functionName = _getFunctionName(pancakeSwap);
    bool isPayableFunction = _isPayableFunction(functionName);
    BigInt amountIn =
        TokoinNumber.fromNumber(pancakeSwap.amountIn ?? 0).bigIntValue;
    if (!isPayableFunction) parameters.insert(0, amountIn);
    return await smc.buildSwapTransaction(
        privateKey: privateKey,
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

  Future<List<String>> _getPaths(PancakeSwap pancakeSwap) async {
    Asset assetOut = pancakeSwap.assetOut;
    Asset assetIn = pancakeSwap.assetIn;
    bool withoutBridge = assetOut.isUsdt || assetIn.isUsdt;

    String addressIn = assetIn.contractAddress;
    String addressOut = assetOut.contractAddress;

    EthereumAddress? weth;
    if (assetOut.isBnb) {
      final smc = await getPancakeSwapSmc();
      weth = await smc.getWETH();
      addressOut = weth.hex;
    }

    if (assetIn.isBnb) {
      if (weth != null) {
        addressIn = weth.hex;
      } else {
        final smc = await getPancakeSwapSmc();
        weth = await smc.getWETH();
        addressIn = weth.hex;
      }
    }

    return withoutBridge
        ? [addressIn, addressOut]
        : [addressIn, Config.bscUsdtContractAddress, addressOut];
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
