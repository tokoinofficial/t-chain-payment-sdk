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

  // testWidgets('test buttons', (WidgetTester tester) async {
  //   await tester.runAsync(() async {
  //     Widget testWidget = const MediaQuery(
  //       data: MediaQueryData(),
  //       child: MaterialApp(
  //         home: Scaffold(
  //           body: TWPaymentButton(
  //             action: TWPaymentAction.deposit,
  //             amount: 10,
  //           ),
  //         ),
  //       ),
  //     );
  //     mock
  //       ..setLaunchExpectations(
  //         url:
  //             'mtwallet://app/otc?merchant_id=merchantID&order_id=&amount=10&bundle_id=bundleID',
  //         useSafariVC: true,
  //         useWebView: false,
  //         universalLinksOnly: false,
  //         enableJavaScript: false,
  //         enableDomStorage: false,
  //         headers: <String, String>{},
  //         webOnlyWindowName: null,
  //       )
  //       ..setResponse(true);
  //     await tester.pumpWidget(testWidget);
  //     expect(find.byType(TWPaymentButton), findsOneWidget);
  //     await tester.tap(find.byType(TWPaymentButton));
  //     await tester.pumpAndSettle();
  //   });
  // });
}
