import 'phone_field_localization_impl.dart';

/// The translations for Arabic (`ar`).
class PhoneFieldLocalizationImplAr extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplAr([super.locale = 'ar']);

  @override
  String get invalidPhoneNumber => 'رقم الهاتف غير صحيح';

  @override
  String get invalidCountry => 'دولة غير صحيح';

  @override
  String get invalidMobilePhoneNumber => 'رقم الهاتف الخلوي غير صحيح';

  @override
  String get invalidFixedLinePhoneNumber => 'رقم الهاتف الثابت غير صحيح';

  @override
  String get requiredPhoneNumber => 'رقم الهاتف مطلوب';

  @override
  String selectACountrySemanticLabel(String countryName, String dialCode) {
    return 'Select a country. Current selection: $countryName $dialCode';
  }

  @override
  String get phoneNumber => 'Phone number';

  @override
  String currentValueSemanticLabel(String currentValue) {
    return 'Current value: $currentValue';
  }
}
