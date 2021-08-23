import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/src/models/all_countries.dart';
import 'package:phone_form_field/src/models/country.dart';

import 'country_selector.dart';

abstract class CountrySelectorNavigator {
  final List<Country>? countries;

  const CountrySelectorNavigator({this.countries});
  Future<Country?> navigate(BuildContext context);
}

class DialogNavigator implements CountrySelectorNavigator {
  final List<Country>? countries;

  const DialogNavigator({this.countries});

  @override
  Future<Country?> navigate(BuildContext context) {
    return showDialog<Country>(
      context: context,
      builder: (_) => Dialog(
        child: CountrySelector(
          countries: countries ?? allCountries,
          onCountrySelected: (country) => Navigator.pop(context, country),
        ),
      ),
    );
  }
}

class BottomSheetNavigator implements CountrySelectorNavigator {
  final List<Country>? countries;

  const BottomSheetNavigator({this.countries});
  @override
  Future<Country?> navigate(BuildContext context) {
    late Country selected;
    final ctrl = showBottomSheet(
      context: context,
      builder: (_) => CountrySelector(
        countries: countries ?? allCountries,
        onCountrySelected: (country) {
          selected = country;
          Navigator.pop(context, country);
        },
      ),
    );
    return ctrl.closed.then((_) => selected);
  }
}

class ModalBottomSheetNavigator implements CountrySelectorNavigator {
  final double? height;
  final List<Country>? countries;

  const ModalBottomSheetNavigator({this.countries, this.height});

  @override
  Future<Country?> navigate(BuildContext context) {
    return showModalBottomSheet<Country>(
      context: context,
      builder: (_) => SizedBox(
        height: height ?? MediaQuery.of(context).size.height - 90,
        child: CountrySelector(
          countries: countries ?? allCountries,
          onCountrySelected: (country) => Navigator.pop(context, country),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
