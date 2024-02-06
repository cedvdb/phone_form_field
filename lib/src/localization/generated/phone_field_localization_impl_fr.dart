import 'phone_field_localization_impl.dart';

/// The translations for French (`fr`).
class PhoneFieldLocalizationImplFr extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplFr([String locale = 'fr']) : super(locale);

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
  String selectACountry(String countryName) {
    return 'Select a country. Current selection: $countryName';
  }

  @override
  String get phoneNumber => 'Phone number';
}
