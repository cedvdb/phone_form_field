import 'phone_field_localization.dart';

/// The translations for Swedish (`sv`).
class PhoneFieldLocalizationSv extends PhoneFieldLocalization {
  PhoneFieldLocalizationSv([String locale = 'sv']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Ogiltigt telefonnummer';

  @override
  String get invalidCountry => 'Ogiltigt land';

  @override
  String get invalidMobilePhoneNumber => 'Ogiltigt mobilnummer';

  @override
  String get invalidFixedLinePhoneNumber => 'Ogiltigt fast telefonnummer';

  @override
  String get requiredPhoneNumber => 'Obligatoriskt telefonnummer';
}
