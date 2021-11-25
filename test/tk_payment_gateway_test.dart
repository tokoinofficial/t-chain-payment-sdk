import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tk_payment_gateway/tk_payment_gateway.dart';
import 'mock_url_launcher_platform.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

void main() {
  late MockUrlLauncher mock;

  setUp(() {
    mock = MockUrlLauncher();
    UrlLauncherPlatform.instance = mock;
  });

  testWidgets('test buttons', (WidgetTester tester) async {
    await tester.runAsync(() async {
      Widget testWidget = const MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(home: Scaffold(body: PaymentButton(type: Type.sendToko))));
      mock
        ..setLaunchExpectations(
          url:
              'https://deeplink-wallet.tokoin.io/wallet/?link=https://tokoin.co/sendToko?address=%26amount=0&apn=com.tokoin.wallet&amv=3250001&ibi=com.tokoin.wallet&isi=1489276175&ius=https://apps.apple.com/us/app/my-t-wallet/id1489276175',
          useSafariVC: true,
          useWebView: false,
          universalLinksOnly: false,
          enableJavaScript: false,
          enableDomStorage: false,
          headers: <String, String>{},
          webOnlyWindowName: null,
        )
        ..setResponse(true);
      await tester.pumpWidget(testWidget);
      expect(find.byType(PaymentButton), findsOneWidget);
      await tester.tap(find.byType(PaymentButton));
      await tester.pumpAndSettle();
    });
  });
}
