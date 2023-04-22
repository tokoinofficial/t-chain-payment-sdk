import 'package:t_chain_payment_sdk/gen/assets.gen.dart';

class CONST {
  static const kAssetNameBNB = 'BNB';
  static const kAssetNameTOKO = 'TOKO';
  static const kAssetNameUSDT = 'USDT';
  static const kAssetNameBUSD = 'BUSD';

  static const kAssetFullnameMap = {
    kAssetNameBNB: 'Binance',
    kAssetNameTOKO: 'Tokoin',
    kAssetNameUSDT: 'Tether',
    kAssetNameBUSD: 'Binance USD',
  };

  static const kAssetIconMap = {
    kAssetNameBNB: Assets.tokenBnb,
    kAssetNameTOKO: Assets.tokenToko,
    kAssetNameUSDT: Assets.tokenUsdt,
    kAssetNameBUSD: Assets.tokenBusd,
  };

  static const policyUrl = 'https://tokoin.io/docs/privacy-policy';

  static const supportEmail = 'hello@tokoin.io';
}
