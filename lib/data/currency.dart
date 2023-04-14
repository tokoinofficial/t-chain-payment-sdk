import 'package:json_annotation/json_annotation.dart';

/// Type of fiat currencies that are supported
enum Currency {
  /// Indonesian Rupiah
  @JsonValue('IDR')
  idr,

  /// US Dollar
  @JsonValue('USD')
  usd,

  /// Vietnamese Dong
  @JsonValue('VND')
  vnd,
}

extension CurrencyExt on Currency {
  String get shortName {
    switch (this) {
      case Currency.usd:
        return 'USD';
      case Currency.idr:
        return 'IDR';
      case Currency.vnd:
        return 'VND';
    }
  }

  String get name {
    switch (this) {
      case Currency.usd:
        return 'US Dollar';
      case Currency.idr:
        return 'Indonesian Rupiah';
      case Currency.vnd:
        return 'Vietnamese Dong';
    }
  }

  String get icon {
    switch (this) {
      case Currency.usd:
        return 'assets/currency_usd.svg';
      case Currency.idr:
        return 'assets/currency_idr.svg';
      case Currency.vnd:
        return 'assets/currency_vnd.svg';
    }
  }

  bool get available {
    return this == Currency.usd || this == Currency.idr;
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
