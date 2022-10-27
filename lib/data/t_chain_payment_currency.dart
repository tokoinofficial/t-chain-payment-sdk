/// Type of fiat currencies that are supported
enum TChainPaymentCurrency {
  // US Dollar
  usd,
  // Indonesian Rupiah
  idr,
}

extension TChainPaymentCurrencyExtension on TChainPaymentCurrency {
  String get shortName {
    switch (this) {
      case TChainPaymentCurrency.usd:
        return 'USD';
      case TChainPaymentCurrency.idr:
        return 'IDR';
    }
  }
}
