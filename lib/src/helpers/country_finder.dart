// responsible of searching through the country list

import 'package:flutter/cupertino.dart';

import '../models/country.dart';
import '../localization/phone_field_localization.dart';

class CountryFinder {
  final List<Country> countries;
  CountryFinder(this.countries);

  List<Country> filter(String txt, BuildContext context) {
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
    final lowerCaseTxt = txt.toLowerCase();
    // since we keep countries that contain the searched text,
    // we need to put the countries that start with that text in front.
    final getSortPoint = (Country c) {
      final name = _getTranslatedName(c, context);
      bool isStartOfString = name.startsWith(lowerCaseTxt) ||
          c.isoCode.toLowerCase().startsWith(lowerCaseTxt);
      return isStartOfString ? 1 : 0;
    };

    return countries
        .where((c) => _getTranslatedName(c, context).contains(lowerCaseTxt))
        .toList()
      // puts the ones that begin by txt first
      ..sort((a, b) => getSortPoint(b) - getSortPoint(a));
  }

  _getTranslatedName(Country country, BuildContext context) {
    final translatedName =
        PhoneFieldLocalization.of(context)?.translate(country.isoCode);
    String name = translatedName ?? country.name;
    return name.toLowerCase();
  }
}
