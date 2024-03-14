import 'phone_field_localization_impl.dart';

/// The translations for Russian (`ru`).
class PhoneFieldLocalizationImplRu extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplRu([super.locale = 'ru']);

  @override
  String get invalidPhoneNumber => 'Неправильный номер телефона';

  @override
  String get invalidCountry => 'Неверная страна';

  @override
  String get invalidMobilePhoneNumber => 'Неверный номер мобильного телефона';

  @override
  String get invalidFixedLinePhoneNumber =>
      'Недействительный номер стационарного телефона';

  @override
  String get requiredPhoneNumber => 'Требуется номер телефона';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Выберите страну. Текущий выбор: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Номер телефона';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Текущее значение: $currentValue';
  }
}
