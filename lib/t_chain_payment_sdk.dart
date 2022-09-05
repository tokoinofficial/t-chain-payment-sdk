library t_chain_payment_sdk;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_env.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_action.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_result.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

export 'package:t_chain_payment_sdk/data/t_chain_payment_env.dart';
export 'package:t_chain_payment_sdk/data/t_chain_payment_action.dart';
export 'package:t_chain_payment_sdk/data/t_chain_payment_result.dart';

class TChainPaymentSDK {
  static final TChainPaymentSDK instance = TChainPaymentSDK._();

  TChainPaymentSDK._();

  late String merchantID;
  late String bundleID;
  late TChainPaymentEnv env;
  late Function(TChainPaymentResult) delegate;

  bool _initialURILinkHandled = false;
  StreamSubscription? _streamSubscription;

  init({
    required String merchantID,
    required String bundleID,
    TChainPaymentEnv env = TChainPaymentEnv.dev,
    required Function(TChainPaymentResult) delegate,
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

  Future<TChainPaymentResult> purchase({
    required String orderID,
    required double amount,
  }) async {
    return await _callPaymentAction(
      action: TChainPaymentAction.deposit,
      orderID: orderID,
      amount: amount,
    );
  }

  Future<TChainPaymentResult> withdraw({
    required String orderID,
    required double amount,
  }) async {
    return TChainPaymentResult(
      status: TChainPaymentStatus.error,
      errorMessage: 'Coming soon',
    );
  }

  Future<TChainPaymentResult> _callPaymentAction({
    required TChainPaymentAction action,
    required String orderID,
    required double amount,
  }) async {
    if (amount <= 0) {
      return TChainPaymentResult(
        status: TChainPaymentStatus.error,
        errorMessage: 'Invalid parameter',
      );
    }

    final Map<String, dynamic> params = {
      'merchant_id': merchantID,
      'order_id': orderID,
      'amount': amount.toString(),
      'bundle_id': bundleID,
      'env': env.name,
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

      return TChainPaymentResult(status: TChainPaymentStatus.failed);
    }

    launchUrl(uri, mode: LaunchMode.externalApplication);

    return TChainPaymentResult(status: TChainPaymentStatus.waiting);
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
        final result = TChainPaymentResult(
          status: TChainPaymentStatus.success,
          orderID: orderID,
          transactionID: transactionID,
        );
        delegate.call(result);
        break;
      case '/fail':
        final result = TChainPaymentResult(
          status: TChainPaymentStatus.failed,
          orderID: orderID,
          transactionID: transactionID,
        );
        delegate.call(result);
        break;
      case '/proceeding':
        final result = TChainPaymentResult(
          status: TChainPaymentStatus.proceeding,
          orderID: orderID,
          transactionID: transactionID,
        );
        delegate.call(result);
        break;
      case '/cancelled':
        final result = TChainPaymentResult(
          status: TChainPaymentStatus.cancelled,
          orderID: orderID,
        );
        delegate.call(result);
        break;
    }
  }
}
