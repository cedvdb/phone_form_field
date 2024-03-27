import 'phone_field_localization_impl.dart';

/// The translations for Kurdish (`ku`).
class PhoneFieldLocalizationImplKu extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplKu([super.locale = 'ku']);

  @override
  String get invalidPhoneNumber => 'Hejmara têlefonê nederbasdar e';

  @override
  String get invalidCountry => 'Welatê nederbasdar';

  @override
  String get invalidMobilePhoneNumber => 'Hejmara têlefona desta nederbasdar e';

  @override
  String get invalidFixedLinePhoneNumber =>
      'Hejmara têlefonê ya xeta sabît nederbasdar e';

  @override
  String get requiredPhoneNumber => 'Hejmara têlefonê ya pêwîst';

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
