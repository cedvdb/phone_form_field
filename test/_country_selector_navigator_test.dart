import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  group('CountrySelectorNavigator', () {
    Widget getApp(Function(BuildContext ctx) cb) => MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => cb(ctx),
                child: const Text('press'),
              ),
            ),
          ),
        );

    testWidgets('should navigate to dialog', (tester) async {
      const nav = CountrySelectorNavigator.dialog();
      await tester.pumpWidget(getApp((ctx) => nav.navigate(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(CountrySelector), findsOneWidget);
    });

    testWidgets('should navigate to modal bottom sheet', (tester) async {
      const nav = CountrySelectorNavigator.modalBottomSheet();
      await tester.pumpWidget(getApp((ctx) => nav.navigate(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CountrySelector), findsOneWidget);
    });

    testWidgets('should navigate to bottom sheet', (tester) async {
      const nav = CountrySelectorNavigator.bottomSheet();
      await tester.pumpWidget(getApp((ctx) => nav.navigate(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CountrySelector), findsOneWidget);
    });

    testWidgets('should navigate to draggable sheet', (tester) async {
      const nav = CountrySelectorNavigator.draggableBottomSheet();
      await tester.pumpWidget(getApp((ctx) => nav.navigate(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CountrySelector), findsOneWidget);
    });
  });
}
