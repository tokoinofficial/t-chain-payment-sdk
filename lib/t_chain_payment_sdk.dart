library t_chain_payment_sdk;

import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/currency.dart';
import 'package:t_chain_payment_sdk/data/merchant_info.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_env.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_action.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_qr_result.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_result.dart';
import 'package:t_chain_payment_sdk/repo/payment_repo.dart';
import 'package:t_chain_payment_sdk/screens/merchant_input_screen.dart';
import 'package:t_chain_payment_sdk/services/t_chain_api.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

export 'package:t_chain_payment_sdk/data/t_chain_payment_env.dart';
export 'package:t_chain_payment_sdk/data/t_chain_payment_result.dart';
export 'package:t_chain_payment_sdk/data/t_chain_payment_qr_result.dart';
export 'package:t_chain_payment_sdk/data/currency.dart';
export 'package:t_chain_payment_sdk/data/merchant_info.dart';
export 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';

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

  /// [apiKey] will be generated when you (create a project)[https://developer.tokoin.io/guides/creating-a-project]
  late String apiKey;

  /// Bundle id of merchant app
  /// It's used for My T-Wallet callback function
  late String bundleID;

  /// Environment
  late TChainPaymentEnv env;

  /// what chain id do you want to work with?
  late bool isTestnet;

  /// To handle payment result
  late Function(TChainPaymentResult) delegate;

  bool _initialURILinkHandled = false;
  StreamSubscription? _streamSubscription;

  String get sandboxTitle => isTestnet ? ' - SANDBOX' : '';

  int get chainID => isTestnet ? kTestnetChainID : kMainnetChainID;
  String get chainIdString => '$chainID';

  late PaymentRepository _paymentRepository;

  /// Initialize payment sdk
  init({
    required String apiKey,
    required String bundleID,
    TChainPaymentEnv env = TChainPaymentEnv.dev,
    bool isTestnet = true,
    required Function(TChainPaymentResult) delegate,
  }) {
    this.apiKey = apiKey;
    this.bundleID = bundleID;
    this.env = env;
    this.isTestnet = isTestnet;
    this.delegate = delegate;

    final api = TChainAPI.standard(env.apiUrl);
    _paymentRepository = PaymentRepository(api: api);

    _initURIHandler();
    _incomingLinkHandler();
  }

  /// Close payment sdk
  close() {
    _streamSubscription?.cancel();
  }

  /// Use case: App to App
  /// Alex wants to add funds into his wallet in a game platform, the system
  /// already provides several way to deposit such as redeem code, credit card...
  /// But he wants a modern way - the crypto currency. After integrating with
  /// T-Chain Payment, Alex now can click on a button on mobile or web application
  /// to transfer his money to our smart contract, hence he will get the same
  /// amount in the system after the transaction is completed.
  ///
  /// [notes] unique id of each order. It is called offchain in blockchain terms.
  /// [amount] a sum of money to make a depositary
  Future<TChainPaymentResult> deposit({
    required String notes,
    required double amount,
    required Currency currency,
  }) async {
    return await _callPaymentAction(
      action: TChainPaymentAction.deposit,
      notes: notes,
      amount: amount,
      currency: currency,
    );
  }

  /// Use case: User want to take money out of their game wallet
  ///
  /// [notes] unique id of each order. It is called offchain in blockchain terms
  /// [amount] a sum of money to make a withdrawal
  Future<TChainPaymentResult> withdraw({
    required String notes,
    required double amount,
  }) async {
    return TChainPaymentResult(
      status: TChainPaymentStatus.error,
      notes: notes,
      errorMessage: 'Coming soon',
    );
  }

  /// Use case: POS - QR
  /// Daisy owns a coffee shop, in order to follow the social distancing rules,
  /// along with banking QR code, she now can introduce the similar way but using
  /// crypto currency instead. Customers just need to scan the code, a
  /// notification will be sent to Daisy's phone once the payment succeeds.
  ///
  ///
  /// [notes] unique id of each order. It is called offchain in blockchain terms.
  /// [amount] a sum of money to make a depositary
  Future<TChainPaymentQRResult> generateQrCode({
    required String notes,
    required double amount,
    required Currency currency,
    required double imageSize,
  }) async {
    if (amount <= 0) {
      return TChainPaymentQRResult(
        status: TChainPaymentStatus.error,
        notes: notes,
        errorMessage: 'Invalid parameter',
      );
    }

    final Uri? uri = await _paymentRepository.generateDeeplink(
      action: TChainPaymentAction.deposit,
      notes: notes,
      amount: amount,
      currency: currency,
      chainId: '$chainID',
    );

    if (uri == null) {
      return TChainPaymentQRResult(
        status: TChainPaymentStatus.error,
        notes: notes,
        errorMessage: 'Cannot generate deeplink',
      );
    }

    final painter = QrPainter(
      data: uri.toString(),
      version: QrVersions.auto,
    );

    final qrImage = await painter.toImage(imageSize);
    final qrData = await qrImage.toByteData(format: ImageByteFormat.png);

    return TChainPaymentQRResult(
      status: TChainPaymentStatus.waiting,
      notes: notes,
      qrData: qrData,
    );
  }

  Future<TChainPaymentResult> _callPaymentAction({
    required TChainPaymentAction action,
    required String notes,
    required double amount,
    required Currency currency,
  }) async {
    if (amount <= 0) {
      return TChainPaymentResult(
        status: TChainPaymentStatus.error,
        notes: notes,
        errorMessage: 'Invalid parameter',
      );
    }

    final Uri? uri = await _paymentRepository.generateDeeplink(
      action: action,
      notes: notes,
      amount: amount,
      currency: currency,
      bundleID: bundleID,
      chainId: '$chainID',
    );

    if (uri == null) {
      return TChainPaymentQRResult(
        status: TChainPaymentStatus.error,
        notes: notes,
        errorMessage: 'Cannot generate deeplink',
      );
    }

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
        notes: notes,
      );
    }

    return TChainPaymentResult(
      status: TChainPaymentStatus.waiting,
      notes: notes,
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
    final String notes = deepLink.queryParameters['notes'] ?? '';

    switch (deepLink.path) {
      case '/success':
        final result = TChainPaymentResult(
          status: TChainPaymentStatus.success,
          notes: notes,
          transactionID: transactionID,
        );
        delegate.call(result);
        break;
      case '/fail':
        final result = TChainPaymentResult(
          status: TChainPaymentStatus.failed,
          notes: notes,
          transactionID: transactionID,
        );
        delegate.call(result);
        break;
      case '/proceeding':
        final result = TChainPaymentResult(
          status: TChainPaymentStatus.proceeding,
          notes: notes,
          transactionID: transactionID,
        );
        delegate.call(result);
        break;
      case '/cancelled':
        final result = TChainPaymentResult(
          status: TChainPaymentStatus.cancelled,
          notes: notes,
        );
        delegate.call(result);
        break;
    }
  }
}

extension TChainPaymentSDKWallet on TChainPaymentSDK {
  openMerchantInputScreen(
    BuildContext context, {
    MerchantInfo? merchantInfo,
    String? qrCode,
    String? bundleId,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => RepositoryProvider.value(
          value: _paymentRepository,
          child: MerchantInputScreen(
            merchantInfo: merchantInfo,
            qrCode: qrCode,
            bundleId: bundleId,
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
