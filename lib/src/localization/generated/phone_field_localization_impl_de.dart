import 'phone_field_localization_impl.dart';

/// The translations for German (`de`).
class PhoneFieldLocalizationImplDe extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplDe([super.locale = 'de']);

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
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Select a country. Current selection: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Phone number';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Current value: $currentValue';
  }
}
