import 'package:material_ui/material_ui.dart';
import 'package:phone_form_field/src/country_selector/localization/localization.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'search/country_finder.dart';
import 'search/searchable_country.dart';

class CountrySelectorController with ChangeNotifier {
  final _finder = CountryFinder();
  List<SearchableCountry> _countries = [];
  List<SearchableCountry> _filteredCountries = [];
  List<SearchableCountry> _favoriteCountries = [];
  List<SearchableCountry> _filteredFavoriteCountries = [];

  List<SearchableCountry> get filteredCountries => _filteredCountries;
  List<SearchableCountry> get filteredFavorites => _filteredFavoriteCountries;

  CountrySelectorController(
    BuildContext context,
    List<IsoCode> countriesIsoCode,
    List<IsoCode> favoriteCountriesIsoCode,
  ) {
    _countries = _buildLocalizedCountryList(context, countriesIsoCode);
    _favoriteCountries =
        _buildLocalizedCountryList(context, favoriteCountriesIsoCode);
    _filteredCountries = _countries;
  }

  void search(String searchedText) {
    _filteredCountries = _finder.whereText(
      text: searchedText,
      countries: _countries,
    );
    // when there is a search, no need for favorites
    if (searchedText.isEmpty) {
      _filteredFavoriteCountries = _favoriteCountries;
    } else {
      _filteredFavoriteCountries = [];
    }
    notifyListeners();
  }

  SearchableCountry? findFirst() {
    return _filteredFavoriteCountries.firstOrNull ??
        _filteredCountries.firstOrNull;
  }

  List<SearchableCountry> _buildLocalizedCountryList(
    BuildContext context,
    List<IsoCode> isoCodes,
  ) {
    // we need the localized names in order to search
    final localization = CountrySelectorLocalization.of(context) ??
        CountrySelectorLocalizationEn();
    return isoCodes
        .map(
          (isoCode) => SearchableCountry(
            isoCode,
            localization.countryDialCode(isoCode),
            localization.countryName(isoCode),
          ),
        )
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }
}
