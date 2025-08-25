// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class PhoneFieldLocalizationImplFa extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplFa([String locale = 'fa']) : super(locale);

  @override
  String get invalidPhoneNumber => 'شماره تلفن نامعتبر است';

  @override
  String get invalidCountry => 'کشور نامعتبر است';

  @override
  String get invalidMobilePhoneNumber => 'شماره تلفن همراه نامعتبر است';

  @override
  String get invalidFixedLinePhoneNumber => 'شماره تلفن ثابت نامعتبر است';

  @override
  String get requiredPhoneNumber => 'شماره تلفن الزامی است';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'یک کشور را انتخاب کن. ';
  }

  @override
  String get phoneNumber => 'شماره تلفن';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'مقدار فعلی: $currentValue';
  }
}
