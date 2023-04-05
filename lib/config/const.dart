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

  // Asset id
  static const ASSET_ID_BTC = 1;
  static const ASSET_ID_BNB = 1839;
  static const ASSET_ID_ETH = 1027;
  static const ASSET_ID_TOKO = 4299;
  static const ASSET_ID_USDT = 825;
  static const ASSET_ID_CAKE = 7186;
  static const ASSET_ID_BUSD = 4687;
  static const ASSET_ID_TKO = 9020;
  static const ASSET_ID_LP = 0;
  static const ASSET_ID_SZO = 99999;
  static const ASSET_ID_DEP = 5429;
  static const ASSET_ID_DOT = 6636;
  static const ASSET_ID_DOGE = 74;
  static const ASSET_ID_C98 = 10903;

  static const ASSET_FULLNAME = {
    "$ASSET_ID_BTC": 'Bitcoin',
    "$ASSET_ID_BNB": 'Binance',
    "$ASSET_ID_ETH": 'Ethereum',
    "$ASSET_ID_TOKO": 'Tokoin',
    "$ASSET_ID_USDT": 'Tether',
    "$ASSET_ID_CAKE": 'PancakeSwap',
    "$ASSET_ID_BUSD": 'Binance USD',
    "$ASSET_ID_TKO": 'Tokocrypto Token',
    "$ASSET_ID_LP": 'TOKO/WBNB',
    "$ASSET_ID_SZO": 'ShuttleOne',
    "$ASSET_ID_DEP": 'DEAPcoin',
    "$ASSET_ID_DOT": 'Polkadot',
    "$ASSET_ID_DOGE": 'Dogecoin',
    "$ASSET_ID_C98": 'Coin98',
  };

  static const ASSET_SHORTNAME = {
    "$ASSET_ID_BTC": 'BTC',
    "$ASSET_ID_BNB": 'BNB',
    "$ASSET_ID_ETH": 'ETH',
    "$ASSET_ID_TOKO": 'TOKO',
    "$ASSET_ID_USDT": 'USDT',
    "$ASSET_ID_CAKE": 'CAKE',
    "$ASSET_ID_BUSD": 'BUSD',
    "$ASSET_ID_TKO": 'TKO',
    "$ASSET_ID_LP": 'TOKO/WBNB',
    "$ASSET_ID_SZO": 'SZO',
    "$ASSET_ID_DEP": 'DEP',
    "$ASSET_ID_DOT": 'DOT',
    "$ASSET_ID_DOGE": 'DOGE',
    "$ASSET_ID_C98": 'C98',
  };

  static const ASSET_ICON_NAME = {
    "$ASSET_ID_BTC": 'assets/token_btc.svg',
    "$ASSET_ID_BNB": 'assets/token_bnb.svg',
    "$ASSET_ID_ETH": 'assets/token_eth.svg',
    "$ASSET_ID_TOKO": 'assets/token_toko.svg',
    "$ASSET_ID_USDT": 'assets/token_usdt.svg',
    "$ASSET_ID_CAKE": 'assets/token_cake.svg',
    "$ASSET_ID_BUSD": 'assets/token_busd.svg',
    "$ASSET_ID_TKO": 'assets/tko.svg',
    "$ASSET_ID_LP": 'assets/toko.svg',
    "$ASSET_ID_SZO": 'assets/szo.svg',
    "$ASSET_ID_DEP": 'farming_dep',
    "$ASSET_ID_DOT": 'farming_dot',
    "$ASSET_ID_DOGE": 'farming_doge',
    "$ASSET_ID_C98": 'farming_c98',
  };
}

const WAIT_FOR_RECEIPT_TIMEOUT_IN_SECOND = 300;
