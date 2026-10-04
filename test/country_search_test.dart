import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/src/country_selector/search/country_search.dart';
import 'package:phone_form_field/src/country_selector/search/searchable_country.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

void main() {
  group('List<SearchableCountry>.whereText', () {
    final countries = [
      SearchableCountry(IsoCode.FR, '33', 'France'),
      SearchableCountry(IsoCode.BE, '32', 'Belgium'),
      SearchableCountry(IsoCode.ES, '34', 'España'),
      SearchableCountry(IsoCode.AD, '376', 'Andorra'),
      SearchableCountry(IsoCode.CA, '1', 'Canada'),
      SearchableCountry(IsoCode.US, '1', 'United States'),
    ];

    test('returns the receiver untouched when the text is empty', () {
      expect(countries.whereText(''), same(countries));
    });

    test('matches the name, case and diacritics insensitively', () {
      expect(countries.whereText('espa').single.isoCode, IsoCode.ES);
      expect(countries.whereText('ESPA').single.isoCode, IsoCode.ES);
      // the search text itself is de-diacriticized too
      expect(countries.whereText('España').single.isoCode, IsoCode.ES);
      expect(countries.whereText('belg').single.isoCode, IsoCode.BE);
    });

    test('puts the countries whose name starts with the search first', () {
      final result = countries.whereText('an');
      expect(
        result.first.isoCode,
        IsoCode.AD,
        reason: 'Andorra starts with the searched text',
      );
      expect(result.map((c) => c.isoCode), contains(IsoCode.CA));
      expect(result.map((c) => c.isoCode), contains(IsoCode.FR));
    });

    test('ignores a leading + and searches the dialing code', () {
      expect(countries.whereText('+33').single.isoCode, IsoCode.FR);
      expect(countries.whereText('33').single.isoCode, IsoCode.FR);
    });

    test('puts the dialing codes that start with the search first', () {
      final result = countries.whereText('3');
      expect(
        result.map((c) => c.isoCode),
        containsAll([IsoCode.FR, IsoCode.BE, IsoCode.ES]),
      );
      expect(result.map((c) => c.isoCode), isNot(contains(IsoCode.US)));
      expect(result.first.dialCode.startsWith('3'), isTrue);
    });
  });
}
