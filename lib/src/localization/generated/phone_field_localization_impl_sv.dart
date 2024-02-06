import 'phone_field_localization_impl.dart';

/// The translations for Swedish (`sv`).
class PhoneFieldLocalizationImplSv extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplSv([String locale = 'sv']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Ogiltigt telefonnummer';

  @override
  String get invalidCountry => 'Ogiltigt land';

  @override
  String get invalidMobilePhoneNumber => 'Ogiltigt mobilnummer';

  @override
  String get invalidFixedLinePhoneNumber => 'Ogiltigt fast telefonnummer';

  @override
  String get requiredPhoneNumber => 'Obligatoriskt telefonnummer';

  @override
  String selectACountry(String countryName) {
    return 'Select a country. Current selection: $countryName';
  }

  @override
  String get phoneNumber => 'Phone number';
}
