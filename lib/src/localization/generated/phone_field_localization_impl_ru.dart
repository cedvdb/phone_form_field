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
  String selectACountry(String countryName) {
    return 'Select a country. Current selection: $countryName';
  }

  @override
  String get phoneNumber => 'Phone number';
}
