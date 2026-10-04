import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/src/country_selector/country_selector_controller.dart';
import 'package:phone_form_field/src/country_selector/search/searchable_country.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

void main() {
  group('CountrySelectorController', () {
    final countries = [
      SearchableCountry(IsoCode.FR, '33', 'France'),
      SearchableCountry(IsoCode.BE, '32', 'Belgium'),
      SearchableCountry(IsoCode.ES, '34', 'España'),
    ];
    final favorites = [SearchableCountry(IsoCode.BE, '32', 'Belgium')];

    CountrySelectorController buildController() {
      final controller = CountrySelectorController(
        countries: countries,
        favorites: favorites,
      );
      addTearDown(controller.dispose);
      return controller;
    }

    test('exposes every country and favorite by default', () {
      final controller = buildController();
      expect(controller.filteredCountries, countries);
      expect(controller.filteredFavorites, favorites);
    });

    test('filters the countries when searching', () {
      final controller = buildController();
      controller.search('fra');
      expect(controller.filteredCountries.single.isoCode, IsoCode.FR);
    });

    test('hides the favorites while searching and restores them when cleared',
        () {
      final controller = buildController();
      controller.search('fra');
      expect(controller.filteredFavorites, isEmpty);
      controller.search('');
      expect(controller.filteredFavorites, favorites);
    });

    test('notifies listeners only when the results change', () {
      final controller = buildController();
      var notifications = 0;
      controller.addListener(() => notifications++);

      controller.search('fra');
      expect(notifications, 1);

      // searching the same text again changes nothing
      controller.search('fra');
      expect(notifications, 1);
    });
  });
}
