// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'phone_field_localization_impl.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class PhoneFieldLocalizationImplTh extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplTh([String locale = 'th']) : super(locale);

  @override
  String get invalidPhoneNumber => 'หมายเลขโทรศัพท์ไม่ถูกต้อง';

  @override
  String get invalidCountry => 'ประเทศไม่ถูกต้อง';

  @override
  String get invalidMobilePhoneNumber => 'หมายเลขโทรศัพท์มือถือไม่ถูกต้อง';

  @override
  String get invalidFixedLinePhoneNumber => 'หมายเลขโทรศัพท์พื้นฐานไม่ถูกต้อง';

  @override
  String get requiredPhoneNumber => 'จำเป็นต้องระบุหมายเลขโทรศัพท์';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'เลือกประเทศ การเลือกปัจจุบัน: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'หมายเลขโทรศัพท์';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'ค่าปัจจุบัน: $currentValue';
  }
}
