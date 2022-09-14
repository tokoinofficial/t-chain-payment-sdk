/// Action is what user want to do when using payment SDK
enum TChainPaymentAction {
  /// usecase:
  /// - deposit your money to in-game currency
  /// - pay for an order
  deposit,

  /// usecase: you want to take money out of your game wallet
  withdraw,
}

extension TChainPaymentActionExtension on TChainPaymentAction {
  /// Configure the path of the deep link
  String get path {
    switch (this) {
      case TChainPaymentAction.deposit:
        return 'payment_deposit';
      case TChainPaymentAction.withdraw:
        return 'payment_withdraw';
    }
  }
}
