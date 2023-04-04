import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_chain_payment_sdk/config/utils.dart';
import 'package:t_chain_payment_sdk/data/merchant_info.dart';
import 'package:t_chain_payment_sdk/l10n/generated/tchain_payment_localizations.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

bool _initialUriLinkHandled = false;

class DeepLinkService {
  static final DeepLinkService instance = DeepLinkService._();
  DeepLinkService._();

  static const kMerchant = 'merchant';

  StreamSubscription? _streamSubscription;
  Function(BuildContext, Uri)? onReceived;

  late BuildContext context;

  init(BuildContext context) {
    this.context = context;
    _initUriHandler();
    _incomingLinkHandler();
  }

  close() {
    _streamSubscription?.cancel();
  }

  // handle deep link when the app hasn't started
  Future<void> _initUriHandler() async {
    if (!_initialUriLinkHandled) {
      _initialUriLinkHandled = true;

      try {
        final initialUri = await getInitialUri();
        if (initialUri != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (isPaymentUrl(initialUri)) {
              onReceived?.call(context, initialUri);
              return;
            }

            if (isWalletConnectUrl(initialUri)) {
              onReceived?.call(context, initialUri);
              return;
            }

            Utils.errorToast(
              TChainPaymentLocalizations.of(context)!.invalid_code,
            );
          });
        }
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
    if (!kIsWeb && _streamSubscription == null) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        debugPrint('Received URI: $uri');
        if (uri != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (isPaymentUrl(uri)) {
              onReceived?.call(context, uri);
              return;
            }

            if (isWalletConnectUrl(uri)) {
              onReceived?.call(context, uri);
              return;
            }

            Utils.errorToast(
              TChainPaymentLocalizations.of(context)!.invalid_code,
            );
          });
        }
      }, onError: (Object err) {
        debugPrint('Error occurred: $err');
      });
    }
  }

  // User has already paid/has already withdrawn, calling this function to send back to merchant app
  // Required transaction ID because the transaction's status doesn't update immediately
  // Merchant app would check it manually once it has tnx
  void success({
    String? bundleID,
    String? notes,
    required String txn,
  }) {
    if (bundleID == null || bundleID.isEmpty) return;

    final uri = Uri(
      scheme: '$kMerchant.$bundleID',
      host: 'app',
      path: 'success',
      queryParameters: {
        if (notes != null) 'notes': notes,
        'txn': txn,
      },
    );

    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void fail({
    String? bundleID,
    String? notes,
    required String txn,
  }) {
    if (bundleID == null || bundleID.isEmpty) return;

    final uri = Uri(
      scheme: '$kMerchant.$bundleID',
      host: 'app',
      path: 'fail',
      queryParameters: {
        if (notes != null) 'notes': notes,
        'txn': txn,
      },
    );

    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void proceeding({
    String? bundleID,
    String? notes,
    required String txn,
  }) {
    if (bundleID == null || bundleID.isEmpty) return;

    final uri = Uri(
      scheme: '$kMerchant.$bundleID',
      host: 'app',
      path: 'proceeding',
      queryParameters: {
        if (notes != null) 'notes': notes,
        'txn': txn,
      },
    );

    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // User cancels action, calling this function to send back to merchant app
  void cancel({
    String? bundleID,
    String? notes,
  }) {
    if (bundleID == null || bundleID.isEmpty) return;

    final uri = Uri(
      scheme: '$kMerchant.$bundleID',
      host: 'app',
      path: 'cancelled',
      queryParameters: {
        if (notes != null) 'notes': notes,
      },
    );

    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  bool isPaymentUrl(Uri uri) {
    return (uri.scheme == 'mtwallet' || uri.scheme == 'mtwallet.dev') &&
        uri.host == 'app' &&
        uri.queryParameters['qr_code'] != null;
  }

  bool isWalletConnectUrl(Uri uri) {
    return (uri.scheme == 'mtwallet' || uri.scheme == 'mtwallet.dev') &&
        uri.host == 'wc' &&
        uri.queryParameters['uri'] != null;
  }

  handleUrl(BuildContext context, Uri deepLink) {
    // T-Chain payment
    if (deepLink.host == 'app') {
      final qrCode = deepLink.queryParameters['qr_code'] ?? '';
      final bundleID = deepLink.queryParameters['bundle_id'] ?? '';

      switch (deepLink.path) {
        case '/payment_deposit':
          // Navigator.of(context).pushNamed(
          //   ScreenRouter.MERCHANT_INPUT,
          //   arguments: {
          //     ScreenRouter.ARG_QR_CODE: qrCode,
          //     ScreenRouter.ARG_BUNDLE_ID: bundleID,
          //   },
          // );

          break;
      }
    }
  }

  handleQRPayment(BuildContext context, MerchantInfo merchantInfo) {
    // Navigator.of(context).pushNamed(
    //   ScreenRouter.MERCHANT_INPUT,
    //   arguments: {
    //     ScreenRouter.ARG_MERCHANT_INFO: merchantInfo,
    //   },
    // );
  }
}
