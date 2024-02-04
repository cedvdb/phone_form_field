// responsible of searching through the country list

import 'package:diacritic/diacritic.dart';
import 'package:phone_form_field/phone_form_field.dart';

class CountryFinder {
  List<LocalizedCountry> whereText({
    required String text,
    required List<LocalizedCountry> countries,
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
      return _filterByName(searchTxt: text, countries: countries);
    }
  }

  List<LocalizedCountry> _filterByCountryCallingCode({
    required String countryCallingCode,
    required List<LocalizedCountry> countries,
  }) {
    int getSortPoint(LocalizedCountry country) =>
        country.countryDialingCode == countryCallingCode ? 1 : 0;

    return countries
        .where((country) =>
            country.countryDialingCode.contains(countryCallingCode))
        .toList()
      // puts the closest match at the top
      ..sort((a, b) => getSortPoint(b) - getSortPoint(a));
  }

  List<LocalizedCountry> _filterByName({
    required String searchTxt,
    required List<LocalizedCountry> countries,
  }) {
    searchTxt = removeDiacritics(searchTxt.toLowerCase());
    // since we keep countries that contain the searched text,
    // we need to put the countries that start with that text in front.
    int getSortPoint(String name, IsoCode isoCode) {
      bool isStartOfString = name.startsWith(searchTxt) ||
          isoCode.name.toLowerCase().startsWith(searchTxt);
      return isStartOfString ? 1 : 0;
    }

    int compareCountries(LocalizedCountry a, LocalizedCountry b) {
      final sortPoint =
          getSortPoint(b.name, b.isoCode) - getSortPoint(a.name, a.isoCode);
      // sort alphabetically when comparison with search term get same result
      return sortPoint == 0 ? a.name.compareTo(b.name) : sortPoint;
    }

    return countries.where((country) {
      final countryName = removeDiacritics(country.name.toLowerCase());
      return countryName.contains(searchTxt) ||
          country.isoCode.name.toLowerCase().contains(searchTxt);
    }).toList()
      // puts the ones that begin by txt first
      ..sort(compareCountries);
  }
}
