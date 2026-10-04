// responsible of searching through the country list

import 'package:diacritic/diacritic.dart';

import 'searchable_country.dart';

/// Search helpers over a list of [SearchableCountry].
///
/// This is deliberately kept as pure, widget independent logic (see
/// [SearchableCountry]) so that it can be unit tested without pumping a
/// widget.
extension SearchableCountryList on List<SearchableCountry> {
  /// Returns the countries matching [text].
  ///
  /// [text] is either a country name (matched case and diacritics
  /// insensitively) or a country calling code (an optional leading `+` is
  /// ignored). The closest matches are returned first. When [text] is empty,
  /// the receiver is returned untouched.
  List<SearchableCountry> whereText(String text) {
    // remove + if search text starts with +
    if (text.startsWith('+')) {
      text = text.substring(1);
    }
    // reset search
    if (text.isEmpty) {
      return this;
    }

    // if the text is a number we check the country code instead
    if (int.tryParse(text) != null) {
      return _filterByCountryCallingCode(text);
    }
    return _filterByName(text);
  }

  List<SearchableCountry> _filterByCountryCallingCode(
    String countryCallingCode,
  ) {
    int computeSortScore(SearchableCountry country) =>
        country.dialCode.startsWith(countryCallingCode) ? 0 : 1;

    return where((country) => country.dialCode.contains(countryCallingCode))
        .toList()
      // puts the closest match at the top
      ..sort((a, b) => computeSortScore(a) - computeSortScore(b));
  }

  List<SearchableCountry> _filterByName(String searchText) {
    final normalizedSearchText = removeDiacritics(searchText.toLowerCase());

    int computeSortScore(SearchableCountry country) =>
        country.searchableName.startsWith(normalizedSearchText) ? 0 : 1;
    return where(
      (country) => country.searchableName.contains(normalizedSearchText),
    ).toList()
      // puts the closest match at the top
      ..sort((a, b) => computeSortScore(a) - computeSortScore(b));
  }
}
