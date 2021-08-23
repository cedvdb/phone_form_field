import 'package:flutter/material.dart';
import 'package:phone_form_field/src/localization/phone_field_localization.dart';

class PhoneFieldLocalizationDelegate
    extends LocalizationsDelegate<PhoneFieldLocalization> {
  const PhoneFieldLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    final found = [
      'ar',
      'ara',
      'de',
      'en',
      'es',
      'fr',
      'hin',
      'it',
      'nl',
      'pt',
      'ru',
      'zh',
    ].contains(locale.languageCode);
    return found;
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
