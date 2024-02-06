import 'phone_field_localization_impl.dart';

/// The translations for Italian (`it`).
class PhoneFieldLocalizationImplIt extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplIt([String locale = 'it']) : super(locale);

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
  String selectACountry(String countryName) {
    return 'Select a country. Current selection: $countryName';
  }

  @override
  String get phoneNumber => 'Phone number';
}
