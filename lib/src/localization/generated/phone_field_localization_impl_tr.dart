// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class PhoneFieldLocalizationImplTr extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplTr([String locale = 'tr']) : super(locale);

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
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Bir ülke seçin, mevcut seçim: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Telefon numarası';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Mevcut değer: $currentValue';
  }
}
