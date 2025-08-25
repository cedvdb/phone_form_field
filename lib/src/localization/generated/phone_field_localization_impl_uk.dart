// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class PhoneFieldLocalizationImplUk extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplUk([String locale = 'uk']) : super(locale);

  @override
  String get invalidPhoneNumber => 'Невірний номер телефону';

  @override
  String get invalidCountry => 'Недійсна країна';

  @override
  String get invalidMobilePhoneNumber => 'Невірний номер мобільного телефону';

  @override
  String get invalidFixedLinePhoneNumber =>
      'Невірний номер стаціонарного телефону';

  @override
  String get requiredPhoneNumber => 'Необхідний номер телефону';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Виберіть країну, поточний вибір: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Номер телефону';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Поточне значення: $currentValue';
  }
}
