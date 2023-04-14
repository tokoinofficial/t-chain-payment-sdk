import 'package:example/cubit/fcm/fcm_cubit.dart';
import 'package:example/cubit/payment/payment_cubit.dart';
import 'package:example/firebase_options.dart';
import 'package:example/router/screen_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(BlocProvider<FcmCubit>(
    create: (context) => FcmCubit(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _router = ScreenRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FcmCubit()),
        BlocProvider(create: (context) => PaymentCubit()),
      ],
      child: MaterialApp(
        title: 'T-Chain Payment SDK Demo',
        localizationsDelegates: const [
          TChainPaymentLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('id'), // Indonesia
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: ScreenRouter.root,
        onGenerateRoute: _router.generateRoute,
      ),
    );
  }
}
