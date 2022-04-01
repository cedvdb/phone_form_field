import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/basic_types.dart';
import 'package:phone_form_field/phone_form_field.dart';

class CountrySelectorPage extends CountrySelector {
  CountrySelectorPage({
    Key? key,
    required ValueChanged<Country> onCountrySelected,
    ScrollController? scrollController,
    bool sortCountries = true,
    bool addFavoritesSeparator = true,
    bool showCountryCode = false,
    bool searchAutofocus = true,
    String? noResultMessage,
    List<String>? favoriteCountries,
    List<Country>? countries,
  }) : super(
          key: key,
          onCountrySelected: onCountrySelected,
          scrollController: scrollController,
          sortCountries: sortCountries,
          addFavoritesSeparator: addFavoritesSeparator,
          showCountryCode: showCountryCode,
          searchAutofocus: searchAutofocus,
          noResultMessage: noResultMessage,
          favoriteCountries: favoriteCountries,
          countries: countries,
        );

  @override
  Widget build(BuildContext context) {}
}
