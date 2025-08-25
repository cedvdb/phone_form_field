// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class PhoneFieldLocalizationImplEs extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplEs([String locale = 'es']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Numero de telefono invalido';

  @override
  String get invalidCountry => 'País invalido';

  @override
  String get invalidMobilePhoneNumber => 'Número de teléfono celular invalido';

  @override
  String get invalidFixedLinePhoneNumber => 'Número de teléfono fijo invalido';

  @override
  String get requiredPhoneNumber => 'Número de teléfono obligatorio';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Seleccione un país, selección actual: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Valor actual: $currentValue';
  }
}
