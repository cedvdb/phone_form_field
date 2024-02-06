import 'phone_field_localization_impl.dart';

/// The translations for Spanish Castilian (`es`).
class PhoneFieldLocalizationImplEs extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplEs([String locale = 'es']) : super(locale);

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
  String selectACountry(String countryName) {
    return 'Select a country. Current selection: $countryName';
  }

  @override
  String get phoneNumber => 'Phone number';
}
