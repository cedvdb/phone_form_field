import 'phone_field_localization.dart';

/// The translations for Kurdish (`ku`).
class PhoneFieldLocalizationKu extends PhoneFieldLocalization {
  PhoneFieldLocalizationKu([String locale = 'ku']) : super(locale);

  @override
  String get invalidPhoneNumber => 'ژمارەی تەلەفۆنی نادروست';

  @override
  String get invalidCountry => 'وڵاتێکی نادروست';

  @override
  String get invalidMobilePhoneNumber => 'ژمارەی مۆبایل نادروستە';

  @override
  String get invalidFixedLinePhoneNumber =>
      'ژمارەی تەلەفۆنی هێڵی جێگیر نادروستە';

  @override
  String get requiredPhoneNumber => 'ژمارەی تەلەفۆنی پێویست';
}
