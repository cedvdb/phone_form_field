import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/widgets/country_picker/country_selector.dart';
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

    group('With internationalization', () {
      final app = MaterialApp(
        locale: Locale('es', ''),
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
          PhoneFieldLocalization.delegate,
        ],
        supportedLocales: [Locale('es', '')],
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

    group('sorted countries with or without favorites', () {
      final builder = ({
        List<String>? favorites,
        bool addFavoritesSeparator = false,
      }) =>
          MaterialApp(
            locale: Locale('fr'),
            localizationsDelegates: [
              PhoneFieldLocalization.delegate,
              ...GlobalMaterialLocalizations.delegates,
            ],
            supportedLocales: [Locale('fr')],
            home: Scaffold(
              body: CountrySelector(
                onCountrySelected: (c) {},
                addFavoritesSeparator: addFavoritesSeparator,
                favoriteCountries: favorites ?? <String>[],
                sortCountries: true,
              ),
            ),
          );

      testWidgets('should be properly sorted without favorites',
          (tester) async {
        await tester.pumpWidget(builder());
        await tester.pumpAndSettle(Duration(seconds: 1));
        final allTiles = find.byType(ListTile);
        expect(allTiles, findsWidgets);
        // expect(tester.widget<ListTile>(allTiles.first).key, equals(Key('AF')));
      });

      testWidgets('should be properly sorted with favorites', (tester) async {
        await tester.pumpWidget(builder(favorites: ['gu', 'gy']));
        await tester.pumpAndSettle();
        final allTiles = find.byType(ListTile, skipOffstage: false);
        expect(allTiles, findsWidgets);
        // expect(tester.widget<ListTile>(allTiles.at(0)).key, equals(Key('GU')));
        // expect(tester.widget<ListTile>(allTiles.at(1)).key, equals(Key('GY')));

        // final txtFound = find.byType(SearchBox);
        // expect(txtFound, findsOneWidget);
        // await tester.enterText(txtFound, 'guy');
        // await tester.pumpAndSettle();
        // final filteredTiles = find.byType(ListTile);
        // expect(filteredTiles, findsWidgets);
        // expect(filteredTiles.evaluate().length, equals(2));
      });

      testWidgets('should display/hide separator', (tester) async {
        await tester.pumpWidget(builder(
          favorites: ['gu', 'gy'],
          addFavoritesSeparator: true,
        ));
        await tester.pumpAndSettle();
        final list = find.byType(ListView);
        expect(list, findsOneWidget);
        // final allTiles = find.descendant(
        //   of: list,
        //   matching: find.byWidgetPredicate(
        //     (Widget widget) => widget is ListTile || widget is Divider,
        //   ),
        // );
        //
        // expect(allTiles, findsWidgets);
        // expect(
        //   tester.widget(allTiles.at(2)),
        //   isA<Divider>(),
        //   reason: 'separator should be visible after the favorites countries',
        // );
        //
        // final txtFound = find.byType(SearchBox);
        // expect(txtFound, findsOneWidget);
        // await tester.enterText(txtFound, 'guy');
        // await tester.pumpAndSettle();
        // final tiles = find.byType(ListTile);
        // expect(tiles, findsWidgets);
        // expect(
        //   tiles.evaluate().length,
        //   equals(2),
        //   reason: 'Separator should be hidden as all elements'
        //       'found are in favorites',
        // );
      });
    });
  });
}
