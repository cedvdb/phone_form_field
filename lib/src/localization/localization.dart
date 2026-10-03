import 'package:material_ui/material_ui.dart';

import 'generated/phone_field_localization_impl.dart';
import 'generated/phone_field_localization_impl_en.dart';

abstract class PhoneFieldLocalization {
  /// The localizations delegates needed by the phone field and by the country
  /// selector.
  ///
  /// The material, cupertino and widgets delegates are the ones shipped by
  /// `material_ui` rather than the ones from `flutter_localizations`: both
  /// widgets are built on material_ui, whose [MaterialLocalizations.of] asserts
  /// that the localizations it finds are its own.
  static const Set<LocalizationsDelegate> delegates = {
    ...GlobalMaterialLocalizations.delegates,
    PhoneFieldLocalizationImpl.delegate,
  };

  static PhoneFieldLocalizationImpl of(BuildContext context) {
    return PhoneFieldLocalizationImpl.of(context) ??
        PhoneFieldLocalizationImplEn();
  }
}
