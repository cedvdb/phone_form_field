import 'phone_field_localization.dart';

/// The translations for Modern Greek (`el`).
class PhoneFieldLocalizationEl extends PhoneFieldLocalization {
  PhoneFieldLocalizationEl([String locale = 'el']) : super(locale);

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
}
