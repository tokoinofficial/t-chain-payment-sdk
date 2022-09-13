import 'package:example/data/pay_result_route_data.dart';
import 'package:example/router/unknown_route.dart';
import 'package:example/screen/deposit_screen.dart';
import 'package:example/screen/home_screen.dart';
import 'package:example/screen/payment_result_screen.dart';
import 'package:example/screen/pos_qr_screen.dart';
import 'package:flutter/material.dart';

class ScreenRouter {
  static const root = '/';
  static const appToApp = '/app_to_app';
  static const posQr = '/pos_qr';
  static const payResult = '/pay_result';

  Route<dynamic> generateRoute(RouteSettings settings) {
    late Widget screen;

    switch (settings.name) {
      case root:
        screen = const HomeScreen();
        break;

      case appToApp:
        screen = const DepositScreen();
        break;

      case posQr:
        screen = const PosQrScreen();
        break;

      case payResult:
        final data = settings.arguments as PayResultRouteData?;
        if (data == null) {
          throw Exception('Invalid Data');
        }
        screen = PaymentResultScreen(
          orderID: data.orderID,
          amount: data.amount,
          useQRCode: data.useQRCode,
        );
        break;

      default:
        return unknownRoute(settings);
    }

    return MaterialPageRoute(builder: (context) => screen, settings: settings);
  }
}
