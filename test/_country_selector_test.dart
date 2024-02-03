import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/country_selection/no_result_view.dart';
import 'package:phone_form_field/src/country_selection/search_box.dart';

void main() {
  group('CountrySelector', () {
    Widget buildSelector({List<IsoCode> favorites = const []}) {
      return MaterialApp(
        locale: const Locale('en', ''),
        localizationsDelegates: const [
          ...GlobalMaterialLocalizations.delegates,
          PhoneFieldLocalization.delegate,
        ],
        supportedLocales: const [Locale('es', '')],
        home: Scaffold(
          body: CountrySelector(
            onCountrySelected: (c) {},
            favoriteCountries: favorites,
          ),
        ),
      );
    }

    testWidgets('Should filter with text', (tester) async {
      await tester.pumpWidget(buildSelector());
      await tester.pump(const Duration(seconds: 1));
      final txtFound = find.byType(SearchBox);
      expect(txtFound, findsOneWidget);
      await tester.enterText(txtFound, 'esp');
      await tester.pump(const Duration(seconds: 1));
      final tiles = find.byType(ListTile);
      expect(tiles, findsWidgets);
      expect(tester.widget<ListTile>(tiles.first).key, equals(const Key('ES')));
      // not the right language (we let english go through tho)
      await tester.enterText(txtFound, 'Espagne');
      await tester.pump(const Duration(seconds: 1));
      expect(tiles, findsNothing);
      await tester.pump(const Duration(seconds: 1));
      // country codes
      await tester.enterText(txtFound, '33');
      await tester.pump(const Duration(seconds: 1));
      expect(tiles, findsWidgets);
      expect(tester.widget<ListTile>(tiles.first).key, equals(const Key('FR')));
    });

    testWidgets('should show a divider between favorites and all countries',
        (tester) async {
      await tester.pumpWidget(buildSelector(favorites: const [IsoCode.BE]));
      await tester.pump(const Duration(seconds: 1));
      final list = find.byType(ListView);
      expect(list, findsOneWidget);
      final allTiles = find.descendant(
        of: list,
        matching: find.byWidgetPredicate(
          (Widget widget) => widget is ListTile || widget is Divider,
        ),
      );

      expect(allTiles, findsWidgets);
      expect(
        tester.widget(allTiles.at(1)),
        isA<Divider>(),
        reason: 'separator should be visible after the favorites countries',
      );
    });

    testWidgets('should hide favorites when search has started',
        (tester) async {
      await tester.pumpWidget(buildSelector(favorites: const [IsoCode.BE]));
      await tester.pump(const Duration(seconds: 1));
      final searchBox = find.byType(SearchBox);
      expect(searchBox, findsOneWidget);
      await tester.enterText(searchBox, 'belg');
      await tester.pump(const Duration(seconds: 1));
      final tiles = find.byType(ListTile);
      expect(tiles, findsOneWidget);
    });

    testWidgets('should sort countries', (tester) async {
      await tester
          .pumpWidget(buildSelector(favorites: const [IsoCode.SE, IsoCode.SG]));
      await tester.pump(const Duration(seconds: 1));
      final allTiles = find.byType(ListTile, skipOffstage: false);
      expect(allTiles, findsWidgets);
      expect(tester.widget<ListTile>(allTiles.at(0)).key,
          equals(Key(IsoCode.SG.name)));
      expect(tester.widget<ListTile>(allTiles.at(1)).key,
          equals(Key(IsoCode.SE.name)));
    });

    testWidgets('should display no result when there is no result',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CountrySelector(
            onCountrySelected: (c) {},
          ),
        ),
      ));

      final searchBox = find.byType(SearchBox);
      expect(searchBox, findsOneWidget);
      await tester.enterText(searchBox, 'fake search with no result');
      await tester.pumpAndSettle();

      // no listitem should be displayed when no result found
      final allTiles = find.byType(ListTile);
      expect(allTiles, findsNothing);

      final noResultWidget = find.byType(NoResultView);
      expect(noResultWidget, findsOneWidget);
    });
  });
}
