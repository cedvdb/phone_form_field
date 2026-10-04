import 'package:material_ui/material_ui.dart';

import 'generated/phone_field_localization_impl.dart';
import 'generated/phone_field_localization_impl_en.dart';

abstract class PhoneFieldLocalization {
  /// The localizations delegates needed by the phone field and by the country
  /// selector.
  ///
  /// Prefer these over the generated
  /// `PhoneFieldLocalizationImpl.localizationsDelegates`: the widgets are built
  /// on `material_ui`, and only these carry the `material_ui`
  /// `MaterialLocalizations` they read.
  static const Set<LocalizationsDelegate> delegates = {
    ...GlobalMaterialLocalizations.delegates,
    PhoneFieldLocalizationImpl.delegate,
  };

  static PhoneFieldLocalizationImpl of(BuildContext context) {
    return PhoneFieldLocalizationImpl.of(context) ??
        PhoneFieldLocalizationImplEn();
  }
}
