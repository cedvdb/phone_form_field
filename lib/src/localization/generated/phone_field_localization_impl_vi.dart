// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class PhoneFieldLocalizationImplVi extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplVi([String locale = 'vi']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Số điện thoại không đúng';

  @override
  String get invalidCountry => 'Quốc gia không hợp lệ';

  @override
  String get invalidMobilePhoneNumber => 'Số điện thoại di động không đúng';

  @override
  String get invalidFixedLinePhoneNumber => 'Số điện thoại cố định không đúng';

  @override
  String get requiredPhoneNumber => 'Số điện không để để trống';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Chọn quốc gia. Hiện tại: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Số điện thoại';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Giá trị hiện tại: $currentValue';
  }
}
