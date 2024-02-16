import 'phone_field_localization_impl.dart';

/// The translations for Ukrainian (`uk`).
class PhoneFieldLocalizationImplUk extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplUk([String locale = 'uk']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Невірний номер телефону';

  @override
  String get invalidCountry => 'Недійсна країна';

  @override
  String get invalidMobilePhoneNumber => 'Невірний номер мобільного телефону';

  @override
  String get invalidFixedLinePhoneNumber =>
      'Невірний номер стаціонарного телефону';

  @override
  String get requiredPhoneNumber => 'Необхідний номер телефону';

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
