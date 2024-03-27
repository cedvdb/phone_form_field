import 'phone_field_localization_impl.dart';

/// The translations for Swedish (`sv`).
class PhoneFieldLocalizationImplSv extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplSv([super.locale = 'sv']);

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
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Välj ett land, aktuellt val: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Aktuellt värde: $currentValue';
  }
}
