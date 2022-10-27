class PayResultRouteData {
  const PayResultRouteData({
    required this.notes,
    required this.amount,
    required this.useQRCode,
  });

  final String notes;
  final double amount;
  final bool useQRCode;
}
