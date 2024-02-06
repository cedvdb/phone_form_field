import 'phone_field_localization_impl.dart';

/// The translations for German (`de`).
class PhoneFieldLocalizationImplDe extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplDe([String locale = 'de']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Ungültige Telefonnummer';

  @override
  String get invalidCountry => 'Ungültiges Land';

  @override
  String get invalidMobilePhoneNumber => 'Ungültige Handynummer';

  @override
  String get invalidFixedLinePhoneNumber => 'Ungültige Festnetznummer';

  @override
  String get requiredPhoneNumber => 'Telefonnummer erforderlich';

  @override
  String selectACountry(String countryName) {
    return 'Select a country. Current selection: $countryName';
  }

  @override
  String get phoneNumber => 'Phone number';
}
