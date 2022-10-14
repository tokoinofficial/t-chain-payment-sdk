/// Type of fiat currencies that are supported
enum TChainPaymentCurrency {
  // Indonesian Rupiah
  idr,

  /// Vietnamese Dong
  vnd,
}

extension TChainPaymentCurrencyExtension on TChainPaymentCurrency {
  String get shortName {
    switch (this) {
      case TChainPaymentCurrency.idr:
        return 'IDR';
      case TChainPaymentCurrency.vnd:
        return 'VND';
    }
  }
}