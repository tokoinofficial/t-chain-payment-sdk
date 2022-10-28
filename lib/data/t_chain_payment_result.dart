/// The status of payment
enum TChainPaymentStatus {
  /// Payment has been succeeded
  success,

  /// Be cancelled by user
  cancelled,

  /// Payment has been failed
  failed,

  /// Payment's proceeding but it takes a long time to get the final result.
  /// You should use tnx to continue checking the status
  proceeding,

  /// Waiting for user interaction
  waiting,

  /// Error: Invalid parameter ...
  error,
}

/// The returning data when you perform [deposit], [generateQrCode], [withdraw]
class TChainPaymentResult {
  TChainPaymentResult({
    required this.status,
    required this.notes,
    this.transactionID,
    this.errorMessage,
  });

  /// The status of payment
  final TChainPaymentStatus status;

  /// Unique id of each order. It is called offchain in blockchain terms.
  final String notes;

  /// Use to track your transaction on testnet or mainnet
  /// It's null if the status is one of `cancelled`, `waiting`, or `error`
  final String? transactionID;

  /// An error during perform t-chain payment function.
  /// It's value only if the status's `error`
  final String? errorMessage;
}
