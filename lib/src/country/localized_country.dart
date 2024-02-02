import 'package:flutter/material.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization_en.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/country/localize_country.dart';
import 'package:phone_numbers_parser/metadata.dart';

/// Country regroup informations for displaying a list of countries
class LocalizedCountry {
  /// Country alpha-2 iso code
  final IsoCode isoCode;

  /// localized name of the country
  final String name;

  /// country dialing code to call them internationally
  final String countryDialingCode;

  /// returns "+ [countryDialingCode]"
  String get formattedCountryDialingCode => '+ $countryDialingCode';

  factory LocalizedCountry.fromContext(BuildContext context, IsoCode isoCode) {
    final localization =
        PhoneFieldLocalization.of(context) ?? PhoneFieldLocalizationEn();
    return LocalizedCountry(isoCode, localization.countryName(isoCode));
  }

  LocalizedCountry(this.isoCode, this.name)
      : countryDialingCode = metadataByIsoCode[isoCode]?.countryCode ?? '';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalizedCountry &&
          runtimeType == other.runtimeType &&
          isoCode == other.isoCode;

  @override
  int get hashCode => isoCode.hashCode;

  @override
  String toString() {
    return 'Country{isoCode: $isoCode}';
  }
}
