import 'phone_field_localization.dart';

/// The translations for Hindi (`hi`).
class PhoneFieldLocalizationHi extends PhoneFieldLocalization {
  PhoneFieldLocalizationHi([String locale = 'hi']) : super(locale);

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
}
