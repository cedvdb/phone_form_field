import 'phone_field_localization.dart';

/// The translations for Persian (`fa`).
class PhoneFieldLocalizationFa extends PhoneFieldLocalization {
  PhoneFieldLocalizationFa([super.locale = 'fa']);

  @override
  String get invalidPhoneNumber => 'شماره تلفن نامعتبر است';

  @override
  String get invalidCountry => 'کشور نامعتبر است';

  @override
  String get invalidMobilePhoneNumber => 'شماره تلفن همراه نامعتبر است';

  @override
  String get invalidFixedLinePhoneNumber => 'شماره تلفن ثابت نامعتبر است';

  @override
  String get requiredPhoneNumber => 'شماره تلفن الزامی است';

  @override
  String tapToSelectACountry(String countryName, String countryDialCode) {
    return 'Tap to select a country. Current selection: $countryName $countryDialCode';
  }

  @override
  String get enterPhoneNumber => 'Enter your phone number';
}
