/// Action is what user want to do when using payment SDK
enum TChainPaymentAction {
  /// Use case:
  /// - deposit your money to in-game currency
  /// - pay for an order
  deposit,

  /// Use case: user want to take money out of their game wallet
  withdraw,
}
