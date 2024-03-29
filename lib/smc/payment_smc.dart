import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/common/transaction_waiter.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:math' as math;

import 'package:t_chain_payment_sdk/data/payment_discount_fee.dart';
import 'package:t_chain_payment_sdk/common/tokoin_number.dart';

class PaymentSmc extends GeneratedContract {
  static const kMaximumFee = 10000;

  PaymentSmc({
    required ContractAbi contractAbi,
    required EthereumAddress address,
    required Web3Client client,
    required int? chainId,
  }) : super(DeployedContract(contractAbi, address), client, chainId);

  Future<num> getDepositFee() async {
    final function = self.function('depositFee');
    final params = [];
    final response = await read(function, params, null);

    BigInt fee = response.first;

    return _toPercent(fee.toDouble());
  }

  Future<PaymentDiscountInfo> getDiscountFee({
    required String tokenAddress,
    required num amount,
  }) async {
    final function = self.function('getDiscountFee');
    final params = [
      EthereumAddress.fromHex(tokenAddress),
      TokoinNumber.fromNumber(amount).bigIntValue,
    ];

    final response = await read(function, params, null);

    BigInt discountFee = response[0];
    final deductAmount =
        TokoinNumber.fromBigInt(response[1], exponent: kEthPowExponent)
            .doubleValue;

    return PaymentDiscountInfo(
      discountFeePercent: _toPercent(discountFee.toDouble()),
      deductAmount: deductAmount.toDouble(),
    );
  }

  Future<BigInt> debugDepositFee({
    required String tokenAddress,
    required num amount,
  }) async {
    final function = self.function('debugDepositFee');
    final params = [
      EthereumAddress.fromHex(tokenAddress),
      TokoinNumber.fromNumber(amount).bigIntValue,
    ];
    final response = await read(function, params, null);

    return response.first;
  }

  Future<Transaction> buildDepositTransaction({
    required EthPrivateKey privateKey,
    required List parameters,
    num gasPrice = 0,
  }) async {
    var address = privateKey.address;
    var nextNonce = await client.getTransactionCount(address,
        atBlock: const BlockNum.pending());
    return Transaction.callContract(
      contract: self,
      gasPrice: EtherAmount.fromBigInt(EtherUnit.gwei, BigInt.from(gasPrice)),
      maxGas: Config.maxGas,
      function: self.function('deposit'),
      parameters: parameters,
      nonce: nextNonce,
    );
  }

  Future<String> sendRawTransaction({
    required EthPrivateKey privateKey,
    required Transaction transaction,
  }) async {
    return await transactionWaiter.ready(() async {
      var credentials = privateKey;
      return await client.sendTransaction(
        credentials,
        transaction,
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );
    });
  }

  double _toPercent(num value) {
    final limitedValue = math.max(0, math.min(kMaximumFee, value));

    return limitedValue / kMaximumFee * 100;
  }
}
