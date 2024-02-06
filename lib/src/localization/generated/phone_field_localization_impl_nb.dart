import 'phone_field_localization_impl.dart';

/// The translations for Norwegian Bokmål (`nb`).
class PhoneFieldLocalizationImplNb extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplNb([String locale = 'nb']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Ugyldig telefonnummer';

  @override
  String get invalidCountry => 'Ugyldig land';

  @override
  String get invalidMobilePhoneNumber => 'Ugyldig mobilnummer';

  @override
  String get invalidFixedLinePhoneNumber => 'Ugyldig fasttelefonnummer';

  @override
  String get requiredPhoneNumber => 'Telefonnummer er påkrevd';

  @override
  String selectACountry(String countryName) {
    return 'Select a country. Current selection: $countryName';
  }

  @override
  String get phoneNumber => 'Phone number';
}
