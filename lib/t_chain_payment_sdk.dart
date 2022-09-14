library t_chain_payment_sdk;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_env.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_action.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_result.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

export 'package:t_chain_payment_sdk/data/t_chain_payment_env.dart';
export 'package:t_chain_payment_sdk/data/t_chain_payment_result.dart';

/// TChainPaymnentSDK
/// Helping you communicate with My T-Wallet easily.
/// Features:
/// - deposit
/// - generate QR Code
/// - withdraw
///
class TChainPaymentSDK {
  static final TChainPaymentSDK _instance = TChainPaymentSDK._();
  static TChainPaymentSDK get instance => _instance;

  TChainPaymentSDK._();

  /// [merchantID] will be generated when you (create a project)[https://developer.tokoin.io/guides/creating-a-project]
  late String merchantID;

  /// Bundle id of merchant app
  /// It's used for My T-Wallet callback function
  late String bundleID;

  /// Environment
  late TChainPaymentEnv env;

  /// To handle payment result
  late Function(TChainPaymentResult) delegate;

  bool _initialURILinkHandled = false;
  StreamSubscription? _streamSubscription;

  /// Initialize payment sdk
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

  /// Close payment sdk
  close() {
    _streamSubscription?.cancel();
  }

  /// Use cases:
  /// 1. App to App
  /// Alex wants to add funds into his wallet in a game platform, the system
  /// already provides several way to deposit such as redeem code, credit card...
  /// But he wants a modern way - the crypto currency. After integrating with
  /// T-Chain Payment, Alex now can click on a button on mobile or web application
  /// to transfer his money to our smart contract, hence he will get the same
  /// amount in the system after the transaction is completed.
  ///
  /// 2. POS - QR
  /// Daisy owns a coffee shop, in order to follow the social distancing rules,
  /// along with banking QR code, she now can introduce the similar way but using
  /// crypto currency instead. Customers just need to scan the code, a
  /// notification will be sent to Daisy's phone once the payment succeeds.
  ///
  ///
  /// [orderID] unique id of each order. It is called offchain in blockchain terms.
  /// [amount] a sum of money to make a depositary
  Future<TChainPaymentResult> deposit({
    required String orderID,
    required double amount,
  }) async {
    return await _callPaymentAction(
      action: TChainPaymentAction.deposit,
      orderID: orderID,
      amount: amount,
    );
  }

  /// Use cases:
  /// User want to take money out of their game wallet
  ///
  /// [orderID] unique id of each order. It is called offchain in blockchain terms
  /// [amount] a sum of money to make a withdrawal
  Future<TChainPaymentResult> withdraw({
    required String orderID,
    required double amount,
  }) async {
    return TChainPaymentResult(
      status: TChainPaymentStatus.error,
      orderID: orderID,
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
        orderID: orderID,
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

    bool result = false;
    try {
      result = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (result == false) {
      launchUrlString(env.downloadUrl);

      return TChainPaymentResult(
        status: TChainPaymentStatus.failed,
        orderID: orderID,
      );
    }

    return TChainPaymentResult(
      status: TChainPaymentStatus.waiting,
      orderID: orderID,
    );
  }

  /// Handle deeplink when user open the app
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

    final transactionID = deepLink.queryParameters['txn'];
    final String orderID = deepLink.queryParameters['order_id'] ?? '';

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
