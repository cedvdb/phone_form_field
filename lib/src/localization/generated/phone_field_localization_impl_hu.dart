import 'phone_field_localization_impl.dart';

/// The translations for Hungarian (`hu`).
class PhoneFieldLocalizationImplHu extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplHu([super.locale = 'hu']);

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
