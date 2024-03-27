import 'phone_field_localization_impl.dart';

/// The translations for French (`fr`).
class PhoneFieldLocalizationImplFr extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplFr([super.locale = 'fr']);

  @override
  String get invalidPhoneNumber => 'Numéro de téléphone invalide';

  @override
  String get invalidCountry => 'Pays invalide';

  @override
  String get invalidMobilePhoneNumber =>
      'Numéro de téléphone portable invalide';

  @override
  String get invalidFixedLinePhoneNumber => 'Numéro de téléphone fixe invalide';

  @override
  String get requiredPhoneNumber => 'Numéro de téléphone requis';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Sélectionnez un pays, sélection actuelle : $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Valeur actuelle : $currentValue';
  }
}
