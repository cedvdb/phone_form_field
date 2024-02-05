import 'phone_field_localization.dart';

/// The translations for Persian (`fa`).
class PhoneFieldLocalizationFa extends PhoneFieldLocalization {
  PhoneFieldLocalizationFa([String locale = 'fa']) : super(locale);

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
}
