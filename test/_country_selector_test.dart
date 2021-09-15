import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('CountrySelector', () {
    final builder = ({
      List<String>? favorites,
      bool addFavoritesSeparator = false,
    }) =>
        MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: [
            ...GlobalMaterialLocalizations.delegates,
            PhoneFieldLocalization.delegate,
          ],
          supportedLocales: [Locale('en')],
          home: Scaffold(
            body: Container(),
          ),
        );

    // the test will fail if the second test is uncommented, it's the exact same test
    testWidgets('should be properly sorted without favorites', (tester) async {
      await tester.pumpWidget(builder());
      await tester.pumpAndSettle();
      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsOneWidget);
    });

    // // // same test if added, fails
    // testWidgets('should be properly sorted without favorites', (tester) async {
    //   await tester.pumpWidget(builder());
    //   await tester.pumpAndSettle();
    //   final scaffold = find.byType(Scaffold);
    //   expect(scaffold, findsOneWidget);
    // });
  });
}
