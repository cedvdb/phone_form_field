// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class PhoneFieldLocalizationImplEl extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplEl([String locale = 'el']) : super(locale);

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
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Επιλέξτε χώρα, τρέχουσα επιλογή: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Τηλεφωνικό νούμερο';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Τρέχουσα τιμή: $currentValue';
  }
}
