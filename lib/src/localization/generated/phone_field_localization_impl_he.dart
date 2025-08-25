// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class PhoneFieldLocalizationImplHe extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplHe([String locale = 'he']) : super(locale);

  @override
  String get invalidPhoneNumber => 'מספר טלפון לא חוקי';

  @override
  String get invalidCountry => 'מדינה לא חוקית';

  @override
  String get invalidMobilePhoneNumber => 'מספר טלפון נייד לא חוקי';

  @override
  String get invalidFixedLinePhoneNumber => 'מספר טלפון קווי לא חוקי';

  @override
  String get requiredPhoneNumber => 'מספר טלפון נדרש';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'בחר מדינה. הבחירה הנוכחית: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'מספר טלפון';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'הערך הנוכחי: $currentValue';
  }
}
