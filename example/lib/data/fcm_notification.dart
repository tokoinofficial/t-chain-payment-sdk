import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

class FcmNotification {
  TChainPaymentResult? result;

  FcmNotification({
    this.result,
  });

  static const KEY_KEY = 'key';

  FcmNotification.fromMap(Map<String, dynamic> map) {
    result = map[KEY_KEY];
  }
}
