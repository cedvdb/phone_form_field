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
