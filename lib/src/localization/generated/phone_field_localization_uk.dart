import 'phone_field_localization.dart';

/// The translations for Ukrainian (`uk`).
class PhoneFieldLocalizationUk extends PhoneFieldLocalization {
  PhoneFieldLocalizationUk([String locale = 'uk']) : super(locale);

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
}
