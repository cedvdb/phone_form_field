import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization_en.dart';
import 'package:phone_form_field/src/helpers/localized_country_registry.dart';
import 'package:phone_form_field/src/models/iso_code.dart';

import '../../helpers/country_finder.dart';
import '../../models/country.dart';
import 'country_list.dart';

// class CountrySelectorSearchDelegate extends SearchDelegate {
//   late CountryFinder _countryFinder;
//   late CountryFinder _favoriteCountryFinder;

//   /// List of countries to display in the selector
//   /// Value optional in constructor.
//   /// when omitted, the full country list is displayed
//   final List<IsoCode>? countries;

//   /// Callback triggered when user select a country
//   final ValueChanged<Country> onCountrySelected;

//   /// ListView.builder scroll controller (ie: [ScrollView.controller])
//   final ScrollController? scrollController;

//   /// Determine the countries to be displayed on top of the list
//   /// Check [addFavoritesSeparator] property to enable/disable adding a
//   /// list divider between favorites and others defaults countries
//   final List<IsoCode> favoriteCountries;

//   /// Whether to add a list divider between favorites & defaults
//   /// countries.
//   final bool addFavoritesSeparator;

//   /// Whether to show the country country code (ie: +1 / +33 /...)
//   /// as a listTile subtitle
//   final bool showCountryCode;

//   /// The message displayed instead of the list when the search has no results
//   final String? noResultMessage;

//   /// whether the search input is auto focussed
//   final bool searchAutofocus;

//   LocalizedCountryRegistry? _localizedCountryRegistry;

//   CountrySelectorSearchDelegate({
//     Key? key,
//     required this.onCountrySelected,
//     this.scrollController,
//     this.addFavoritesSeparator = true,
//     this.showCountryCode = false,
//     this.noResultMessage,
//     this.favoriteCountries = const [],
//     this.countries,
//     this.searchAutofocus = kIsWeb,
//   });

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () => query = '',
//         icon: const Icon(Icons.clear),
//       ),
//     ];
//   }

//   void _initIfRequired(BuildContext context) {
//     final localization =
//         PhoneFieldLocalization.of(context) ?? PhoneFieldLocalizationEn();
//     final countryRegistry = LocalizedCountryRegistry.cached(localization);
//     // if localization has not changed no need to do anything
//     if (countryRegistry == _localizedCountryRegistry) {
//       return;
//     }
//     _localizedCountryRegistry = countryRegistry;
//     final isoCodes = countries ?? IsoCode.values;
//     final countryRegistry = LocalizedCountryRegistry.cached(localization);
//     final notFavoriteCountries =
//         countryRegistry.whereIsoIn(isoCodes, omit: favoriteCountries);
//     final favoriteCountries = countryRegistry.whereIsoIn(favoriteCountries);
//     _countryFinder = CountryFinder(notFavoriteCountries);
//     _favoriteCountryFinder = CountryFinder(favoriteCountries, sort: false);
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return BackButton(
//       onPressed: () => Navigator.of(context).pop(),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     ;
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // TODO: implement buildSuggestions
//     throw UnimplementedError();
//   }
// }

class CountrySelectorPage extends StatefulWidget {
  @override
  _CountrySelectorPageState createState() => _CountrySelectorPageState();
}

class _CountrySelectorPageState extends State<CountrySelectorPage> {
  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  _onSearch(String txt) {
    _countryFinder.filter(txt);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
            onChanged: _onSearch,
            cursorColor: Theme.of(context).colorScheme.onSurface),
      ),
      body: _countryFinder.isNotEmpty || _favoriteCountryFinder.isNotEmpty
          ? CountryList(
              favorites: _favoriteCountryFinder.filteredCountries,
              countries: _countryFinder.filteredCountries,
              showDialCode: widget.showCountryCode,
              onTap: (country) {
                widget.onCountrySelected(country);
              },
              scrollController: widget.scrollController,
            )
          : Center(
              child: Text(
                widget.noResultMessage ??
                    PhoneFieldLocalization.of(context)?.noResultMessage ??
                    'No result found',
                key: const ValueKey('no-result'),
              ),
            ),
    );
  }
}
