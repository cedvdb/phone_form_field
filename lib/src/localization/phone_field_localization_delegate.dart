import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phone_number_input/src/localization/phone_field_localization.dart';

class PhoneFieldLocalizationDelegate
    extends LocalizationsDelegate<PhoneFieldLocalization> {
  const PhoneFieldLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en'].contains(locale.languageCode);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;

  @override
  Future<PhoneFieldLocalization> load(Locale locale) async {
    final localizations = PhoneFieldLocalization(locale);
    await localizations.load();
    return localizations;
  }
}
