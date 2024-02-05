import 'phone_field_localization.dart';

/// The translations for Turkish (`tr`).
class PhoneFieldLocalizationTr extends PhoneFieldLocalization {
  PhoneFieldLocalizationTr([String locale = 'tr']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Geçersiz telefon numarası';

  @override
  String get invalidCountry => 'Geçersiz ülke';

  @override
  String get invalidMobilePhoneNumber => 'Geçersiz cep telefonu numarası';

  @override
  String get invalidFixedLinePhoneNumber =>
      'Geçersiz sabit hat telefon numarası';

  @override
  String get requiredPhoneNumber => 'Telefon numarası gerekli';
}
