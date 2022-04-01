import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization.dart';
import 'package:phone_form_field/src/helpers/localized_country_registry.dart';

import '../../helpers/country_finder.dart';
import '../../models/all_countries.dart';
import '../../models/country.dart';
import 'country_list.dart';
import 'search_box.dart';

class CountrySelector extends StatefulWidget {
  /// List of countries to display in the selector
  /// Value optional in constructor.
  /// when omitted, the full country list is displayed
  final List<Country> countries;

  /// Callback triggered when user select a country
  final ValueChanged<Country> onCountrySelected;

  /// ListView.builder scroll controller (ie: [ScrollView.controller])
  final ScrollController? scrollController;

  /// Sort the countries automatically by localized name.
  /// Note that the favorites countries are not sorted but
  /// displayed in defined order.
  final bool sortCountries;

  /// Determine the countries to be displayed on top of the list
  /// Check [addFavoritesSeparator] property to enable/disable adding a
  /// list divider between favorites and others defaults countries
  final List<String> favoriteCountries;

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

  CountrySelector({
    Key? key,
    required this.onCountrySelected,
    this.scrollController,
    this.sortCountries = true,
    this.addFavoritesSeparator = true,
    this.showCountryCode = false,
    this.noResultMessage,
    this.favoriteCountries = const [],
    List<Country>? countries,
    this.searchAutofocus = kIsWeb,
  })  : countries = countries ?? allIsoCodes,
        super(key: key);

  @override
  _CountrySelectorState createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  late List<Country> _filteredCountries;
  late List<Country> _favoriteCountries;
  late CountryFinder _countryFinder;
  late CountryFinder _favoriteCountryFinder;
  int? _favoritesSeparatorIndex;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    // ensure countries list is sorted by localized name
    // this need to be done in didChangeDependencies (not in initState)
    // as context is not available in initState and context is required
    // to get the localized country name
    _filteredCountries = widget.sortCountries
        ? _sortCountries(widget.countries)
        : widget.countries;
    _countryFinder = CountryFinder(_filteredCountries);

    _handleFavoritesCountries();
  }

  List<Country> _sortCountries(List<Country> countriesList) {
    // perform a copy so we don't modify original value
    return countriesList
      ..sort((Country a, Country b) {
        return LocalizedCountryListBuilder.localisedName(context, a)
            .compareTo(LocalizedCountryListBuilder.localisedName(context, b));
      });
  }

  _handleFavoritesCountries() {
    final hasFavoritesCountry =
        _filteredCountries.isNotEmpty && widget.favoriteCountries.isNotEmpty;

    // hold index where the separator must be displayed
    _favoritesSeparatorIndex = null;

    if (!hasFavoritesCountry) {
      return;
    }

    for (var isoCode in widget.favoriteCountries.reversed) {
      final int favIndex = _filteredCountries.indexWhere(
        (Country country) => country.isoCode == isoCode.toUpperCase(),
      );
      if (favIndex >= 0) {
        _filteredCountries.removeAt(favIndex);
        _filteredCountries.insert(0, Country(isoCode.toUpperCase()));
        _favoritesSeparatorIndex = (_favoritesSeparatorIndex ?? 0) + 1;
      }
    }
  }

  _onSearch(String txt) {
    setState(() {
      _filteredCountries = _countryFinder.filter(txt, context);
      _handleFavoritesCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          width: double.infinity,
          child: SearchBox(
            autofocus: widget.searchAutofocus,
            onChanged: _onSearch,
          ),
        ),
        Flexible(
          child: _filteredCountries.isNotEmpty
              ? CountryList(
                  countries: _filteredCountries,
                  separatorIndex: _favoritesSeparatorIndex,
                  showDialCode: widget.showCountryCode,
                  onTap: (country) {
                    widget.onCountrySelected(country);
                  },
                  scrollController: widget.scrollController,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    widget.noResultMessage ??
                        PhoneFieldLocalization.of(context)?.noResultMessage ??
                        'No result found',
                    key: const ValueKey('no-result'),
                  ),
                ),
        ),
      ],
    );
  }
}
