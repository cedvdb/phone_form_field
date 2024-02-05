import 'phone_field_localization_impl.dart';

/// The translations for Portuguese (`pt`).
class PhoneFieldLocalizationImplPt extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplPt([String locale = 'pt']) : super(locale);

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

  @override
  String tapToSelectACountry(String countryName, String countryDialCode) {
    return 'Tap to select a country. Current selection: $countryName $countryDialCode';
  }

  @override
  String get enterPhoneNumber => 'Enter your phone number';
}
