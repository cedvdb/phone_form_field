import 'phone_field_localization_impl.dart';

/// The translations for Italian (`ko`).
class PhoneFieldLocalizationImplKo extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplKo([super.locale = 'ko']);

  @override
  String get invalidPhoneNumber => '올바른 번호가 아닙니다.';

  @override
  String get invalidCountry => '올바른 국가가 아닙니다.';

  @override
  String get invalidMobilePhoneNumber => '올바른 핸드폰 번호가 아닙니다.';

  @override
  String get invalidFixedLinePhoneNumber => '올바른 전화 번호가 아닙니다.';

  @override
  String get requiredPhoneNumber => '전화번호를 입력해 주세요';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return '국가를 선택해주세요. 현재 국가는: $countryName $dialCode';
  }

  @override
  String get phoneNumber => '핸드폰 번호';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return '현재 값: $currentValue';
  }
}
