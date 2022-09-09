enum TChainPaymentAction {
  deposit,
  withdraw,
}

extension TChainPaymentActionExtension on TChainPaymentAction {
  String get path {
    switch (this) {
      case TChainPaymentAction.deposit:
        return 'payment_deposit';
      case TChainPaymentAction.withdraw:
        return 'payment_withdraw';
    }
  }
}
