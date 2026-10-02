// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class PhoneFieldLocalizationImplRo extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplRo([String locale = 'ro']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Număr de telefon invalid';

  @override
  String get invalidCountry => 'Țară invalidă';

  @override
  String get invalidMobilePhoneNumber => 'Număr de telefon mobil invalid';

  @override
  String get invalidFixedLinePhoneNumber => 'Număr de telefon fix invalid';

  @override
  String get requiredPhoneNumber => 'Numărul de telefon este obligatoriu';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Selectați o țară. Selecția curentă: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Număr de telefon';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Valoare curentă: $currentValue';
  }
}
