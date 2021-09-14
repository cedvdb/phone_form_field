import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/widgets.dart';

import '../../phone_form_field.dart';

/// Country regroup informations for displaying a list of countries
class Country {
  /// Country code (ISO 3166-1 alpha-2)
  final String isoCode;

  /// English name of the country
  String get name => countriesName[isoCode]!;

  /// Localised name depending on the current application locale
  /// If you have many LocalisedName to handle in a same context, consider
  /// supplying the second optional PhoneFieldLocalization to avoid
  /// walking up the widget to get [PhoneFieldLocalization] instance
  /// for each call.
  String localisedName(
    BuildContext context, [
    PhoneFieldLocalization? localization,
  ]) {
    localization ??= PhoneFieldLocalization.of(context);
    String? LocalisedName = localization?.translate(isoCode);
    return LocalisedName == null || LocalisedName == isoCode
        ? name
        : LocalisedName;
  }

  /// country dialing code to call them internationally
  String get dialCode => countriesDialCode[isoCode]!;

  /// returns "+ [dialCode]"
  String get displayDialCode => '+ $dialCode';

  Country(this.isoCode) : assert(isoCodes.contains(isoCode));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          isoCode == other.isoCode;

  @override
  int get hashCode => isoCode.hashCode;

  @override
  String toString() {
    return 'Country{isoCode: $isoCode}';
  }
}
