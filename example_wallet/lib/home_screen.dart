import 'package:flutter/material.dart';
import 'package:wallet_example/utils/constants.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    TChainPaymentSDK.shared.configWallet(
      apiKey: Constants.apiKey,
      onDeeplinkReceived: _handleUrl,
    );
  }

  @override
  void dispose() {
    super.dispose();
    DeepLinkService.shared.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet example app'),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: const Center(
          child: Text(
            'To test T-Chain Payment\nyou can use the example app, click on App to App button to create a deeplink',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  _handleUrl(Uri deepLink) {
    // T-Chain payment
    if (deepLink.scheme == 'walletexample' && deepLink.host == 'app') {
      final qrCode = deepLink.queryParameters['qr_code'] ?? '';
      final bundleId = deepLink.queryParameters['bundle_id'] ?? '';

      switch (deepLink.path) {
        case '/payment_deposit':
          TChainPaymentSDK.shared.startPaymentWithQrCode(
            context,
            account: Account.fromPrivateKeyHex(hex: Constants.privateKeyHex),
            qrCode: qrCode,
            bundleId: bundleId,
          );

          break;
      }
    }
  }
}
