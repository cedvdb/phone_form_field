import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class PhoneFieldLocalizationImplCa extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplCa([String locale = 'ca']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Número de telèfon no vàlid';

  @override
  String get invalidCountry => 'País no vàlid';

  @override
  String get invalidMobilePhoneNumber => 'Invalid mobile phone number';

  @override
  String get invalidFixedLinePhoneNumber => 'Número de telèfon mòbil no vàlid';

  @override
  String get requiredPhoneNumber => 'Número de telèfon obligatori';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Seleccioneu un país. Selecció actual: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Número de telèfon';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Valor actual: $currentValue';
  }
}
