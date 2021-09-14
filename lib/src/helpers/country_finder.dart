// responsible of searching through the country list

import 'package:flutter/cupertino.dart';

import '../localization/phone_field_localization.dart';
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

  List<Country> filter(String txt, BuildContext context) {
    // reset search
    if (txt.isEmpty) {
      // see [countries] property comment for more infos
      // about reason of copy
      return [...countries];
    }

    // if the txt is a number we check the dial code instead
    final asInt = int.tryParse(txt);
    final isNum = asInt != null;
    if (isNum) {
      // toString to remove any + in front if its an int
      return _filterByDialCode(asInt!.toString());
    } else {
      return _filterByName(txt, context);
    }
  }

  List<Country> _filterByDialCode(String dialCode) {
    final getSortPoint =
        (Country c) => c.dialCode.length == dialCode.length ? 1 : 0;

    return countries.where((c) => c.dialCode.contains(dialCode)).toList()
      // puts the closest match at the top
      ..sort((a, b) => getSortPoint(b) - getSortPoint(a));
  }

  List<Country> _filterByName(String txt, BuildContext context) {
    final PhoneFieldLocalization? localization =
        PhoneFieldLocalization.of(context);
    final lowerCaseTxt = txt.toLowerCase();
    // since we keep countries that contain the searched text,
    // we need to put the countries that start with that text in front.
    final getSortPoint = (name, isoCode) {
      bool isStartOfString = name.startsWith(lowerCaseTxt) ||
          isoCode.toLowerCase().startsWith(lowerCaseTxt);
      return isStartOfString ? 1 : 0;
    };

    final compareCountries = (Country a, Country b) {
      final aName = a.localisedName(context, localization).toLowerCase();
      final bName = b.localisedName(context, localization).toLowerCase();
      final sortPoint =
          getSortPoint(bName, b.isoCode) - getSortPoint(aName, a.isoCode);
      // sort alphabetically when comparison with search term get same result
      return sortPoint == 0 ? aName.compareTo(bName) : sortPoint;
    };

    final match = (Country c) =>
        c
            .localisedName(context, localization)
            .toLowerCase()
            .contains(lowerCaseTxt) ||
        c.name.toLowerCase().contains(lowerCaseTxt);

    return countries.where(match).toList()
      // puts the ones that begin by txt first
      ..sort(compareCountries);
  }
}
