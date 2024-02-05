import 'phone_field_localization.dart';

/// The translations for Ukrainian (`uk`).
class PhoneFieldLocalizationUk extends PhoneFieldLocalization {
  PhoneFieldLocalizationUk([super.locale = 'uk']);

  @override
  String get invalidPhoneNumber => 'Невірний номер телефону';

  @override
  String get invalidCountry => 'Недійсна країна';

  @override
  String get invalidMobilePhoneNumber => 'Невірний номер мобільного телефону';

  @override
  String get invalidFixedLinePhoneNumber =>
      'Невірний номер стаціонарного телефону';

  @override
  String get requiredPhoneNumber => 'Необхідний номер телефону';

  @override
  String tapToSelectACountry(String countryName, String countryDialCode) {
    return 'Tap to select a country. Current selection: $countryName $countryDialCode';
  }

  @override
  String get enterPhoneNumber => 'Enter your phone number';
}
