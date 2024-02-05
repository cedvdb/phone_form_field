import 'phone_field_localization.dart';

/// The translations for Uzbek (`uz`).
class PhoneFieldLocalizationUz extends PhoneFieldLocalization {
  PhoneFieldLocalizationUz([String locale = 'uz']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Telefon raqami noto‘g‘ri';

  @override
  String get invalidCountry => 'Yaroqsiz mamlakat';

  @override
  String get invalidMobilePhoneNumber => 'Telfon raqami noto‘g‘ri';

  @override
  String get invalidFixedLinePhoneNumber =>
      'Ruxsat etilgan telefon raqami yaroqsiz';

  @override
  String get requiredPhoneNumber => 'Telfon raqami majburiy';
}
