import 'phone_field_localization.dart';

/// The translations for Portuguese (`pt`).
class PhoneFieldLocalizationPt extends PhoneFieldLocalization {
  PhoneFieldLocalizationPt([String locale = 'pt']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Número de telefone inválido';

  @override
  String get invalidCountry => 'País inválido';

  @override
  String get invalidMobilePhoneNumber => 'Número de telefone celular inválido';

  @override
  String get invalidFixedLinePhoneNumber => 'Número de telefone fixo inválido';

  @override
  String get requiredPhoneNumber => 'Número de telefone obrigatório';
}
