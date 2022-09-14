import 'dart:io';

import 'package:t_chain_payment_sdk/data/t_chain_payment_env.dart';

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
}
