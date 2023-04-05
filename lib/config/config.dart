import 'dart:io';

import 'package:t_chain_payment_sdk/data/t_chain_payment_action.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_env.dart';

extension TChainPaymentActionExtension on TChainPaymentAction {
  /// Configure the path of the deep link
  String get path {
    switch (this) {
      case TChainPaymentAction.deposit:
        return 'payment_deposit';
      case TChainPaymentAction.withdraw:
        return 'payment_withdraw';
    }
  }
}

extension TChainPaymentEnvExt on TChainPaymentEnv {
  String get packageName {
    return 'com.tokoin.wallet';
  }

  String get downloadUrl {
    switch (this) {
      case TChainPaymentEnv.dev:
        if (Platform.isIOS) {
          return 'https://apps.apple.com/us/app/my-t-wallet/id1489276175';
        }

        if (Platform.isAndroid) {
          return 'market://details?id=$packageName';
        }

        return '';
      case TChainPaymentEnv.prod:
        if (Platform.isIOS) {
          return 'https://apps.apple.com/us/app/my-t-wallet/id1489276175';
        }

        if (Platform.isAndroid) {
          return 'market://details?id=$packageName';
        }

        return '';
    }
  }

  String get scheme {
    switch (this) {
      case TChainPaymentEnv.dev:
        return 'mtwallet.dev';
      case TChainPaymentEnv.prod:
        return 'mtwallet';
    }
  }

  String get apiUrl {
    switch (this) {
      case TChainPaymentEnv.dev:
        return "https://staging-api.tokoin.io/api";

      case TChainPaymentEnv.prod:
        return "https://api.tokoin.io/api";
    }
  }

  Uri get generateQrCodeAPI {
    return Uri.https('$apiUrl/t-chain-sdk/generate-qrcode');
  }

  String get tokoContractAddress {
    switch (this) {
      case TChainPaymentEnv.dev:
        return "https://staging-api.tokoin.io/api";

      case TChainPaymentEnv.prod:
        return "https://api.tokoin.io/api";
    }
  }

  String get usdtContractAddress {
    switch (this) {
      case TChainPaymentEnv.dev:
        return "https://staging-api.tokoin.io/api";

      case TChainPaymentEnv.prod:
        return "https://api.tokoin.io/api";
    }
  }

  String get busdContractAddress {
    switch (this) {
      case TChainPaymentEnv.dev:
        return "https://staging-api.tokoin.io/api";

      case TChainPaymentEnv.prod:
        return "https://api.tokoin.io/api";
    }
  }

  String get bnbContractAddress {
    switch (this) {
      case TChainPaymentEnv.dev:
        return "https://staging-api.tokoin.io/api";

      case TChainPaymentEnv.prod:
        return "https://api.tokoin.io/api";
    }
  }
}

const int kMainnetChainID = 56;
const int kTestnetChainID = 97;

class Config {
  static late Map<String, dynamic> _config;

  static void setEnvironment(TChainPaymentEnv env) {
    switch (env) {
      case TChainPaymentEnv.dev:
        _config = _ConfigMap.devConfig;
        break;
      case TChainPaymentEnv.prod:
        _config = _ConfigMap.prodConfig;
        break;
    }
  }

  static get sandboxTitle => isProd() ? '' : ' - SANDBOX';

  static get iconName => 'my_t_wallet${isProd() ? '' : '_sandbox'}';

  static bool isProd() => _config == _ConfigMap.prodConfig;

  static get baseURL {
    return _config[_ConfigMap.BASE_URL];
  }

  static get infuraURL {
    return _config[_ConfigMap.INFURA_URL];
  }

  static get maxGas {
    return _config[_ConfigMap.MAX_GAS];
  }

  static get ethSzoContractAddress {
    return _config[_ConfigMap.ETH_SZO_CONTRACT_ADDRESS];
  }

  static get bscSzoContractAddress {
    return _config[_ConfigMap.BSC_SZO_CONTRACT_ADDRESS];
  }

  static get bscTokoinContractAddress {
    return _config[_ConfigMap.BSC_TOKOIN_CONTRACT_ADDRESS];
  }

  static get bscUsdtContractAddress {
    return _config[_ConfigMap.BSC_USDT_CONTRACT_ADDRESS];
  }

  static get bscBinanceUsdContractAddress {
    return _config[_ConfigMap.BSC_BUSD_CONTRACT_ADDRESS];
  }

  static get bscCakeContractAddress {
    return _config[_ConfigMap.BSC_CAKE_CONTRACT_ADDRESS];
  }

  static get bscTkoContractAddress {
    return _config[_ConfigMap.BSC_TKO_CONTRACT_ADDRESS];
  }

  static get bscDepContractAddress {
    return _config[_ConfigMap.BSC_DEP_CONTRACT_ADDRESS];
  }

  static get bscDogeContractAddress {
    return _config[_ConfigMap.BSC_DOGE_CONTRACT_ADDRESS];
  }

  static get bscDotContractAddress {
    return _config[_ConfigMap.BSC_DOT_CONTRACT_ADDRESS];
  }

  static get bscC98ContractAddress {
    return _config[_ConfigMap.BSC_C98_CONTRACT_ADDRESS];
  }

  static get btcTxUrl {
    return _config[_ConfigMap.BTC_TX_URL];
  }

  static get wssInfura {
    return _config[_ConfigMap.WSS_INFURA_URL];
  }

  static get binanceDataSeed {
    return _config[_ConfigMap.BINANCE_DATA_SEED_KEY];
  }

  static get bscTxUrl {
    return _config[_ConfigMap.BINANCE_TX_URL];
  }

  static get bscTokenUrl {
    return _config[_ConfigMap.BINANCE_TOKEN_URL];
  }

  static get bnbContractAddress {
    return _config[_ConfigMap.BNB_CONTRACT_ADDRESS];
  }

  static get wbnbContractAddress {
    return _config[_ConfigMap.WBNB_CONTRACT_ADDRESS];
  }

  static get pancakeRouter {
    return _config[_ConfigMap.PANCAKE_ROUTER];
  }

  static get bscChainID {
    return _config[_ConfigMap.BSC_CHAIN_ID];
  }

  static get paymentContractAddress {
    return _config[_ConfigMap.PAYMENT_CONTRACT_ADDRESS];
  }

  static get paymentTokenRegistry {
    return _config[_ConfigMap.PAYMENT_TOKEN_REGISTRY];
  }
}

class _ConfigMap {
  static const BASE_URL = "BASE_URL";
  static const INFURA_URL = "INFURA_URL";
  static const MAX_GAS = "MAX_GAS";
  static const BTC_TX_URL = "BTC_TX_URL";
  static const WSS_INFURA_URL = "WSS_INFURA_URL";
  static const BSC_CHAIN_ID = "BSC_CHAIN_ID";
  static const BINANCE_DATA_SEED_KEY = 'BINANCE_DATA_SEED_KEY';
  static const BINANCE_TX_URL = 'BINANCE_TX_URL';
  static const BINANCE_TOKEN_URL = 'BINANCE_TOKEN_URL';
  static const BNB_CONTRACT_ADDRESS = "BNB_CONTRACT_ADDRESS";
  static const BSC_TOKOIN_CONTRACT_ADDRESS = 'BSC_TOKOIN_CONTRACT_ADDRESS';
  static const BSC_USDT_CONTRACT_ADDRESS = 'BSC_USDT_CONTRACT_ADDRESS';
  static const BSC_CAKE_CONTRACT_ADDRESS = 'BSC_CAKE_CONTRACT_ADDRESS';
  static const BSC_BUSD_CONTRACT_ADDRESS = 'BSC_BUSD_CONTRACT_ADDRESS';
  static const BSC_TKO_CONTRACT_ADDRESS = 'BSC_TKO_CONTRACT_ADDRESS';
  static const BSC_DEP_CONTRACT_ADDRESS = 'BSC_DEP_CONTRACT_ADDRESS';
  static const BSC_DOGE_CONTRACT_ADDRESS = 'BSC_DOGE_CONTRACT_ADDRESS';
  static const BSC_DOT_CONTRACT_ADDRESS = 'BSC_DOT_CONTRACT_ADDRESS';
  static const BSC_C98_CONTRACT_ADDRESS = 'BSC_C98_CONTRACT_ADDRESS';
  static const ETH_SZO_CONTRACT_ADDRESS = 'ETH_SZO_CONTRACT_ADDRESS';
  static const BSC_SZO_CONTRACT_ADDRESS = 'BSC_SZO_CONTRACT_ADDRESS';
  static const WBNB_CONTRACT_ADDRESS = 'WBNB_CONTRACT_ADDRESS';
  static const PANCAKE_ROUTER = 'PANCAKE_ROUTER';
  static const PAYMENT_CONTRACT_ADDRESS = 'PAYMENT_CONTRACT_ADDRESS';
  static const PAYMENT_TOKEN_REGISTRY = 'PAYMENT_TOKEN_REGISTRY';

  static Map<String, dynamic> devConfig = {
    PAYMENT_CONTRACT_ADDRESS: '0x0631aa71dC522EfF8d13b00cc5dA8221567A01cA',
    PAYMENT_TOKEN_REGISTRY: '0x05938838CE60e94A5d32AbDbE65FcdC31178b8c6',
    BASE_URL: "https://staging-api.tokoin.io/api",
    INFURA_URL: [
      "https://goerli.infura.io/v3/ccf3f12262e34a4aa989b8035b4d693e"
    ],
    WSS_INFURA_URL:
        "wss://goerli.infura.io/ws/v3/ccf3f12262e34a4aa989b8035b4d693e",
    BINANCE_DATA_SEED_KEY: [
      "https://data-seed-prebsc-1-s1.binance.org:8545/",
      "https://apis.ankr.com/f45dd2313e094d33bc84c6954c18b81a/5220d6fa11cfaaeb98526c6ed64c052d/binance/full/test",
      "https://rpc.ankr.com/bsc_testnet_chapel"
    ],
    BINANCE_TX_URL: "https://testnet.bscscan.com/tx/",
    BINANCE_TOKEN_URL: "https://testnet.bscscan.com/token/",
    MAX_GAS: 300000,
    BSC_TOKOIN_CONTRACT_ADDRESS: "0x09b9d0e083a8dc25b979e402c304dbcab574c7af",
    BSC_USDT_CONTRACT_ADDRESS: "0x15d0c6710a6989945134100ffae44e5e2dee1789",
    BSC_CAKE_CONTRACT_ADDRESS: "0xc39d0de35b897ab8cec43a1f66386908c3e7ac5c",
    BSC_BUSD_CONTRACT_ADDRESS: "0x6758ceEDFBb134f01D9449d30e9730fB83EBa995",
    BSC_TKO_CONTRACT_ADDRESS: "0x5254c1a1a5671bdea8a058948f618e4e03f3c947",
    BSC_DEP_CONTRACT_ADDRESS: "0xe103730a02C0dee84dCb8265dF3eBBe1e5fcA772",
    BSC_DOGE_CONTRACT_ADDRESS: "0x4f60217893388B8Ef8Dd01BE314Afa8ee987AE41",
    BSC_DOT_CONTRACT_ADDRESS: "0x57eb566f9bC798253931facCAbB8CE99adAf31ee",
    BSC_C98_CONTRACT_ADDRESS: "0xCF897975F64d45c499873bdf14aD6F664C2DdD28",
    BSC_SZO_CONTRACT_ADDRESS: "0x6B688CD42885114E83f0829cFDd336bFC01a85B8",
    ETH_SZO_CONTRACT_ADDRESS: "0xAD095cDBfD77A63994Fdcf0923b8e99405207A3b",
    WBNB_CONTRACT_ADDRESS: "0xae13d989dac2f0debff460ac112a837c89baa7cd",
    PANCAKE_ROUTER: "0xd99d1c33f9fc3444f8101754abc46c52416550d1",
    BNB_CONTRACT_ADDRESS: "0x78A27e2Abf6E181825aA09325e1C132Df061D797",
    BSC_CHAIN_ID: 97,
  };

  static Map<String, dynamic> prodConfig = {
    PAYMENT_CONTRACT_ADDRESS: '0x8cfeB1a66E28bAb0Cd81CeE6621cdBD0963D13bB',
    PAYMENT_TOKEN_REGISTRY: '0x5b318cA1491805DA49FA7C4DB6c1260F17aE8F45',
    BASE_URL: "https://api.tokoin.io/api",
    INFURA_URL: [
      "https://mainnet.infura.io/v3/5e6e040c544a411aa401449407914f38"
    ],
    WSS_INFURA_URL:
        "wss://mainnet.infura.io/ws/v3/5e6e040c544a411aa401449407914f38",
    BINANCE_DATA_SEED_KEY: [
      "https://bsc-dataseed1.defibit.io/",
      "https://bsc-dataseed1.ninicoin.io/",
      "https://bsc-dataseed.binance.org/",
      "https://rpc.ankr.com/bsc"
    ],
    BINANCE_TX_URL: "https://bscscan.com/tx/",
    BINANCE_TOKEN_URL: "https://bscscan.com/token/",
    MAX_GAS: 300000,
    BSC_TOKOIN_CONTRACT_ADDRESS: "0x45f7967926e95fd161e56ed66b663c9114c5226f",
    BSC_USDT_CONTRACT_ADDRESS: "0x55d398326f99059ff775485246999027b3197955",
    BSC_CAKE_CONTRACT_ADDRESS: "0x0e09fabb73bd3ade0a17ecc321fd13a19e81ce82",
    BSC_BUSD_CONTRACT_ADDRESS: "0xe9e7cea3dedca5984780bafc599bd69add087d56",
    BSC_TKO_CONTRACT_ADDRESS: "0x9f589e3eabe42ebc94a44727b3f3531c0c877809",
    BSC_DEP_CONTRACT_ADDRESS: "0xcaf5191fc480f43e4df80106c7695eca56e48b18",
    BSC_DOGE_CONTRACT_ADDRESS: "0xba2ae424d960c26247dd6c32edc70b295c744c43",
    BSC_DOT_CONTRACT_ADDRESS: "0x7083609fce4d1d8dc0c979aab8c869ea2c873402",
    BSC_C98_CONTRACT_ADDRESS: "0xaec945e04baf28b135fa7c640f624f8d90f1c3a6",
    BSC_SZO_CONTRACT_ADDRESS: "0xaB837ac8800083653E5d15cEaA7E23d20adFC991",
    WBNB_CONTRACT_ADDRESS: "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c",
    PANCAKE_ROUTER: "0x10ed43c718714eb63d5aa57b78b54704e256024e",
    BNB_CONTRACT_ADDRESS: "0xB8c77482e45F1F44dE1745F52C74426C631bDD52",
    BSC_CHAIN_ID: 56,
  };
}
