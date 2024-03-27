import 'phone_field_localization_impl.dart';

/// The translations for Kurdish (`ku`).
class PhoneFieldLocalizationImplKu extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplKu([super.locale = 'ku']);

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
    return 'Welatek hilbijêre, bijartina niha: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Jimare telefon';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Nirxa niha: $currentValue';
  }
}
