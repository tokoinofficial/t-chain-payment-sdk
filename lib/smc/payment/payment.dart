import 'package:t_chain_payment_sdk/config/utils.dart';
import 'package:t_chain_payment_sdk/data/payment_discount_fee.dart';
import 'package:web3dart/web3dart.dart';

abstract class BasePayment {
  Future<Transaction> buildContractTransaction({
    String privateKey = '',
    String functionName = '',
    required List parameters,
    num gasPrice = 0,
  });

  Future<num> getDepositFee();

  Future<PaymentDiscountInfo> getDiscountFee({
    required String tokenAddress,
    required num amount,
  });

  Future<String> sendRawTransaction({
    required String privateKey,
    required Transaction transaction,
  });

  bool isValidParams({
    String privateKey = 'privateKey',
    String address = 'address',
    String token = 'token',
    String functionName = 'functionName',
    num value = 1,
    num gasPrice = 1,
  }) {
    if (Utils.isEmptyString(privateKey) ||
        Utils.isEmptyString(address) ||
        Utils.isEmptyString(token) ||
        Utils.isEmptyString(functionName) ||
        gasPrice == 0 ||
        value == 0) {
      return false;
    }
    return true;
  }
}
