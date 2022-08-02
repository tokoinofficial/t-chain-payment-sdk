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
        return '';
      case TWEnv.prod:
        return 'https://apps.apple.com/us/app/my-t-wallet/id1489276175';
    }
  }

  String get scheme {
    switch (this) {
      case TWEnv.dev:
        return 'mtwallet';
      case TWEnv.prod:
        return 'mtwallet';
    }
  }
}
