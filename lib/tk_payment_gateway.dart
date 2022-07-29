library tk_payment_gateway;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  late String schemeCallback;
  late Env env;

  init({
    required String appID,
    required String schemeCallback,
    Env env = Env.stag,
  }) {
    this.appID = appID;
    this.schemeCallback = schemeCallback;
    this.env = env;
  }

  Future<TWPaymentResult> buyProduct({
    required String productID,
    required double productPrice,
  }) async {
    final url =
        'mtwallet://otc?product_id=$productID&product_price=$productPrice&env=${env.type}&scheme_callback=$schemeCallback';
    final result = await canLaunch(url);

    if (result == false) {
      return TWPaymentResult(status: TWPaymentResultStatus.failed);
    }

    launch(url);

    return TWPaymentResult(status: TWPaymentResultStatus.unknown);
  }

  static withdraw() {}
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
  unknown
}
