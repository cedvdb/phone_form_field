// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class PhoneFieldLocalizationImplIt extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplIt([String locale = 'it']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Numero di telefono invalido';

  @override
  String get invalidCountry => 'Paese invalido';

  @override
  String get invalidMobilePhoneNumber => 'Numero di cellulare invalido';

  @override
  String get invalidFixedLinePhoneNumber => 'Numero di rete fissa invalido';

  @override
  String get requiredPhoneNumber => 'Numero di telefono richiesto';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Seleziona un paese, selezione attuale: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Numero di telefono';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Valore corrente: $currentValue';
  }
}
