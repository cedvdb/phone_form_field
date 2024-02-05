import 'phone_field_localization.dart';

/// The translations for Norwegian Bokmål (`nb`).
class PhoneFieldLocalizationNb extends PhoneFieldLocalization {
  PhoneFieldLocalizationNb([String locale = 'nb']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Ugyldig telefonnummer';

  @override
  String get invalidCountry => 'Ugyldig land';

  @override
  String get invalidMobilePhoneNumber => 'Ugyldig mobilnummer';

  @override
  String get invalidFixedLinePhoneNumber => 'Ugyldig fasttelefonnummer';

  @override
  String get requiredPhoneNumber => 'Telefonnummer er påkrevd';
}
