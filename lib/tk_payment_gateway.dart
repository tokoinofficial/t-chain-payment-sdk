library tk_payment_gateway;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tk_payment_gateway/config/tw_env.dart';
import 'package:tk_payment_gateway/config/tw_payment_action.dart';
import 'package:tk_payment_gateway/data/tw_payment_result.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

export 'package:tk_payment_gateway/config/tw_env.dart';
export 'package:tk_payment_gateway/config/tw_payment_action.dart';
export 'package:tk_payment_gateway/data/tw_payment_result.dart';
export 'package:tk_payment_gateway/components/tw_payment_button.dart';

class TWPaymentSDK {
  static final TWPaymentSDK instance = TWPaymentSDK._();

  TWPaymentSDK._();

  late String merchantID;
  late String bundleID;
  late TWEnv env;
  late Function(TWPaymentResult) delegate;

  bool _initialURILinkHandled = false;
  StreamSubscription? _streamSubscription;

  init({
    required String merchantID,
    required String bundleID,
    TWEnv env = TWEnv.dev,
    required Function(TWPaymentResult) delegate,
  }) {
    this.merchantID = merchantID;
    this.bundleID = bundleID;
    this.env = env;
    this.delegate = delegate;

    _initURIHandler();
    _incomingLinkHandler();
  }

  close() {
    _streamSubscription?.cancel();
  }

  Future<TWPaymentResult> purchase({
    required String orderID,
    required double amount,
  }) async {
    return await _callPaymentAction(
      action: TWPaymentAction.deposit,
      orderID: orderID,
      amount: amount,
    );
  }

  Future<TWPaymentResult> withdraw({
    required String orderID,
    required double amount,
  }) async {
    return await _callPaymentAction(
      action: TWPaymentAction.withdraw,
      orderID: orderID,
      amount: amount,
    );
  }

  Future<TWPaymentResult> _callPaymentAction({
    required TWPaymentAction action,
    required String orderID,
    required double amount,
  }) async {
    final Map<String, dynamic> params = {
      'merchant_id': merchantID,
      'order_id': orderID,
      'amount': amount.toString(),
      'bundle_id': bundleID,
    };

    final Uri uri = Uri(
      scheme: env.scheme,
      host: 'app',
      path: action.path,
      queryParameters: params,
    );

    final result = await canLaunchUrl(uri);

    if (result == false) {
      launchUrlString(env.downloadUrl);

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
        _handleDeepLink(initialURI);
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
          _handleDeepLink(uri);
        });
      }, onError: (Object err) {
        debugPrint('Error occurred: $err');
      });
    }
  }

  _handleDeepLink(Uri? deepLink) {
    if (deepLink == null) return;

    final transactionID = deepLink.queryParameters.containsKey('txn')
        ? deepLink.queryParameters['txn']
        : null;
    final orderID = deepLink.queryParameters.containsKey('order_id')
        ? deepLink.queryParameters['order_id']
        : null;

    switch (deepLink.path) {
      case '/success':
        final result = TWPaymentResult(
          status: TWPaymentResultStatus.success,
          orderID: orderID,
          transactionID: transactionID,
        );
        delegate.call(result);
        break;
      case '/fail':
        final result = TWPaymentResult(
          status: TWPaymentResultStatus.failed,
          orderID: orderID,
          transactionID: transactionID,
        );
        delegate.call(result);
        break;
      case '/proceeding':
        final result = TWPaymentResult(
          status: TWPaymentResultStatus.proceeding,
          orderID: orderID,
          transactionID: transactionID,
        );
        delegate.call(result);
        break;
      case '/cancelled':
        final result = TWPaymentResult(
          status: TWPaymentResultStatus.cancelled,
          orderID: orderID,
        );
        delegate.call(result);
        break;
    }
  }
}
