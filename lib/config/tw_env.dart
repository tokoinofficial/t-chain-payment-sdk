import 'dart:io';

enum TWEnv {
  dev,
  prod,
}

extension TWEnvExtension on TWEnv {
  String get packageName {
    switch (this) {
      case TWEnv.dev:
        return 'com.tokoin.wallet.dev';
      case TWEnv.prod:
        return 'com.tokoin.wallet';
    }
  }

  String get downloadUrl {
    switch (this) {
      case TWEnv.dev:
        if (Platform.isIOS) {
          return 'https://apps.apple.com/us/app/my-t-wallet/id1489276175';
        }

        if (Platform.isAndroid) {
          return 'market://details?id=com.tokoin.wallet';
        }

        return '';
      case TWEnv.prod:
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
      case TWEnv.dev:
        return 'mtwallet.dev';
      case TWEnv.prod:
        return 'mtwallet';
    }
  }
}
