import 'phone_field_localization.dart';

/// The translations for Dutch Flemish (`nl`).
class PhoneFieldLocalizationNl extends PhoneFieldLocalization {
  PhoneFieldLocalizationNl([String locale = 'nl']) : super(locale);

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
}
