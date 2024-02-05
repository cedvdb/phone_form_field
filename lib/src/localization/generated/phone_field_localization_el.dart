import 'phone_field_localization.dart';

/// The translations for Modern Greek (`el`).
class PhoneFieldLocalizationEl extends PhoneFieldLocalization {
  PhoneFieldLocalizationEl([super.locale = 'el']);

  @override
  String get invalidPhoneNumber => 'Μη έγκυρος αριθμός τηλεφώνου';

  @override
  String get invalidCountry => 'Μη έγκυρη χώρα';

  @override
  String get invalidMobilePhoneNumber => 'Μη έγκυρος αριθμός κινητού τηλεφώνου';

  @override
  String get invalidFixedLinePhoneNumber =>
      'Μη έγκυρος αριθμός σταθερού τηλεφώνου';

  @override
  String get requiredPhoneNumber => 'Απαιτούμενος αριθμός τηλεφώνου';

  @override
  String tapToSelectACountry(String countryName, String countryDialCode) {
    return 'Tap to select a country. Current selection: $countryName $countryDialCode';
  }

  @override
  String get enterPhoneNumber => 'Enter your phone number';
}
