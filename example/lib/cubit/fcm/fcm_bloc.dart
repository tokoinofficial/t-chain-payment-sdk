import 'package:example/data/fcm_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'fcm_states.dart';

class FcmCubit extends Cubit<FcmState> {
  FcmCubit() : super(FcmUninitialized());

  Future<void> initialFcm() async {
    _setupFcm();
    addFcm();
  }

  Future<void> addFcm() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');
    FirebaseMessaging.instance
        .getToken()
        .then((token) => _saveToken(token!)); // save token after login
  }

  Future<void> removeFcm() async {
    FirebaseMessaging.instance
        .deleteToken(); // make fcm token invalid, so logged out device won't receive notification
  }

  _setupFcm() {
    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint("onMessage: ${message.data}");
      _handleMessage(message.data);
    });

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message.data);
    });

    // Get any messages which caused the application to open from
    // a terminated state.
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? initialMessage) {
      if (initialMessage != null) {
        _handleMessage(initialMessage.data);
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen(
        (token) => _saveToken(token)); // save token when it was refreshed
  }

  _handleMessage(Map<String, dynamic> message) {
    debugPrint('_handleMessage: $message');
    if (!message.containsKey(FcmNotification.keyTransactionHash)) return;

    FcmNotification fcmNotification = FcmNotification.fromMap(message);
    emit(FcmMessageReceived(fcmNotification: fcmNotification));
    emit(
        FcmFinished()); // calling finish to make state change, otherwise recall emit `FcmReloadBalance` will not trigger event
  }

  _saveToken(String token) async {
    debugPrint('add fcm token $token');
  }
}
