// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'simple_app.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test api and smc', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Click on Start
    final Finder btnStartFinder = find.byKey(const Key('btnStart'));
    expect(btnStartFinder, findsOneWidget);
    await tester.tap(btnStartFinder);

    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(minutes: 5),
    );

    final Finder resultFinder = find.text('SUCCESS');
    expect(resultFinder, findsOneWidget);
  });
}
