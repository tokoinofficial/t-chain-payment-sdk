import 'dart:io';

enum TChainPaymentEnv {
  dev,
  prod,
}

extension TChainPaymentEnvExt on TChainPaymentEnv {
  String get packageName {
    switch (this) {
      case TChainPaymentEnv.dev:
        return 'com.tokoin.wallet.dev';
      case TChainPaymentEnv.prod:
        return 'com.tokoin.wallet';
    }
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
          return 'market://details?id=com.tokoin.wallet';
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
