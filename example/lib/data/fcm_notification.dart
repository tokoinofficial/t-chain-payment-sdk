import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

class FcmNotification {
  TChainPaymentResult? result;

  FcmNotification({
    this.result,
  });

  static const keyTransactionHash = 'tnx_hash';
  static const keyStatus = 'status';

  FcmNotification.fromMap(Map<String, dynamic> map) {
    TChainPaymentStatus status = map[keyStatus] == 2
        ? TChainPaymentStatus.success
        : TChainPaymentStatus.proceeding;
    result = TChainPaymentResult(
        status: status, transactionID: map[keyTransactionHash]);
  }
}
