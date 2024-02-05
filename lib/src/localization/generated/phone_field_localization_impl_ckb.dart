import 'phone_field_localization_impl.dart';

/// The translations for Central Kurdish (`ckb`).
class PhoneFieldLocalizationImplCkb extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplCkb([String locale = 'ckb']) : super(locale);

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

  @override
  String tapToSelectACountry(String countryName, String countryDialCode) {
    return 'Tap to select a country. Current selection: $countryName $countryDialCode';
  }

  @override
  String get enterPhoneNumber => 'Enter your phone number';
}
