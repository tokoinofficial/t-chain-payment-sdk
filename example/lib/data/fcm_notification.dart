import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

class FcmNotification {
  TChainPaymentResult? result;

  FcmNotification({
    this.result,
  });

  static const keyTransactionHash = 'tnx_hash';
  static const keyStatus = 'status';
  static const keyOrderID = 'order_id';

  FcmNotification.fromMap(Map<String, dynamic> map) {
    TChainPaymentStatus status = int.tryParse(map[keyStatus] ?? '') == 2
        ? TChainPaymentStatus.success
        : TChainPaymentStatus.proceeding;
    result = TChainPaymentResult(
      status: status,
      orderID: map[keyOrderID] as String? ?? '',
      transactionID: map[keyTransactionHash] as String?,
    );
  }
}
