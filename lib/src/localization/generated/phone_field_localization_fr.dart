import 'phone_field_localization.dart';

/// The translations for French (`fr`).
class PhoneFieldLocalizationFr extends PhoneFieldLocalization {
  PhoneFieldLocalizationFr([String locale = 'fr']) : super(locale);

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
}
