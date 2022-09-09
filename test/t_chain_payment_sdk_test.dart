import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';
import 'mock_url_launcher_platform.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

void main() {
  late MockUrlLauncher mock;

  setUp(() {
    TChainPaymentSDK.instance.init(
      merchantID: 'merchantID',
      bundleID: 'bundleID',
      delegate: (result) {},
    );
    mock = MockUrlLauncher();
    UrlLauncherPlatform.instance = mock;
  });
}
