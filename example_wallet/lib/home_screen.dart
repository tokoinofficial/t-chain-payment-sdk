import 'package:flutter/material.dart';
import 'package:wallet_example/utils/constants.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Use to demo Qr Code, you can get it when canning a QR Image
  final qrCode =
      'TCHAIN.29f5520f929c599412586be97e27b6c226c38365ebd727ac46fdc7a5ef854bf6';

  @override
  void initState() {
    super.initState();

    TChainPaymentSDK.shared.configWallet(
      apiKey: Constants.apiKey,
      env: TChainPaymentEnv.dev,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'To test T-Chain Payment\nyou can use the example app, click on App to App button to create a deeplink',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  final merchantInfo = await TChainPaymentSDK.shared
                      .getMerchantInfo(qrCode: qrCode);
                  if (merchantInfo == null) return;

                  final result = await TChainPaymentSDK.shared
                      .startPaymentWithMerchantInfo(
                    context,
                    account:
                        Account.fromPrivateKeyHex(hex: Constants.privateKeyHex),
                    merchantInfo: merchantInfo,
                  );

                  final snackBar = SnackBar(
                    content: Text(result ? 'SUCCESS' : 'FAIL'),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Text('Scan Qr'),
              )
            ],
          )),
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
