enum TWPaymentResultStatus {
  success,
  cancelled,
  failed,
  proceeding,
  waiting,
  error,
}

class TWPaymentResult {
  TWPaymentResult({
    required this.status,
    this.transactionID,
    this.orderID,
  });

  final TWPaymentResultStatus status;
  final String? orderID;
  final String? transactionID;
}
