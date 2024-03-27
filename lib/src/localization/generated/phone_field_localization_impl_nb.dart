import 'phone_field_localization_impl.dart';

/// The translations for Norwegian Bokmål (`nb`).
class PhoneFieldLocalizationImplNb extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplNb([super.locale = 'nb']);

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
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Velg et land, gjeldende valg: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Gjeldende verdi: $currentValue';
  }
}
