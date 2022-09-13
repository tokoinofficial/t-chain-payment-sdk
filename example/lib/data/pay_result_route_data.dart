class PayResultRouteData {
  const PayResultRouteData({
    required this.orderID,
    required this.amount,
    required this.useQRCode,
  });

  final String orderID;
  final double amount;
  final bool useQRCode;
}
