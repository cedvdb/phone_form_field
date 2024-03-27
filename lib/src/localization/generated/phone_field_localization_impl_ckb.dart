import 'phone_field_localization_impl.dart';

/// The translations for Central Kurdish (`ckb`).
class PhoneFieldLocalizationImplCkb extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplCkb([super.locale = 'ckb']);

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
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'وڵاتێک هەڵبژێرە، هەڵبژاردنی ئێستا: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'ژمارەی تەلەفۆن';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'بەهای ئێستا: $currentValue';
  }
}
