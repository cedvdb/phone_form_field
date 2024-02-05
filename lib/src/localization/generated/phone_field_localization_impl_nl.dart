import 'phone_field_localization_impl.dart';

/// The translations for Dutch Flemish (`nl`).
class PhoneFieldLocalizationImplNl extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplNl([super.locale = 'nl']);

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
  String tapToSelectACountry(String countryName, String countryDialCode) {
    return 'Tap to select a country. Current selection: $countryName $countryDialCode';
  }

  @override
  String get enterPhoneNumber => 'Enter your phone number';
}
