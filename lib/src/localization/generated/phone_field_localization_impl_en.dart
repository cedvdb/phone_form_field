import 'phone_field_localization_impl.dart';

/// The translations for English (`en`).
class PhoneFieldLocalizationImplEn extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplEn([String locale = 'en']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get invalidCountry => 'Invalid country';

  @override
  String get invalidMobilePhoneNumber => 'Invalid mobile phone number';

  @override
  String get invalidFixedLinePhoneNumber => 'Invalid fixed line phone number';

  @override
  String get requiredPhoneNumber => 'Required phone number';

  @override
  String tapToSelectACountry(String countryName, String countryDialCode) {
    return 'Tap to select a country. Current selection: $countryName $countryDialCode';
  }

  @override
  String get enterPhoneNumber => 'Enter your phone number';
}
