import 'package:t_chain_payment_sdk/data/asset.dart';
import 'package:t_chain_payment_sdk/data/currency.dart';

class ExchangeRate {
  late Map<String, dynamic> map;

  ExchangeRate(this.map) {
    if (!map.containsKey(Currency.usd.shortName)) {
      map[Currency.usd.shortName] = 1.0;
    }
  }

  double? getUsdPerAsset(Asset asset) {
    final value = double.tryParse(map[asset.shortName].toString());
    return value;
  }

  double? getAssetPerUsd(Asset asset) {
    final value = double.tryParse(map[asset.shortName].toString());
    return value != null && value != 0 ? 1 / value : null;
  }

  double? getUsdPerFiatCurrency(Currency currency) {
    return double.tryParse(map[currency.shortName].toString());
  }

  double? calculateAssetAmount({
    required double amountCurrency,
    required Currency currency,
    required Asset asset,
  }) {
    final usdPerFiatCurrency = getUsdPerFiatCurrency(currency);
    if (usdPerFiatCurrency == null) return null;

    final usdPerAsset = getUsdPerAsset(asset);
    if (usdPerAsset == null) return null;

    final amountUsd = amountCurrency * usdPerFiatCurrency;
    final assetAmount = amountUsd / usdPerAsset;
    return assetAmount;
  }

  bool get hasData => map.keys.length > 1;
}
