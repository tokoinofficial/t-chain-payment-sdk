import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:uni_links/uni_links.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

bool _initialUriLinkHandled = false;

class DeepLinkService {
  static final DeepLinkService shared = DeepLinkService._();
  DeepLinkService._();

  static const kMerchant = 'merchant';

  StreamSubscription? _streamSubscription;
  Function(Uri)? onReceived;

  listen() {
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
            onReceived?.call(initialUri);
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
            onReceived?.call(uri);
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
}
