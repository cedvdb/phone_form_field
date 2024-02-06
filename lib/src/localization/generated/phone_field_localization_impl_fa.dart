import 'phone_field_localization_impl.dart';

/// The translations for Persian (`fa`).
class PhoneFieldLocalizationImplFa extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplFa([super.locale = 'fa']);

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
  String selectACountry(String countryName) {
    return 'Select a country. Current selection: $countryName';
  }

  @override
  String get phoneNumber => 'Phone number';
}
