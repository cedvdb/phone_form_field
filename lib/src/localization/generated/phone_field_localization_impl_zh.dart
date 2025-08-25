// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class PhoneFieldLocalizationImplZh extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplZh([String locale = 'zh']) : super(locale);

  @override
  String get invalidPhoneNumber => '无效的电话号码';

  @override
  String get invalidCountry => '无效国家';

  @override
  String get invalidMobilePhoneNumber => '无效的手机号码';

  @override
  String get invalidFixedLinePhoneNumber => '无效的固定电话号码';

  @override
  String get requiredPhoneNumber => '需要电话号码';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return '选择国家/地区，当前选择：$countryName $dialCode';
  }

  @override
  String get phoneNumber => '电话号码';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return '当前值：$currentValue';
  }
}
