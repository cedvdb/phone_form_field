import 'phone_field_localization.dart';

/// The translations for Spanish Castilian (`es`).
class PhoneFieldLocalizationEs extends PhoneFieldLocalization {
  PhoneFieldLocalizationEs([String locale = 'es']) : super(locale);

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
}
