import 'dart:io';

enum TChainPaymentEnv {
  dev,
  prod,
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
          return 'market://details?id=com.tokoin.wallet';
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
    return 'mtwallet';
  }
}
