import 'package:calculator_flutter_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Calculator screen renders with display and keypad', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CalculatorController(),
        child: const MyApp(),
      ),
    );

    expect(find.text('Calculator'), findsOneWidget);
    expect(find.byKey(const Key('displayText')), findsOneWidget);

    // Ensure a few representative keys exist.
    expect(find.bySemanticsLabel('Digit 7'), findsOneWidget);
    expect(find.bySemanticsLabel('Add'), findsOneWidget);
    expect(find.bySemanticsLabel('Equals'), findsOneWidget);
    expect(find.bySemanticsLabel('All Clear'), findsOneWidget);
  });

  testWidgets('Performs a simple addition: 2 + 3 = 5', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CalculatorController(),
        child: const MyApp(),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Digit 2'));
    await tester.pump();

    await tester.tap(find.bySemanticsLabel('Add'));
    await tester.pump();

    await tester.tap(find.bySemanticsLabel('Digit 3'));
    await tester.pump();

    await tester.tap(find.bySemanticsLabel('Equals'));
    await tester.pump();

    final Text display = tester.widget<Text>(find.byKey(const Key('displayText')));
    expect(display.data, '5');
  });

  testWidgets('Divide by zero shows Error and resets on next entry', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CalculatorController(),
        child: const MyApp(),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Digit 8'));
    await tester.pump();

    await tester.tap(find.bySemanticsLabel('Divide'));
    await tester.pump();

    await tester.tap(find.bySemanticsLabel('Digit 0'));
    await tester.pump();

    await tester.tap(find.bySemanticsLabel('Equals'));
    await tester.pump();

    expect(find.text('Error'), findsOneWidget);

    // Next entry should reset state.
    await tester.tap(find.bySemanticsLabel('Digit 1'));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('Error'), findsNothing);
  });
}
