// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class PhoneFieldLocalizationImplRu extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplRu([String locale = 'ru']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Неправильный номер телефона';

  @override
  String get invalidCountry => 'Неверная страна';

  @override
  String get invalidMobilePhoneNumber => 'Неверный номер мобильного телефона';

  @override
  String get invalidFixedLinePhoneNumber =>
      'Недействительный номер стационарного телефона';

  @override
  String get requiredPhoneNumber => 'Требуется номер телефона';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Выберите страну. Текущий выбор: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Номер телефона';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Текущее значение: $currentValue';
  }
}
