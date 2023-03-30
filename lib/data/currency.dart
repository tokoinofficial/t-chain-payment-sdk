import 'package:json_annotation/json_annotation.dart';

/// Type of fiat currencies that are supported
enum Currency {
  /// US Dollar
  @JsonValue('USD')
  usd,

  /// Indonesian Rupiah
  @JsonValue('IDR')
  idr,
}

extension CurrencyExt on Currency {
  String get shortName {
    switch (this) {
      case Currency.usd:
        return 'USD';
      case Currency.idr:
        return 'IDR';
    }
  }

  String get name {
    switch (this) {
      case Currency.usd:
        return 'US Dollar';
      case Currency.idr:
        return 'Indonesian Rupiah';
    }
  }

  String get icon {
    switch (this) {
      case Currency.usd:
        return 'currency_usd';
      case Currency.idr:
        return 'currency_idr';
    }
  }
}

extension CurrencyStringExt on String {
  Currency toCurrency() {
    var value = toUpperCase();
    return Currency.values.firstWhere(
      (element) => element.shortName == value,
      orElse: () => Currency.usd,
    );
  }
}
