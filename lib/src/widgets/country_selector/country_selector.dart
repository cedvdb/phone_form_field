import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization_en.dart';
import 'package:phone_form_field/src/helpers/localized_country_registry.dart';
import 'package:phone_form_field/src/models/iso_code.dart';

import '../../helpers/country_finder.dart';
import '../../models/country.dart';
import 'country_list.dart';
import 'search_box.dart';

class CountrySelector extends StatefulWidget {
  /// List of countries to display in the selector
  /// Value optional in constructor.
  /// when omitted, the full country list is displayed
  final List<IsoCode>? countries;

  /// Callback triggered when user select a country
  final ValueChanged<Country> onCountrySelected;

  /// ListView.builder scroll controller (ie: [ScrollView.controller])
  final ScrollController? scrollController;

  /// Determine the countries to be displayed on top of the list
  /// Check [addFavoritesSeparator] property to enable/disable adding a
  /// list divider between favorites and others defaults countries
  final List<IsoCode> favoriteCountries;

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

  const CountrySelector({
    Key? key,
    required this.onCountrySelected,
    this.scrollController,
    this.addFavoritesSeparator = true,
    this.showCountryCode = false,
    this.noResultMessage,
    this.favoriteCountries = const [],
    this.countries,
    this.searchAutofocus = kIsWeb,
  }) : super(key: key);

  @override
  _CountrySelectorState createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  late CountryFinder _countryFinder;
  late CountryFinder _favoriteCountryFinder;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final localization =
        PhoneFieldLocalization.of(context) ?? PhoneFieldLocalizationEn();
    final isoCodes = widget.countries ?? IsoCode.values;
    final countryRegistry = LocalizedCountryRegistry.cached(localization);
    final notFavoriteCountries =
        countryRegistry.whereIsoIn(isoCodes, omit: widget.favoriteCountries);
    final favoriteCountries =
        countryRegistry.whereIsoIn(widget.favoriteCountries);
    _countryFinder = CountryFinder(notFavoriteCountries);
    _favoriteCountryFinder = CountryFinder(favoriteCountries, sort: false);
  }

  _onSearch(String txt) {
    _countryFinder.filter(txt);
    setState(() {});
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
          child: _countryFinder.isNotEmpty || _favoriteCountryFinder.isNotEmpty
              ? CountryList(
                  favorites: _favoriteCountryFinder.filteredCountries,
                  countries: _countryFinder.filteredCountries,
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
