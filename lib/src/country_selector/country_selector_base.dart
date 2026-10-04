import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'country_selector_controller.dart';
import 'localization/localization.dart';

abstract class CountrySelectorBase extends StatefulWidget {
  /// List of countries to display in the selector
  /// Value optional in constructor.
  /// when omitted, the full country list is displayed
  final List<IsoCode> countries;

  /// Determine the countries to be displayed on top of the list
  /// Check [addFavoritesSeparator] property to enable/disable adding a
  /// list divider between favorites and others defaults countries
  final List<IsoCode> favoriteCountries;

  /// Callback triggered when user select a country
  final ValueChanged<IsoCode> onCountrySelected;

  /// ListView.builder scroll controller (ie: [ScrollView.controller])
  final ScrollController? scrollController;

  /// The [ScrollPhysics] of the Country List
  final ScrollPhysics? scrollPhysics;

  /// Whether to show the country country code (ie: +1 / +33 /...)
  /// as a listTile subtitle
  final bool showDialCode;

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

  /// The size of the flag inside the selector
  final double flagSize;

  const CountrySelectorBase({
    super.key,
    required this.onCountrySelected,
    this.scrollController,
    this.scrollPhysics,
    bool? showDialCode,
    this.noResultMessage,
    List<IsoCode>? favoriteCountries,
    List<IsoCode>? countries,
    bool? searchAutofocus,
    this.subtitleStyle,
    this.titleStyle,
    this.searchBoxDecoration,
    this.searchBoxTextStyle,
    this.searchBoxIconColor,
    double? flagSize,
  })  : countries = countries ?? IsoCode.values,
        favoriteCountries = favoriteCountries ?? const [],
        showDialCode = showDialCode ?? false,
        flagSize = flagSize ?? 40,
        searchAutofocus = searchAutofocus ?? kIsWeb;
}

abstract class CountrySelectorBaseState<W extends CountrySelectorBase>
    extends State<W> {
  CountrySelectorController? _controller;
  String searchText = '';

  /// The controller backing the country list.
  ///
  /// It is rebuilt in [didChangeDependencies] so that the country names
  /// follow the current localization.
  CountrySelectorController get controller => _controller!;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final localization = CountrySelectorLocalization.of(context) ??
        CountrySelectorLocalizationEn();
    final previousController = _controller;
    _controller = CountrySelectorController.fromLocalization(
      countries: widget.countries,
      favorites: widget.favoriteCountries,
      localization: localization,
    );
    // the previous controller is now unused, dispose it so that it does not
    // linger around after a localization change
    previousController?.dispose();
    // language might have changed, re-apply the current search
    controller.search(searchText);
  }

  /// when the user types in the search box
  void onSearch(String searchedText) {
    controller.search(searchedText);
    searchText = searchedText;
  }

  /// when the user press enter in the search box, select the first matching
  /// country, favorites first
  void onSubmitted() {
    final favorites = controller.filteredFavorites;
    final countries = controller.filteredCountries;
    final first = favorites.isNotEmpty
        ? favorites.first
        : (countries.isNotEmpty ? countries.first : null);
    if (first != null) {
      widget.onCountrySelected(first.isoCode);
    }
  }
}
