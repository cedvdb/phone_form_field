import 'package:dart_countries/dart_countries.dart';

/// Country regroup informations for displaying a list of countries
class Country {
  final String isoCode;

  /// English name of the country
  String get name => countriesName[isoCode]!;

  /// country dialing code to call them internationally
  String get dialCode => countriesDialCode[isoCode]!;

  /// returns "+ [dialCode]"
  String get displayDialCode => '+ $dialCode';

  Country(this.isoCode) : assert(isoCodes.contains(isoCode));
}
