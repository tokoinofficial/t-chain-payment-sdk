enum TChainPaymentStatus {
  // payment has been succeeded
  success,

  // be cancelled by user
  cancelled,

  // payment has been failed
  failed,

  // payment's proceeding but it takes a long time to get the final result.
  // You should use tnx to continue checking the status
  proceeding,

  // waiting for user interaction
  waiting,

  // error: Invalid parameter ...
  error,
}

class TChainPaymentResult {
  TChainPaymentResult({
    required this.status,
    this.transactionID,
    this.orderID,
    this.errorMessage,
  });

  final TChainPaymentStatus status;
  final String? orderID;
  final String? transactionID;
  final String? errorMessage;
}
