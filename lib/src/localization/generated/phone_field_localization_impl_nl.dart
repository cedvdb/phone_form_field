import 'phone_field_localization_impl.dart';

/// The translations for Dutch Flemish (`nl`).
class PhoneFieldLocalizationImplNl extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplNl([String locale = 'nl']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Ongeldig telefoonnummer';

  @override
  String get invalidCountry => 'Ongeldig land';

  @override
  String get invalidMobilePhoneNumber => 'Ongeldig mobiel nummer';

  @override
  String get invalidFixedLinePhoneNumber => 'Ongeldig vast nummer';

  @override
  String get requiredPhoneNumber => 'Telefoonnummer vereist';

  @override
  String selectACountry(String countryName) {
    return 'Select a country. Current selection: $countryName';
  }

  @override
  String get phoneNumber => 'Phone number';
}
