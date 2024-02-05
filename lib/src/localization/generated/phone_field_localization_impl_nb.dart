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
  String tapToSelectACountry(String countryName, String countryDialCode) {
    return 'Tap to select a country. Current selection: $countryName $countryDialCode';
  }

  @override
  String get enterPhoneNumber => 'Enter your phone number';
}
