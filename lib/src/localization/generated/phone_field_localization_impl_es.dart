import 'phone_field_localization_impl.dart';

/// The translations for Spanish Castilian (`es`).
class PhoneFieldLocalizationImplEs extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplEs([super.locale = 'es']);

  @override
  String get invalidPhoneNumber => 'Numero de telefono invalido';

  @override
  String get invalidCountry => 'País invalido';

  @override
  String get invalidMobilePhoneNumber => 'Número de teléfono celular invalido';

  @override
  String get invalidFixedLinePhoneNumber => 'Número de teléfono fijo invalido';

  @override
  String get requiredPhoneNumber => 'Número de teléfono obligatorio';

  @override
  String tapToSelectACountry(String countryName, String countryDialCode) {
    return 'Tap to select a country. Current selection: $countryName $countryDialCode';
  }

  @override
  String get enterPhoneNumber => 'Enter your phone number';
}
