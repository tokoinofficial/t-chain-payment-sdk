library tk_payment_gateway;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class Type {
  final String path, icon;

  const Type._internal({required this.path, required this.icon});

  static const buyToko = Type._internal(path: 'otc', icon: 'otc');
  static const sendToko = Type._internal(path: 'sendToko', icon: 'send_toko');
}

class Env {
  final String type, packageName, appStoreId, appStoreLink, prefixUrl;

  const Env._internal(
      {required this.type,
      required this.packageName,
      required this.appStoreLink,
      required this.appStoreId,
      required this.prefixUrl});

  static const prod = Env._internal(
    type: 'prod',
    packageName: 'com.tokoin.wallet',
    appStoreId: '1489276175',
    appStoreLink: 'https://apps.apple.com/us/app/my-t-wallet/id1489276175',
    prefixUrl: 'deeplink-wallet.tokoin.io/wallet',
  );
  static const stag = Env._internal(
    type: 'dev',
    packageName: 'com.tokoin.wallet.dev',
    appStoreId: '0',
    appStoreLink: '',
    prefixUrl: 'tokoin.co/wallet',
  );
}

/// Tokoin Payment Gateway Button
/// [child] customize your button, default button will be used if not provided
/// [type] buy or send token
/// [env] prod or stage
/// [amount] amount to buy or send
class PaymentButton extends StatelessWidget {
  final Widget? child;
  final Type type;
  final Env env;
  final num amount;
  final String address;
  final bool isDarkMode;

  const PaymentButton(
      {this.child,
      required this.type,
      this.env = Env.prod,
      this.amount = 0,
      this.address = '',
      this.isDarkMode = true,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: _onPressed, child: child ?? _defaultButton());
  }

  _defaultButton() =>
      SvgPicture.asset('assets/${type.icon}${isDarkMode ? '_dark' : ''}.svg',
          package: 'tk_payment_gateway');

  _onPressed() async {
    String url = await _createDynamicLink();
    launch(url);
  }

  Future<String> _createDynamicLink() async {
    return 'https://${env.prefixUrl}/?link=https://tokoin.co/${type.path}?amount=$amount&apn=${env.packageName}&amv=3250001&ibi=${env.packageName}&isi=${env.appStoreId}&ius=${env.appStoreLink}';
  }
}

class TWPaymentSDK {
  static final TWPaymentSDK instance = TWPaymentSDK._();

  TWPaymentSDK._();

  late String appID;
  late String bundleID;
  late Env env;
  late Function(TWPaymentResult) delegate;

  bool _initialURILinkHandled = false;
  StreamSubscription? _streamSubscription;

  init({
    required String appID,
    required String bundleID,
    Env env = Env.stag,
    required Function(TWPaymentResult) delegate,
  }) {
    this.appID = appID;
    this.bundleID = bundleID;
    this.env = env;
    this.delegate = delegate;

    _initURIHandler();
    _incomingLinkHandler();
  }

  close() {
    _streamSubscription?.cancel();
  }

  Future<TWPaymentResult> buyProduct({
    required String productID,
    required double productPrice,
  }) async {
    final Map<String, dynamic> params = {
      'product_id': productID,
      'product_price': productPrice.toString(),
      'env': env.type,
      'bundle_id': bundleID,
    };

    final Uri uri = Uri(
      scheme: 'mtwallet',
      host: 'app',
      path: 'otc',
      queryParameters: params,
    );

    final result = await canLaunchUrl(uri);

    if (result == false) {
      return TWPaymentResult(status: TWPaymentResultStatus.failed);
    }

    launchUrl(uri, mode: LaunchMode.externalApplication);

    return TWPaymentResult(status: TWPaymentResultStatus.waiting);
  }

  Future<TWPaymentResult> withdraw({
    required double amount,
  }) async {
    final Map<String, dynamic> params = {
      'amount': amount.toString(),
      'env': env.type,
      'bundle_id': bundleID,
    };

    final Uri uri = Uri(
      scheme: 'mtwallet',
      host: 'app',
      path: 'sendToko',
      queryParameters: params,
    );

    final result = await canLaunchUrl(uri);

    if (result == false) {
      return TWPaymentResult(status: TWPaymentResultStatus.failed);
    }

    launchUrl(uri, mode: LaunchMode.externalApplication);

    return TWPaymentResult(status: TWPaymentResultStatus.waiting);
  }

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      debugPrint('init URI Handler');

      try {
        final initialURI = await getInitialUri();
        // Use the initialURI and warn the user if it is not correct,
        // but keep in mind it could be `null`.
        _checkDeepLink(initialURI);
      } on PlatformException {
        // Platform messages may fail, so we use a try/catch PlatformException.
        // Handle exception by warning the user their action did not succeed
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        debugPrint('Malformed Initial URI received: $err');
      }
    }
  }

  /// Handle incoming links - the ones that the app will receive from the OS
  /// while already started.
  void _incomingLinkHandler() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        debugPrint('Received URI: $uri');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkDeepLink(uri);
        });
      }, onError: (Object err) {
        debugPrint('Error occurred: $err');
      });
    }
  }

  _checkDeepLink(Uri? deepLink) {
    if (deepLink == null) return;

    switch (deepLink.path) {
      case '/success':
        final result = TWPaymentResult(status: TWPaymentResultStatus.success);
        delegate.call(result);
        break;
      case '/cancelled':
        final result = TWPaymentResult(status: TWPaymentResultStatus.cancelled);
        delegate.call(result);
        break;
    }
  }
}

class TWPaymentResult {
  TWPaymentResult({
    required this.status,
    this.transactionID,
    this.productID,
    this.appBundleID,
    this.purchaseDate,
  });

  final TWPaymentResultStatus status;
  final String? transactionID;
  final String? productID;
  final String? appBundleID;
  final DateTime? purchaseDate;
}

enum TWPaymentResultStatus {
  success,
  cancelled,
  failed,
  operationInProgress,
  waiting,
}
