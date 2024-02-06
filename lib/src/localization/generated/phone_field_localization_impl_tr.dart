import 'phone_field_localization_impl.dart';

/// The translations for Turkish (`tr`).
class PhoneFieldLocalizationImplTr extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplTr([super.locale = 'tr']);

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

  @override
  String selectACountry(String countryName) {
    return 'Select a country. Current selection: $countryName';
  }

  @override
  String get phoneNumber => 'Phone number';
}
