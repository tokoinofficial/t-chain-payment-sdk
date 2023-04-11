import 'package:flutter/material.dart';
import 'package:wallet_example/home_screen.dart';

class ExampleWalletApp extends StatefulWidget {
  const ExampleWalletApp({Key? key}) : super(key: key);

  @override
  State<ExampleWalletApp> createState() => _ExampleWalletAppState();
}

class _ExampleWalletAppState extends State<ExampleWalletApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
