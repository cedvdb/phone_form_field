// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class PhoneFieldLocalizationImplCs extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplCs([String locale = 'cs']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Neplatné telefonní číslo';

  @override
  String get invalidCountry => 'Neplatná země';

  @override
  String get invalidMobilePhoneNumber => 'Neplatné číslo mobilního telefonu';

  @override
  String get invalidFixedLinePhoneNumber => 'Neplatné číslo pevné linky';

  @override
  String get requiredPhoneNumber => 'Telefonní číslo je povinné';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Vyberte zemi. Aktuální výběr: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Telefonní číslo';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Aktuální hodnota: $currentValue';
  }
}
