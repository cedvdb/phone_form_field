import 'phone_field_localization.dart';

/// The translations for Russian (`ru`).
class PhoneFieldLocalizationRu extends PhoneFieldLocalization {
  PhoneFieldLocalizationRu([String locale = 'ru']) : super(locale);

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
}
