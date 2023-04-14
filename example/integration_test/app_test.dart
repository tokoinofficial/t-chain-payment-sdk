import 'package:example/screen/payment_result_screen.dart';
import 'package:example/screen/pos_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:example/main.dart' as app;
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test POS QR flow', (tester) async {
    app.main();
    await tester.pumpAndSettle(
      const Duration(seconds: 1),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 20),
    );

    // Home: click on POS QR
    final Finder btnPosQrFinder = find.byKey(const Key('btnPosQr'));
    expect(btnPosQrFinder, findsOneWidget);
    await tester.tap(btnPosQrFinder);
    await tester.pumpAndSettle();

    // Go to POS QR screen
    expect(find.byType(PosQrScreen), findsOneWidget);

    // input: USD 100
    final amountFinder = find.byKey(const Key('txtAmount'));
    await tester.enterText(amountFinder, '100');
    await tester.pumpAndSettle();
    final currencyDropdownFinder = find.byKey(const Key('btnCurrency'));
    await tester.tap(currencyDropdownFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(Currency.usd.shortName)).last);
    await tester.pumpAndSettle();

    // Tap on Show QR
    await tester.tap(find.byKey(const Key('btnShowQr')).last);
    await tester.pumpAndSettle();

    // expect find 'USD 100'
    expect(find.byType(PaymentResultScreen), findsOneWidget);
    await tester.pumpAndSettle(
      const Duration(seconds: 1),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 20),
    );
    expect(find.text('USD 100.0'), findsOneWidget);

    // back to POS QR screen
    final backButton = find.byTooltip("Back");
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    // input: IDR 100
    await tester.tap(currencyDropdownFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(Currency.idr.shortName)).last);
    await tester.pumpAndSettle();

    // Tap on Show QR
    await tester.tap(find.byKey(const Key('btnShowQr')));
    await tester.pumpAndSettle();

    // expect find 'IDR 111'
    expect(find.byType(PaymentResultScreen), findsOneWidget);
    await tester.pumpAndSettle(
      const Duration(seconds: 1),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 20),
    );
    expect(find.text('IDR 100.0'), findsOneWidget);
  });
}
