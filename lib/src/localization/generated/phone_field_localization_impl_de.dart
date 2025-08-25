// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class PhoneFieldLocalizationImplDe extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplDe([String locale = 'de']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Ungültige Telefonnummer';

  @override
  String get invalidCountry => 'Ungültiges Land';

  @override
  String get invalidMobilePhoneNumber => 'Ungültige Handynummer';

  @override
  String get invalidFixedLinePhoneNumber => 'Ungültige Festnetznummer';

  @override
  String get requiredPhoneNumber => 'Telefonnummer erforderlich';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Wählen Sie ein Land aus, aktuelle Auswahl: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Aktueller Wert: $currentValue';
  }
}
