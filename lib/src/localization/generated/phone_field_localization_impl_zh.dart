import 'phone_field_localization_impl.dart';

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
  String tapToSelectACountry(String countryName, String countryDialCode) {
    return 'Tap to select a country. Current selection: $countryName $countryDialCode';
  }

  @override
  String get enterPhoneNumber => 'Enter your phone number';
}
