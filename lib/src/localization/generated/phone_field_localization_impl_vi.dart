import 'phone_field_localization_impl.dart';

/// The translations for Vietnamese (`vi`).
class PhoneFieldLocalizationImplVi extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplVi([super.locale = 'vi']);

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
