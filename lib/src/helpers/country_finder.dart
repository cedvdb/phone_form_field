// responsible of searching through the country list

import 'package:diacritic/diacritic.dart';
import 'package:phone_form_field/src/models/iso_code.dart';

import '../models/country.dart';

class CountryFinder {
  late final List<Country> _allCountries;
  late List<Country> _filteredCountries;
  List<Country> get filteredCountries => _filteredCountries;

  bool get isNotEmpty => _filteredCountries.isNotEmpty;
  String _searchedText = '';
  String get searchedText => _searchedText;

  CountryFinder(List<Country> allCountries, {bool sort = true}) {
    _allCountries = [...allCountries];
    if (sort) {
      _allCountries.sort((a, b) => a.name.compareTo(b.name));
    }
    _filteredCountries = [..._allCountries];
  }

  // filter a
  void filter(String txt) {
    if (txt == _searchedText) {
      return;
    }
    _searchedText = txt;
    // reset search
    if (txt.isEmpty) {
      _filteredCountries = [..._allCountries];
    }

    // if the txt is a number we check the country code instead
    final asInt = int.tryParse(txt);
    final isInt = asInt != null;
    if (isInt) {
      // toString to remove any + in front if its an int
      _filterByCountryCallingCode(txt);
    } else {
      _filterByName(txt);
    }
  }

  void _filterByCountryCallingCode(String countryCallingCode) {
    int getSortPoint(Country country) =>
        country.countryCode == countryCallingCode ? 1 : 0;

    _filteredCountries = _allCountries
        .where((country) => country.countryCode.contains(countryCallingCode))
        .toList()
      // puts the closest match at the top
      ..sort((a, b) => getSortPoint(b) - getSortPoint(a));
  }

  void _filterByName(String searchTxt) {
    searchTxt = removeDiacritics(searchTxt.toLowerCase());
    // since we keep countries that contain the searched text,
    // we need to put the countries that start with that text in front.
    int getSortPoint(String name, IsoCode isoCode) {
      bool isStartOfString = name.startsWith(searchTxt) ||
          isoCode.name.toLowerCase().startsWith(searchTxt);
      return isStartOfString ? 1 : 0;
    }

    int compareCountries(Country a, Country b) {
      final sortPoint =
          getSortPoint(b.name, b.isoCode) - getSortPoint(a.name, a.isoCode);
      // sort alphabetically when comparison with search term get same result
      return sortPoint == 0 ? a.name.compareTo(b.name) : sortPoint;
    }

    _filteredCountries = _allCountries.where((country) {
      final countryName = removeDiacritics(country.name.toLowerCase());
      return countryName.contains(searchTxt);
    }).toList()
      // puts the ones that begin by txt first
      ..sort(compareCountries);
  }
}
