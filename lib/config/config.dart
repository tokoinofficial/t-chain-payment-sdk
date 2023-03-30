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
}

const int kMainnetChainID = 56;
const int kTestnetChainID = 97;
