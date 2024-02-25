import 'phone_field_localization_impl.dart';

/// The translations for Portuguese (`pt`).
class PhoneFieldLocalizationImplPt extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplPt([super.locale = 'pt']);

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
