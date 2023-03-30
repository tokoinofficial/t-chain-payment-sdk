import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

class PayResultRouteData {
  const PayResultRouteData({
    required this.notes,
    required this.amount,
    required this.currency,
    required this.useQRCode,
  });

  final String notes;
  final double amount;
  final TChainPaymentCurrency currency;
  final bool useQRCode;
}
