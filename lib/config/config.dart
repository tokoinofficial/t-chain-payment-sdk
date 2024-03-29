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

  static bool isProd() => _config == _ConfigMap.prodConfig;

  static String get baseURL {
    return _config[_ConfigMap.BASE_URL];
  }

  static get paymentContractAddress {
    return _config[_ConfigMap.PAYMENT_CONTRACT_ADDRESS];
  }

  static get paymentTokenRegistry {
    return _config[_ConfigMap.PAYMENT_TOKEN_REGISTRY];
  }

  static get binanceRpcNodes {
    return _config[_ConfigMap.BINANCE_RPC_NODES];
  }

  static get bscTxUrl {
    return _config[_ConfigMap.BINANCE_TX_URL];
  }

  static get minGasPrice {
    return _config[_ConfigMap.MIN_GAS_PRICE];
  }

  static get maxGas {
    return _config[_ConfigMap.MAX_GAS];
  }

  static get bnbTokenAddress {
    return _config[_ConfigMap.BNB_TOKEN_ADDRESS];
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

  static get pancakeRouter {
    return _config[_ConfigMap.PANCAKE_ROUTER];
  }

  static int get bscChainId {
    return _config[_ConfigMap.BSC_CHAIN_ID];
  }
}

class _ConfigMap {
  static const BASE_URL = 'BASE_URL';
  static const PAYMENT_CONTRACT_ADDRESS = 'PAYMENT_CONTRACT_ADDRESS';
  static const PAYMENT_TOKEN_REGISTRY = 'PAYMENT_TOKEN_REGISTRY';
  static const BINANCE_RPC_NODES = 'BINANCE_RPC_NODES';
  static const BINANCE_TX_URL = 'BINANCE_TX_URL';
  static const MIN_GAS_PRICE = 'MIN_GAS_PRICE';
  static const MAX_GAS = 'MAX_GAS';
  static const BNB_TOKEN_ADDRESS = 'BNB_TOKEN_ADDRESS';
  static const BSC_TOKOIN_CONTRACT_ADDRESS = 'BSC_TOKOIN_CONTRACT_ADDRESS';
  static const BSC_USDT_CONTRACT_ADDRESS = 'BSC_USDT_CONTRACT_ADDRESS';
  static const BSC_BUSD_CONTRACT_ADDRESS = 'BSC_BUSD_CONTRACT_ADDRESS';
  static const PANCAKE_ROUTER = 'PANCAKE_ROUTER';
  static const BSC_CHAIN_ID = 'BSC_CHAIN_ID';

  static Map<String, dynamic> devConfig = {
    BASE_URL: "https://staging-api.tokoin.io/api",
    PAYMENT_CONTRACT_ADDRESS: '0x804C7762FbEaB64Ac554aEc644E43Ab934d23Ff0',
    PAYMENT_TOKEN_REGISTRY: '0x5B19B6aAB8f96a219262bDB4DDdbA54BAE890625',
    BINANCE_RPC_NODES: [
      "https://data-seed-prebsc-1-s1.binance.org:8545/",
      "https://rpc.ankr.com/bsc_testnet_chapel"
    ],
    BINANCE_TX_URL: "https://testnet.bscscan.com/tx/",
    MIN_GAS_PRICE: 10,
    MAX_GAS: 350000,
    BNB_TOKEN_ADDRESS: "0x78A27e2Abf6E181825aA09325e1C132Df061D797",
    BSC_TOKOIN_CONTRACT_ADDRESS: "0x09b9d0e083a8dc25b979e402c304dbcab574c7af",
    BSC_USDT_CONTRACT_ADDRESS: "0x15d0c6710a6989945134100ffae44e5e2dee1789",
    BSC_BUSD_CONTRACT_ADDRESS: "0x6758ceEDFBb134f01D9449d30e9730fB83EBa995",
    PANCAKE_ROUTER: "0xd99d1c33f9fc3444f8101754abc46c52416550d1",
    BSC_CHAIN_ID: 97,
  };

  static Map<String, dynamic> prodConfig = {
    BASE_URL: "https://api.tokoin.io/api",
    PAYMENT_CONTRACT_ADDRESS: '0xCF53BE45090E2F69293de75c37c0FD29c03607bD',
    PAYMENT_TOKEN_REGISTRY: '0xe45b13927BE19bb34bD31fabA2661F8B458fF4F7',
    BINANCE_RPC_NODES: [
      "https://bsc-dataseed1.defibit.io/",
      "https://bsc-dataseed1.ninicoin.io/",
      "https://bsc-dataseed.binance.org/",
      "https://rpc.ankr.com/bsc"
    ],
    BINANCE_TX_URL: "https://bscscan.com/tx/",
    MIN_GAS_PRICE: 5,
    MAX_GAS: 350000,
    BNB_TOKEN_ADDRESS: "0xB8c77482e45F1F44dE1745F52C74426C631bDD52",
    BSC_TOKOIN_CONTRACT_ADDRESS: "0x45f7967926e95fd161e56ed66b663c9114c5226f",
    BSC_USDT_CONTRACT_ADDRESS: "0x55d398326f99059ff775485246999027b3197955",
    BSC_BUSD_CONTRACT_ADDRESS: "0xe9e7cea3dedca5984780bafc599bd69add087d56",
    PANCAKE_ROUTER: "0x10ed43c718714eb63d5aa57b78b54704e256024e",
    BSC_CHAIN_ID: 56,
  };
}
