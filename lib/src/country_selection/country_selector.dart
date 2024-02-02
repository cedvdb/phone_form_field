import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization_en.dart';
import 'package:phone_form_field/src/country/localize_country.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../country/localized_country.dart';
import 'country_finder.dart';
import 'country_list_view.dart';
import 'search_box.dart';

class CountrySelector extends StatefulWidget {
  /// List of countries to display in the selector
  /// Value optional in constructor.
  /// when omitted, the full country list is displayed
  final List<IsoCode> countries;

  /// Determine the countries to be displayed on top of the list
  /// Check [addFavoritesSeparator] property to enable/disable adding a
  /// list divider between favorites and others defaults countries
  final List<IsoCode> favoriteCountries;

  /// Callback triggered when user select a country
  final ValueChanged<LocalizedCountry> onCountrySelected;

  /// ListView.builder scroll controller (ie: [ScrollView.controller])
  final ScrollController? scrollController;

  /// The [ScrollPhysics] of the Country List
  final ScrollPhysics? scrollPhysics;

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

  /// The [TextStyle] of the country subtitle
  final TextStyle? subtitleStyle;

  /// The [TextStyle] of the country title
  final TextStyle? titleStyle;

  /// The [InputDecoration] of the Search Box
  final InputDecoration? searchBoxDecoration;

  /// The [TextStyle] of the Search Box
  final TextStyle? searchBoxTextStyle;

  /// The [Color] of the Search Icon in the Search Box
  final Color? searchBoxIconColor;
  final double flagSize;
  final FlagCache flagCache;

  const CountrySelector({
    super.key,
    required this.onCountrySelected,
    required this.flagCache,
    this.scrollController,
    this.scrollPhysics,
    this.addFavoritesSeparator = true,
    this.showCountryCode = false,
    this.noResultMessage,
    this.favoriteCountries = const [],
    this.countries = IsoCode.values,
    this.searchAutofocus = kIsWeb,
    this.subtitleStyle,
    this.titleStyle,
    this.searchBoxDecoration,
    this.searchBoxTextStyle,
    this.searchBoxIconColor,
    this.flagSize = 40,
  });

  @override
  CountrySelectorState createState() => CountrySelectorState();
}

class CountrySelectorState extends State<CountrySelector> {
  final countryFinder = CountryFinder();
  List<LocalizedCountry> _localizedCountries = [];
  List<LocalizedCountry> _filteredLocalizedCountries = [];
  List<LocalizedCountry> _favoriteLocalizedCountries = [];
  List<LocalizedCountry> _filteredFavoriteLocalizedCountries = [];

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _localizedCountries = _buildLocalizedCountryList(context, widget.countries);
    _favoriteLocalizedCountries =
        _buildLocalizedCountryList(context, widget.favoriteCountries);
    _filteredLocalizedCountries = _localizedCountries;
  }

  _buildLocalizedCountryList(BuildContext context, List<IsoCode> isoCodes) {
    final localization =
        PhoneFieldLocalization.of(context) ?? PhoneFieldLocalizationEn();
    return isoCodes
        .map((isoCode) =>
            LocalizedCountry(isoCode, localization.countryName(isoCode)))
        .toList();
  }

  _onSearch(String searchedText) {
    _filteredLocalizedCountries = countryFinder.whereText(
      text: searchedText,
      countries: _localizedCountries,
    );
    _filteredFavoriteLocalizedCountries = countryFinder.whereText(
      text: searchedText,
      countries: _favoriteLocalizedCountries,
    );
    setState(() {});
  }

  onSubmitted() {
    if (_filteredFavoriteLocalizedCountries.isNotEmpty) {
      widget.onCountrySelected(_filteredFavoriteLocalizedCountries.first);
    } else if (_filteredLocalizedCountries.isNotEmpty) {
      widget.onCountrySelected(_filteredLocalizedCountries.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(
          height: 70,
          width: double.infinity,
          child: SearchBox(
            autofocus: widget.searchAutofocus,
            onChanged: _onSearch,
            onSubmitted: onSubmitted,
            decoration: widget.searchBoxDecoration,
            style: widget.searchBoxTextStyle,
            searchIconColor: widget.searchBoxIconColor,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 0, thickness: 1.2),
        Flexible(
          child: CountryListView(
            favorites: _filteredFavoriteLocalizedCountries,
            countries: _filteredLocalizedCountries,
            showDialCode: widget.showCountryCode,
            onTap: widget.onCountrySelected,
            flagSize: widget.flagSize,
            scrollController: widget.scrollController,
            scrollPhysics: widget.scrollPhysics,
            noResultMessage: widget.noResultMessage,
            titleStyle: widget.titleStyle,
            subtitleStyle: widget.subtitleStyle,
            flagCache: widget.flagCache,
          ),
        ),
      ],
    );
  }
}
