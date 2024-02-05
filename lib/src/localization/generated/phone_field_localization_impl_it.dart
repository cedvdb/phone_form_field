import 'phone_field_localization_impl.dart';

/// The translations for Italian (`it`).
class PhoneFieldLocalizationImplIt extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplIt([super.locale = 'it']);

  @override
  String get invalidPhoneNumber => 'Numero di telefono invalido';

  @override
  String get invalidCountry => 'Paese invalido';

  @override
  String get invalidMobilePhoneNumber => 'Numero di cellulare invalido';

  @override
  String get invalidFixedLinePhoneNumber => 'Numero di rete fissa invalido';

  @override
  String get requiredPhoneNumber => 'Numero di telefono richiesto';

  @override
  String tapToSelectACountry(String countryName, String countryDialCode) {
    return 'Tap to select a country. Current selection: $countryName $countryDialCode';
  }

  @override
  String get enterPhoneNumber => 'Enter your phone number';
}
