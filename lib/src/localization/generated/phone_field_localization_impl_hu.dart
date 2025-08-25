// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class PhoneFieldLocalizationImplHu extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplHu([String locale = 'hu']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Érvénytelen telefonszám';

  @override
  String get invalidCountry => 'Érvénytelen ország';

  @override
  String get invalidMobilePhoneNumber => 'Érvénytelen mobiltelefonszám';

  @override
  String get invalidFixedLinePhoneNumber => 'Érvénytelen vezetékes telefonszám';

  @override
  String get requiredPhoneNumber => 'Szükséges telefonszám';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Válasszon országot, jelenlegi választás: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Telefonszám';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Jelenlegi érték: $currentValue';
  }
}
