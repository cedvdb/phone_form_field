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
      const nav = DialogNavigator();
      await tester.pumpWidget(getApp((ctx) => nav.navigate(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(CountrySelector), findsOneWidget);
    });

    testWidgets('should navigate to modal bottom sheet', (tester) async {
      const nav = ModalBottomSheetNavigator();
      await tester.pumpWidget(getApp((ctx) => nav.navigate(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(CountrySelector), findsOneWidget);
    });

    testWidgets('should navigate to bottom sheet', (tester) async {
      const nav = BottomSheetNavigator();
      await tester.pumpWidget(getApp((ctx) => nav.navigate(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(CountrySelector), findsOneWidget);
    });
  });
}
