import 'package:flutter/services.dart';

class CONST {
  // Network Type
  static const NETWORK_TYPE_ETH = 1;
  static const NETWORK_TYPE_BSC = 2;
  static const NETWORK_TYPE_BTC = 3;
  static const NETWORK_TYPE = {
    "$NETWORK_TYPE_ETH": 'ETH',
    "$NETWORK_TYPE_BSC": 'BSC',
    "$NETWORK_TYPE_BTC": 'BTC'
  };

  static const NETWORK_TYPE_FEE = {
    "$NETWORK_TYPE_ETH": 'ETH',
    "$NETWORK_TYPE_BSC": 'BNB',
    "$NETWORK_TYPE_BTC": 'BTC'
  };

  static const kAssetNameBTC = 'BTC';
  static const kAssetNameBNB = 'BNB';
  static const kAssetNameETH = 'ETH';
  static const kAssetNameTOKO = 'TOKO';
  static const kAssetNameUSDT = 'USDT';
  static const kAssetNameCAKE = 'CAKE';
  static const kAssetNameBUSD = 'BUSD';
  static const kAssetNameTKO = 'TKO';
  static const kAssetNameSZO = 'SZO';
  static const kAssetNameDEP = 'DEP';
  static const kAssetNameDOT = 'DOT';
  static const kAssetNameDOGE = 'DOGE';
  static const kAssetNameC98 = 'C98';

  static const kAssetFullnameMap = {
    kAssetNameBTC: 'Bitcoin',
    kAssetNameBNB: 'Binance',
    kAssetNameETH: 'Ethereum',
    kAssetNameTOKO: 'Tokoin',
    kAssetNameUSDT: 'Tether',
    kAssetNameCAKE: 'PancakeSwap',
    kAssetNameBUSD: 'Binance USD',
    kAssetNameTKO: 'Tokocrypto Token',
    kAssetNameSZO: 'ShuttleOne',
    kAssetNameDEP: 'DEAPcoin',
    kAssetNameDOT: 'Polkadot',
    kAssetNameDOGE: 'Dogecoin',
    kAssetNameC98: 'Coin98',
  };

  static const kAssetIconMap = {
    kAssetNameBTC: 'assets/token_btc.svg',
    kAssetNameBNB: 'assets/token_bnb.svg',
    kAssetNameETH: 'assets/token_eth.svg',
    kAssetNameTOKO: 'assets/token_toko.svg',
    kAssetNameUSDT: 'assets/token_usdt.svg',
    kAssetNameCAKE: 'assets/token_cake.svg',
    kAssetNameBUSD: 'assets/token_busd.svg',
    kAssetNameTKO: 'assets/tko.svg',
    kAssetNameSZO: 'assets/szo.svg',
    kAssetNameDEP: 'farming_dep',
    kAssetNameDOT: 'farming_dot',
    kAssetNameDOGE: 'farming_doge',
    kAssetNameC98: 'farming_c98',
  };
}

const WAIT_FOR_RECEIPT_TIMEOUT_IN_SECOND = 300;
