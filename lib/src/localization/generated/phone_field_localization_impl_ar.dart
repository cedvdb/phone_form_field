import 'phone_field_localization_impl.dart';

/// The translations for Arabic (`ar`).
class PhoneFieldLocalizationImplAr extends PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImplAr([String locale = 'ar']) : super(locale);

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
  String tapToSelectACountry(String countryName, String countryDialCode) {
    return 'Tap to select a country. Current selection: $countryName $countryDialCode';
  }

  @override
  String get enterPhoneNumber => 'Enter your phone number';
}
