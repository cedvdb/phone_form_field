import 'phone_field_localization_impl.dart';

/// The translations for Hindi (`hi`).
class PhoneFieldLocalizationImplHi extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplHi([super.locale = 'hi']);

  @override
  String get invalidPhoneNumber => 'अवैध फोन नंबर';

  @override
  String get invalidCountry => 'अवैध देश';

  @override
  String get invalidMobilePhoneNumber => 'अमान्य सेल फ़ोन नंबर';

  @override
  String get invalidFixedLinePhoneNumber => 'अवैध लैंडलाइन नंबर';

  @override
  String get requiredPhoneNumber => 'फ़ोन नंबर आवश्यक';

  @override
  String selectACountry(String countryName) {
    return 'Select a country. Current selection: $countryName';
  }

  @override
  String get phoneNumber => 'Phone number';
}
