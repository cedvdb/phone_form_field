import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization_en.dart';
import 'package:phone_form_field/src/country_selection/localized_country_registry.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'country_finder.dart';
import '../country/localized_country.dart';
import 'country_list_view.dart';

class CountrySelectorSearchDelegate extends SearchDelegate<LocalizedCountry> {
  late CountryFinder _countryFinder;
  late CountryFinder _favoriteCountryFinder;

  /// List of countries to display in the selector
  /// Value optional in constructor.
  /// when omitted, the full country list is displayed
  final List<IsoCode> countriesIso;

  /// Callback triggered when user select a country
  final ValueChanged<LocalizedCountry> onCountrySelected;

  /// ListView.builder scroll controller (ie: [ScrollView.controller])
  final ScrollController? scrollController;

  /// The [ScrollPhysics] of the Country List
  final ScrollPhysics? scrollPhysics;

  /// Determine the countries to be displayed on top of the list
  /// Check [addFavoritesSeparator] property to enable/disable adding a
  /// list divider between favorites and others defaults countries
  final List<IsoCode> favoriteCountriesIso;

  /// Whether to add a list divider between favorites & defaults
  /// countries.
  final bool addFavoritesSeparator;

  /// Whether to show the country country code (ie: +1 / +33 /...)
  /// as a listTile subtitle
  final bool showCountryCode;

  /// The message displayed instead of the list when the search has no results
  final String? noResultMessage;

  /// whether the search input is auto focussed
  final bool searchAutofocus;
  final double flagSize;

  /// Override default title TextStyle
  final TextStyle? titleStyle;

  /// Override default subtitle TextStyle
  final TextStyle? subtitleStyle;

  final FlagCache? flagCache;

  /// Override default app bar theme
  final ThemeData? customAppBarTheme;

  CountrySelectorSearchDelegate({
    Key? key,
    required this.onCountrySelected,
    required this.flagCache,
    this.scrollController,
    this.scrollPhysics,
    this.addFavoritesSeparator = true,
    this.showCountryCode = false,
    this.noResultMessage,
    List<IsoCode> favoriteCountries = const [],
    List<IsoCode> countries = IsoCode.values,
    this.searchAutofocus = kIsWeb,
    this.flagSize = 40,
    this.titleStyle,
    this.subtitleStyle,
    this.customAppBarTheme,
  })  : countriesIso = countries,
        favoriteCountriesIso = favoriteCountries;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  void _initIfRequired(BuildContext context) {
    final localization =
        PhoneFieldLocalization.of(context) ?? PhoneFieldLocalizationEn();

    final notFavoriteCountries = countryRegistry.whereIsoIn(
      countriesIso,
      omit: favoriteCountriesIso,
    );
    final favoriteCountries = countryRegistry.whereIsoIn(favoriteCountriesIso);
    _countryFinder = CountryFinder(notFavoriteCountries);
    _favoriteCountryFinder = CountryFinder(favoriteCountries, sort: false);
  }

  void _updateList() {
    _countryFinder.whereText(text: query, countries: );
    _favoriteCountryFinder.whereText(query);
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return BackButton(
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _initIfRequired(context);
    _updateList();

    return CountryListView(
      favorites: _favoriteCountryFinder.filteredCountries,
      countries: _countryFinder.filteredCountries,
      showDialCode: showCountryCode,
      onTap: onCountrySelected,
      flagSize: flagSize,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      noResultMessage: noResultMessage,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      flagCache: flagCache,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return customAppBarTheme ?? super.appBarTheme(context);
  }
}
