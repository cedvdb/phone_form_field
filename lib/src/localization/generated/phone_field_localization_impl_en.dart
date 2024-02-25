import 'phone_field_localization_impl.dart';

/// The translations for English (`en`).
class PhoneFieldLocalizationImplEn extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplEn([super.locale = 'en']);

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
