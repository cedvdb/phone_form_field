// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class PhoneFieldLocalizationImplJa extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplJa([String locale = 'ja']) : super(locale);

  @override
  String get invalidPhoneNumber => '無効な電話番号です';

  @override
  String get invalidCountry => '無効な国です';

  @override
  String get invalidMobilePhoneNumber => '無効な携帯電話番号です';

  @override
  String get invalidFixedLinePhoneNumber => '無効な固定電話番号です';

  @override
  String get requiredPhoneNumber => '電話番号は必須です';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return '国を選択してください。現在の選択: $countryName $dialCode';
  }

  @override
  String get phoneNumber => '電話番号';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return '現在の値: $currentValue';
  }
}
