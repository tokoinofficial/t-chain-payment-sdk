import 'package:flutter/material.dart';
import 'package:wallet_example/utils/deeplink.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    DeepLinkService.shared.setup(context);
    DeepLinkService.shared.onReceived = DeepLinkService.shared.handleUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet example app'),
      ),
      body: const Center(
        child: Text('Wallet example app'),
      ),
    );
  }
}
