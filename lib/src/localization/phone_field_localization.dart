import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'phone_field_localization_delegate.dart';

class PhoneFieldLocalization {
  static PhoneFieldLocalizationDelegate delegate =
      PhoneFieldLocalizationDelegate();
  Locale locale;
  Map<String, String> translations = {};
  PhoneFieldLocalization(this.locale);

  static PhoneFieldLocalization? of(BuildContext context) {
    return Localizations.of<PhoneFieldLocalization>(
      context,
      PhoneFieldLocalization,
    );
  }

  Future load() async {
    String jsonString = await rootBundle.loadString(
        'packages/phone_number_input/assets/translations/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    translations = jsonMap.map((k, v) => MapEntry(k, v.toString()));
  }

  String translate(String key) {
    return translations[key] ?? key;
  }
}
