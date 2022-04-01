// responsible of searching through the country list

import 'package:flutter/cupertino.dart';
import 'package:phone_form_field/src/helpers/country_translator.dart';

import '../models/country.dart';

class CountryFinder {
  // This property and the list order MUST BE immutable to ensure
  // consistent filtered results.
  // This is the reason of clone operations performed in constructor
  // and filter methods, as we cannot assume that others classes don't
  // modify the list order and this will have consequences on the order
  // of filtered list.
  /// List of countries to search in
  final List<Country> countries;

  CountryFinder(List<Country> countries) : countries = [...countries];

  // filter a
  List<Country> filter(String txt, BuildContext context) {
    // reset search
    if (txt.isEmpty) {
      // see [countries] property comment for more infos
      // about reason of copy
      return [...countries];
    }

    // if the txt is a number we check the country code instead
    final asInt = int.tryParse(txt);
    final isNum = asInt != null;
    if (isNum) {
      // toString to remove any + in front if its an int
      return _filterByDialCode(asInt.toString());
    } else {
      return _filterByName(txt, context);
    }
  }

  List<Country> _filterByDialCode(String searchedCountryCode) {
    int getSortPoint(Country country) =>
        country.countryCode.length == searchedCountryCode.length ? 1 : 0;

    return countries
        .where((country) => country.countryCode.contains(searchedCountryCode))
        .toList()
      // puts the closest match at the top
      ..sort((a, b) => getSortPoint(b) - getSortPoint(a));
  }

  List<Country> _filterByName(String txt, BuildContext context) {
    final lowerCaseTxt = txt.toLowerCase();
    // since we keep countries that contain the searched text,
    // we need to put the countries that start with that text in front.
    int getSortPoint(String name, String isoCode) {
      bool isStartOfString = name.startsWith(lowerCaseTxt) ||
          isoCode.toLowerCase().startsWith(lowerCaseTxt);
      return isStartOfString ? 1 : 0;
    }

    int compareCountries(Country a, Country b) {
      final aName = CountryTranslator.localisedName(context, a).toLowerCase();
      final bName = CountryTranslator.localisedName(context, b).toLowerCase();
      final sortPoint =
          getSortPoint(bName, b.isoCode) - getSortPoint(aName, a.isoCode);
      // sort alphabetically when comparison with search term get same result
      return sortPoint == 0 ? aName.compareTo(bName) : sortPoint;
    }

    bool match(Country c) => CountryTranslator.localisedName(context, c)
        .toLowerCase()
        .contains(lowerCaseTxt);

    return countries.where(match).toList()
      // puts the ones that begin by txt first
      ..sort(compareCountries);
  }
}
