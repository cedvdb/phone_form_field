import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phone_form_field/src/widgets/country_picker/search_box.dart';

void main() {
  group('CountrySelector', () {
    group('Without internationalization', () {
      final app = MaterialApp(
        home: Scaffold(
          body: CountrySelector(onCountrySelected: (c) {}),
        ),
      );

      testWidgets('Should filter with text', (tester) async {
        await tester.pumpWidget(app);
        await tester.pumpAndSettle();
        final txtFound = find.byType(SearchBox);
        expect(txtFound, findsOneWidget);
        await tester.enterText(txtFound, 'sp');
        await tester.pumpAndSettle();
        final tiles = find.byType(ListTile);
        expect(tiles, findsOneWidget);
        expect(tester.widget<ListTile>(tiles.first).key, equals(Key('ES')));
        // not the right language (we let english go through tho)
        await tester.enterText(txtFound, 'Espagne');
        await tester.pumpAndSettle();
        expect(tiles, findsNothing);
        await tester.pumpAndSettle();
        // dial codes
        await tester.enterText(txtFound, '33');
        await tester.pumpAndSettle();
        expect(tiles, findsWidgets);
        expect(tester.widget<ListTile>(tiles.first).key, equals(Key('FR')));
      });
    });

    group('With internationalization', () {
      final app = MaterialApp(
        locale: Locale('es', ''),
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
          PhoneFieldLocalization.delegate,
        ],
        supportedLocales: [Locale('es')],
        home: Scaffold(
          body: CountrySelector(onCountrySelected: (c) {}),
        ),
      );

      testWidgets('Should filter with text', (tester) async {
        await tester.pumpWidget(app);
        await tester.pump(Duration(seconds: 1));
        await tester.pumpAndSettle();
        final txtFound = find.byType(SearchBox);
        expect(txtFound, findsOneWidget);
        await tester.enterText(txtFound, 'esp');
        await tester.pumpAndSettle();
        final tiles = find.byType(ListTile);
        expect(tiles, findsWidgets);
        expect(tester.widget<ListTile>(tiles.first).key, equals(Key('ES')));
        // not the right language (we let english go through tho)
        await tester.enterText(txtFound, 'Espagne');
        await tester.pumpAndSettle();
        expect(tiles, findsNothing);
        await tester.pumpAndSettle();
        // dial codes (cant put it in another test widgets for some reason it fails)
        await tester.enterText(txtFound, '33');
        await tester.pumpAndSettle();
        expect(tiles, findsWidgets);
        expect(tester.widget<ListTile>(tiles.first).key, equals(Key('FR')));
      });
    });
  });
}
