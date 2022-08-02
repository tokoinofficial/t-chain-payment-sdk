enum TWPaymentAction {
  deposit,
  withdraw,
}

extension TWPaymentActionExtension on TWPaymentAction {
  String get path {
    switch (this) {
      case TWPaymentAction.deposit:
        return 'payment_deposit';
      case TWPaymentAction.withdraw:
        return 'payment_withdraw';
    }
  }

  String get icon {
    switch (this) {
      case TWPaymentAction.deposit:
        return 'otc';
      case TWPaymentAction.withdraw:
        return 'send_toko';
    }
  }
}
