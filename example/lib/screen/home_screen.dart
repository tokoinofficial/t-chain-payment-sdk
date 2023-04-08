import 'package:example/cubit/fcm/fcm_cubit.dart';
import 'package:example/cubit/payment/payment_cubit.dart';
import 'package:example/router/screen_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    context.read<FcmCubit>().initialFcm();
    context.read<PaymentCubit>().initial();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FcmCubit, FcmState>(
      listener: (context, state) {
        if (state is FcmMessageReceived) {
          context
              .read<PaymentCubit>()
              .receiveNotification(state.fcmNotification);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('T-Chain Payment Examples')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  key: const Key('btnAppToApp'),
                  onPressed: () {
                    Navigator.of(context).pushNamed(ScreenRouter.appToApp);
                  },
                  child: const Text('App to App'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  key: const Key('btnPosQr'),
                  onPressed: () {
                    Navigator.of(context).pushNamed(ScreenRouter.posQr);
                  },
                  child: const Text('POS QR'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  key: const Key('openWithQrCode'),
                  onPressed: () {
                    const qrCode =
                        'TCHAIN.fa19615f226a28a82befd19644281f9a3dafe4cbefbfd7ab4ff5ed995cc7e7ca';
                    TChainPaymentSDK.instance.startPayment(
                      context,
                      qrCode: qrCode,
                    );
                  },
                  child: const Text('Open with QrCode'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  key: const Key('openWithMerchantInfo'),
                  onPressed: () {
                    final merchantInfo = MerchantInfo(
                      merchantId: '7b6dd425-a8cf-448c-bf57-d13fc7aba584',
                      currency: Currency.idr.shortName,
                      fullname: 'T Chain',
                      amount: 1,
                      qrCode:
                          'TCHAIN.29f5520f929c599412586be97e27b6c226c38365ebd727ac46fdc7a5ef854bf6',
                      status: 1,
                      chainId: '56',
                    );

                    TChainPaymentSDK.instance.startPayment(
                      context,
                      merchantInfo: merchantInfo,
                    );
                  },
                  child: const Text('Open with MerchantInfo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
