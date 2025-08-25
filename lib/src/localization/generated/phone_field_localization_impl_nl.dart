// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class PhoneFieldLocalizationImplNl extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplNl([String locale = 'nl']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Ongeldig telefoonnummer';

  @override
  String get invalidCountry => 'Ongeldig land';

  @override
  String get invalidMobilePhoneNumber => 'Ongeldig mobiel nummer';

  @override
  String get invalidFixedLinePhoneNumber => 'Ongeldig vast nummer';

  @override
  String get requiredPhoneNumber => 'Telefoonnummer vereist';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Selecteer een land, huidige selectie: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Telefoonnummer';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Huidige waarde: $currentValue';
  }
}
