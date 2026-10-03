// responsible of searching through the country list

import 'package:diacritic/diacritic.dart';

import 'searchable_country.dart';

class CountryFinder {
  List<SearchableCountry> whereText({
    required String text,
    required List<SearchableCountry> countries,
  }) {
    // remove + if search text starts with +
    if (text.startsWith('+')) {
      text = text.substring(1);
    }
    // reset search
    if (text.isEmpty) {
      return countries;
    }

    // if the txt is a number we check the country code instead
    final asInt = int.tryParse(text);
    final isInt = asInt != null;
    if (isInt) {
      // toString to remove any + in front if its an int
      return _filterByCountryCallingCode(
          countryCallingCode: text, countries: countries);
    } else {
      return _filterByName(searchText: text, countries: countries);
    }
  }

  List<SearchableCountry> _filterByCountryCallingCode({
    required String countryCallingCode,
    required List<SearchableCountry> countries,
  }) {
    int computeSortScore(SearchableCountry country) =>
        country.dialCode.startsWith(countryCallingCode) ? 0 : 1;

    return countries
        .where((country) => country.dialCode.contains(countryCallingCode))
        .toList()
      // puts the closest match at the top
      ..sort((a, b) => computeSortScore(a) - computeSortScore(b));
  }

  List<SearchableCountry> _filterByName({
    required String searchText,
    required List<SearchableCountry> countries,
  }) {
    searchText = removeDiacritics(searchText.toLowerCase());

    int computeSortScore(SearchableCountry country) =>
        country.searchableName.startsWith(searchText) ? 0 : 1;
    return countries
        .where((country) =>
            country.searchableName.contains(searchText.toLowerCase()))
        .toList()
      // puts the closest match at the top
      ..sort((a, b) => computeSortScore(a) - computeSortScore(b));
  }
}
