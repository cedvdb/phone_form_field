import 'package:material_ui/material_ui.dart';

import 'generated/phone_field_localization_impl.dart';
import 'generated/phone_field_localization_impl_en.dart';

abstract class PhoneFieldLocalization {
  /// The [LocalizationsDelegate] that provides the phone field and country
  /// selector strings.
  ///
  /// Use it when you already provide the global `material_ui` delegates
  /// yourself and only need the strings of this package. Otherwise prefer
  /// [delegates].
  ///
  /// ```dart
  /// localizationsDelegates: [
  ///   ...myDelegates,
  ///   PhoneFieldLocalization.delegate,
  /// ],
  /// ```
  static const LocalizationsDelegate<PhoneFieldLocalizationImpl> delegate =
      PhoneFieldLocalizationImpl.delegate;

  /// The localizations delegates needed by the phone field and by the country
  /// selector.
  ///
  /// Prefer these over the generated
  /// `PhoneFieldLocalizationImpl.localizationsDelegates`: the widgets are built
  /// on `material_ui`, and only these carry the `material_ui`
  /// `MaterialLocalizations` they read.
  ///
  /// Spread them into your existing delegates rather than replacing them, so
  /// that the other localized packages of your application keep working:
  ///
  /// ```dart
  /// localizationsDelegates: const [
  ///   ...AppLocalizations.localizationsDelegates,
  ///   ...PhoneFieldLocalization.delegates,
  /// ],
  /// ```
  static const Set<LocalizationsDelegate> delegates = {
    ...GlobalMaterialLocalizations.delegates,
    delegate,
  };

  /// The locales supported by the phone field and the country selector.
  ///
  /// Countries that are not translated fall back to english.
  static const List<Locale> supportedLocales =
      PhoneFieldLocalizationImpl.supportedLocales;

  static PhoneFieldLocalizationImpl of(BuildContext context) {
    return PhoneFieldLocalizationImpl.of(context) ??
        PhoneFieldLocalizationImplEn();
  }
}
