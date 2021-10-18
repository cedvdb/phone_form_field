import 'package:dart_countries/dart_countries.dart';

/// Country regroup informations for displaying a list of countries
class Country {
  /// Country code (ISO 3166-1 alpha-2)
  final String isoCode;

  /// English name of the country
  String get name => countriesName[isoCode]!;

  /// country dialing code to call them internationally
  String get countryCode => countriesDialCode[isoCode]!;

  /// returns "+ [countryCode]"
  String get displayCountryCode => '+ $countryCode';

  Country(this.isoCode)
      : assert(isoCodes.contains(isoCode), 'isocode $isoCode not found');

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
