import 'package:web3dart/web3dart.dart';
import 'dart:math' as math;

import 'package:t_chain_payment_sdk/data/payment_discount_fee.dart';
import 'package:t_chain_payment_sdk/helpers/tokoin_number.dart';

class PaymentSmc extends GeneratedContract {
  static const kMaximumFee = 10000;

  PaymentSmc({
    required ContractAbi contractAbi,
    required EthereumAddress address,
    required Web3Client client,
    required int? chainId,
  }) : super(DeployedContract(contractAbi, address), client, chainId);

  Future<BigInt> getBalance(
    EthereumAddress walletAddress, {
    BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[0];

    final params = [walletAddress];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  // @override
  // Future<Transaction> buildContractTransaction({
  //   String privateKey = '',
  //   String functionName = '',
  //   required List parameters,
  //   num gasPrice = 0,
  // }) {
  //   if (!isValidParams(
  //       privateKey: privateKey,
  //       gasPrice: gasPrice,
  //       functionName: functionName)) {
  //     throw Exception(LocaleKeys.error_invalid_params.tr());
  //   }

  //   return _contractTransaction.buildContractTransaction(
  //     privateKey: privateKey,
  //     functionName: functionName,
  //     parameters: parameters,
  //     gasPrice: gasPrice,
  //   );
  // }

  Future<num> getDepositFee() async {
    final function = self.abi.functions[1];
    final params = [];
    final response = await read(function, params, null);

    BigInt fee = response.first;

    return _toPercent(fee.toDouble());
  }

  // Future<BigInt> debugDepositFee({//3
  //   required String tokenAddress,
  //   required num amount,
  // }) async {
  //   List<dynamic> results = await _contractTransaction.call(
  //     functionName: 'debugDepositFee',
  //     parameters: [
  //       EthereumAddress.fromHex(tokenAddress),
  //       TokoinNumber.fromNumber(amount).bigIntValue,
  //     ],
  //   );

  //   return results.first;
  // }

  Future<PaymentDiscountInfo> getDiscountFee({
    required String tokenAddress,
    required num amount,
  }) async {
    final function = self.abi.functions[2];
    final params = [
      EthereumAddress.fromHex(tokenAddress),
      TokoinNumber.fromNumber(amount).bigIntValue,
    ];

    final response = await read(function, params, null);

    BigInt discountFee = response[0];
    final deductAmount =
        TokoinNumber.fromBigInt(response[1], exponent: ETH_POW_EXPONENT)
            .doubleValue;

    return PaymentDiscountInfo(
      discountFeePercent: _toPercent(discountFee.toDouble()),
      deductAmount: deductAmount.toDouble(),
    );
  }

  // @override
  // Future<String> sendRawTransaction({
  //   required String privateKey,
  //   required Transaction transaction,
  // }) async {
  //   return await _contractTransaction.sendRawTransaction(
  //     privateKey: privateKey,
  //     transaction: transaction,
  //   );
  // }

  double _toPercent(num value) {
    final limitedValue = math.max(0, math.min(kMaximumFee, value));

    return limitedValue / kMaximumFee * 100;
  }
}
