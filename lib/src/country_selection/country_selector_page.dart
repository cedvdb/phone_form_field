import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization_en.dart';
import 'package:phone_form_field/src/country_selection/country_selector_controller.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../country/localized_country.dart';
import 'country_list_view.dart';
import 'search_box.dart';

/// Same as [CountrySelector] but designed as a full page
class CountrySelectorPage extends StatefulWidget {
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

  const CountrySelectorPage({
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
  CountrySelectorPageState createState() => CountrySelectorPageState();
}

class CountrySelectorPageState extends State<CountrySelectorPage> {
  late final CountrySelectorController _controller;
  String searchText = '';

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _controller = CountrySelectorController(
      context,
      widget.countries,
      widget.favoriteCountries,
    );
    // language might have changed
    _controller.search(searchText);
  }

  _onSearch(String searchedText) {
    _controller.search(searchedText);
  }

  onSubmitted() {
    final first = _controller.findFirst();
    if (first != null) {
      widget.onCountrySelected(first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: Theme.of(context).colorScheme.shadow,
        title: SearchBox(
          autofocus: widget.searchAutofocus,
          onChanged: _onSearch,
          onSubmitted: onSubmitted,
          decoration: widget.searchBoxDecoration ??
              InputDecoration(
                border: InputBorder.none,
                hintText: PhoneFieldLocalization.of(context)?.search ??
                    PhoneFieldLocalizationEn().search,
              ),
          style: widget.searchBoxTextStyle,
          searchIconColor: widget.searchBoxIconColor,
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CountryListView(
            countries: _controller.filteredCountries,
            favorites: _controller.filteredFavorites,
            showDialCode: widget.showCountryCode,
            onTap: widget.onCountrySelected,
            flagSize: widget.flagSize,
            scrollController: widget.scrollController,
            scrollPhysics: widget.scrollPhysics,
            noResultMessage: widget.noResultMessage,
            titleStyle: widget.titleStyle,
            subtitleStyle: widget.subtitleStyle,
            flagCache: widget.flagCache,
          );
        },
      ),
    );
  }
}
