library tk_payment_gateway;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Type {
  final String path, name;

  const Type._internal({required this.path, required this.name});

  static const buyToko = Type._internal(path: 'otc', name: 'Buy TOKO');
  static const sendToko = Type._internal(path: 'sendToko', name: 'Send TOKO');
}

class Env {
  final String packageName, appStoreId, appStoreLink, prefixUrl;

  const Env._internal(
      {required this.packageName,
      required this.appStoreLink,
      required this.appStoreId,
      required this.prefixUrl});

  static const prod = Env._internal(
      packageName: 'com.tokoin.wallet',
      appStoreId: '1489276175',
      appStoreLink: 'https://apps.apple.com/us/app/my-t-wallet/id1489276175',
      prefixUrl: 'deeplink-wallet.tokoin.io/wallet');
  static const stag = Env._internal(
      packageName: 'com.tokoin.wallet.dev', appStoreId: '0', appStoreLink: '', prefixUrl: 'tokoin.co/wallet');
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

  const PaymentButton(
      {this.child, required this.type, this.env = Env.prod, this.amount = 0, this.address = '', Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: _onPressed, child: child ?? _defaultButton());
  }

  _defaultButton() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Text(type.name));

  _onPressed() async {
    String url = await _createDynamicLink();
    launch(url);
  }

  Future<String> _createDynamicLink() async {
    return 'https://${env.prefixUrl}/?link=https://tokoin.co/${type.path}?address=$address%26amount=$amount&apn=${env.packageName}&amv=3250001&ibi=${env.packageName}&isi=${env.appStoreId}&ius=${env.appStoreLink}';
  }
}
