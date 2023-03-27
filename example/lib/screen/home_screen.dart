import 'package:example/cubit/fcm/fcm_cubit.dart';
import 'package:example/cubit/payment/payment_cubit.dart';
import 'package:example/router/screen_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
