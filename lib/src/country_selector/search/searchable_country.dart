import 'package:diacritic/diacritic.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

/// [SearchableCountry] regroups informations for searching
/// a country by some of its properties. It is not meant
/// to be exported outside this pacakge, as we would like people
/// to use CountrySelectorLocalization.of(context).countryName()
/// to find the country name instead, which would prevent country.name
/// to be out of sync if the search happened before a language change.
class SearchableCountry {
  /// Country alpha-2 iso code
  final IsoCode isoCode;

  /// localized name of the country
  final String name;

  /// lower case name with diacritics removed
  final String searchableName;

  /// country dialing code to call them internationally
  final String dialCode;

  /// returns "+ [dialCode]"
  String get formattedCountryDialingCode => '+ $dialCode';

  SearchableCountry(this.isoCode, this.dialCode, this.name)
      : searchableName = removeDiacritics(name.toLowerCase());

  @override
  String toString() {
    return '$runtimeType(isoCode: $isoCode, dialCode: $dialCode, name: $name)';
  }
}
