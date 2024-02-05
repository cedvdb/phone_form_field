import 'phone_field_localization.dart';

/// The translations for English (`en`).
class PhoneFieldLocalizationEn extends PhoneFieldLocalization {
  PhoneFieldLocalizationEn([String locale = 'en']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get invalidCountry => 'Invalid country';

  @override
  String get invalidMobilePhoneNumber => 'Invalid mobile phone number';

  @override
  String get invalidFixedLinePhoneNumber => 'Invalid fixed line phone number';

  @override
  String get requiredPhoneNumber => 'Required phone number';
}
