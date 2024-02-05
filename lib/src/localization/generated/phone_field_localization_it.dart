import 'phone_field_localization.dart';

/// The translations for Italian (`it`).
class PhoneFieldLocalizationIt extends PhoneFieldLocalization {
  PhoneFieldLocalizationIt([String locale = 'it']) : super(locale);

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
