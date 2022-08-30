enum TChainPaymentStatus {
  success,
  cancelled,
  failed,
  proceeding,
  waiting,
  error,
}

class TChainPaymentResult {
  TChainPaymentResult({
    required this.status,
    this.transactionID,
    this.orderID,
  });

  final TChainPaymentStatus status;
  final String? orderID;
  final String? transactionID;
}
