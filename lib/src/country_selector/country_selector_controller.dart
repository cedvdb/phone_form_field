import 'package:flutter/foundation.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'localization/localization.dart';
import 'search/country_search.dart';
import 'search/searchable_country.dart';

/// Holds the countries shown by the selector and the current search results.
///
/// It is a plain [ChangeNotifier] with no dependency on the widget tree: the
/// selector resolves the localization from its `BuildContext` and hands the
/// already localized countries over through
/// [CountrySelectorController.fromLocalization]. This keeps the controller
/// trivial to unit test.
class CountrySelectorController with ChangeNotifier {
  final List<SearchableCountry> _countries;
  final List<SearchableCountry> _favorites;

  late List<SearchableCountry> _filteredCountries;
  late List<SearchableCountry> _filteredFavoriteCountries;
  String _searchText = '';

  /// The countries matching the current search.
  List<SearchableCountry> get filteredCountries => _filteredCountries;

  /// The favorites matching the current search.
  ///
  /// Always empty while a search is active.
  List<SearchableCountry> get filteredFavorites => _filteredFavoriteCountries;

  CountrySelectorController({
    required List<SearchableCountry> countries,
    required List<SearchableCountry> favorites,
  })  : _countries = List.unmodifiable(countries),
        _favorites = List.unmodifiable(favorites) {
    _filteredCountries = _countries;
    _filteredFavoriteCountries = _favorites;
  }

  /// Builds a controller from iso codes, using [localization] to resolve the
  /// country names and dialing codes.
  factory CountrySelectorController.fromLocalization({
    required Iterable<IsoCode> countries,
    required Iterable<IsoCode> favorites,
    required CountrySelectorLocalization localization,
  }) {
    return CountrySelectorController(
      countries: _localizedCountries(countries, localization),
      favorites: _localizedCountries(favorites, localization),
    );
  }

  /// Filters the countries with [searchedText].
  ///
  /// Listeners are only notified when the results actually change.
  void search(String searchedText) {
    if (searchedText == _searchText) {
      return;
    }
    _searchText = searchedText;
    _filteredCountries = _countries.whereText(searchedText);
    // when there is a search, no need for favorites
    _filteredFavoriteCountries = searchedText.isEmpty ? _favorites : const [];
    notifyListeners();
  }
}

/// Maps [isoCodes] to [SearchableCountry] using [localization], sorted
/// alphabetically by their localized name.
List<SearchableCountry> _localizedCountries(
  Iterable<IsoCode> isoCodes,
  CountrySelectorLocalization localization,
) {
  // we need the localized names in order to search
  return isoCodes
      .map(
        (isoCode) => SearchableCountry(
          isoCode,
          localization.countryDialCode(isoCode),
          localization.countryName(isoCode),
        ),
      )
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));
}
