// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class PhoneFieldLocalizationImplUz extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplUz([String locale = 'uz']) : super(locale);

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

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Mamlakatni tanlang, joriy tanlov: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Telefon raqami';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Joriy qiymat: $currentValue';
  }
}
