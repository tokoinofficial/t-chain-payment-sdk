import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriLinkHandled = false;

class DeepLinkService {
  static final DeepLinkService shared = DeepLinkService._();
  DeepLinkService._();

  StreamSubscription? _streamSubscription;
  Function(Uri)? onReceived;

  listen([Function(Uri)? onReceived]) {
    this.onReceived = onReceived;
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
}
