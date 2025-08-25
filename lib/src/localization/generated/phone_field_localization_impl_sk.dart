// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class PhoneFieldLocalizationImplSk extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplSk([String locale = 'sk']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Neplatné telefónne číslo';

  @override
  String get invalidCountry => 'Neplatná krajina';

  @override
  String get invalidMobilePhoneNumber => 'Neplatné číslo mobilného telefónu';

  @override
  String get invalidFixedLinePhoneNumber => 'Neplatné číslo pevnej linky';

  @override
  String get requiredPhoneNumber => 'Telefónne číslo je povinné';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Vyberte krajinu. Aktuálny výber: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Telefónne číslo';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Aktuálna hodnota: $currentValue';
  }
}
