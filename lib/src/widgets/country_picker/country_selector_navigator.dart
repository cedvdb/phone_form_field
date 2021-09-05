import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/all_countries.dart';
import '../../models/country.dart';
import 'country_selector.dart';

abstract class CountrySelectorNavigator {
  Future<Country?> navigate(BuildContext context);
}

class DialogNavigator implements CountrySelectorNavigator {
  final List<Country>? countries;
  final List<String>? favorites;
  final bool addSeparator;
  final bool showDialCode;
  final bool sortCountries;
  final String? noResultMessage;

  const DialogNavigator({
    this.countries,
    this.favorites,
    this.addSeparator = true,
    this.showDialCode = true,
    this.sortCountries = false,
    this.noResultMessage,
  });

  @override
  Future<Country?> navigate(BuildContext context) {
    return showDialog<Country>(
      context: context,
      builder: (_) => Dialog(
        child: CountrySelector(
          countries: countries ?? allCountries,
          onCountrySelected: (country) => Navigator.pop(context, country),
          favoritesCountries: favorites ?? [],
          addSeparator: addSeparator,
          showDialCode: showDialCode,
          sortCountries: sortCountries,
          noResultMessage: noResultMessage,
        ),
      ),
    );
  }
}

class BottomSheetNavigator implements CountrySelectorNavigator {
  final List<Country>? countries;
  final List<String>? favorites;
  final bool addSeparator;
  final bool showDialCode;
  final bool sortCountries;
  final String? noResultMessage;

  const BottomSheetNavigator({
    this.countries,
    this.favorites,
    this.addSeparator = true,
    this.showDialCode = true,
    this.sortCountries = false,
    this.noResultMessage,
  });

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
        favoritesCountries: favorites ?? [],
        addSeparator: addSeparator,
        showDialCode: showDialCode,
        sortCountries: sortCountries,
        noResultMessage: noResultMessage,
      ),
    );
    return ctrl.closed.then((_) => selected);
  }
}

class ModalBottomSheetNavigator implements CountrySelectorNavigator {
  final double? height;
  final List<Country>? countries;
  final List<String>? favorites;
  final bool addSeparator;
  final bool showDialCode;
  final bool sortCountries;
  final String? noResultMessage;

  const ModalBottomSheetNavigator({
    this.countries,
    this.height,
    this.favorites,
    this.addSeparator = true,
    this.showDialCode = true,
    this.sortCountries = false,
    this.noResultMessage,
  });

  @override
  Future<Country?> navigate(BuildContext context) {
    return showModalBottomSheet<Country>(
      context: context,
      builder: (_) => SizedBox(
        height: height ?? MediaQuery.of(context).size.height - 90,
        child: CountrySelector(
          countries: countries ?? allCountries,
          onCountrySelected: (country) => Navigator.pop(context, country),
          favoritesCountries: favorites ?? [],
          addSeparator: addSeparator,
          showDialCode: showDialCode,
          sortCountries: sortCountries,
          noResultMessage: noResultMessage,
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class DraggableModalBottomSheetNavigator implements CountrySelectorNavigator {
  final List<Country>? countries;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final BorderRadiusGeometry? borderRadius;
  final List<String>? favorites;
  final bool addSeparator;
  final bool showDialCode;
  final bool sortCountries;
  final String? noResultMessage;

  const DraggableModalBottomSheetNavigator({
    this.countries,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.85,
    this.borderRadius,
    this.favorites,
    this.addSeparator = true,
    this.showDialCode = true,
    this.sortCountries = false,
    this.noResultMessage,
  });

  @override
  Future<Country?> navigate(BuildContext context) {
    final effectiveBorderRadius = borderRadius ??
        BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        );
    return showModalBottomSheet<Country>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: ShapeDecoration(
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: effectiveBorderRadius,
              ),
            ),
            child: CountrySelector(
              countries: countries ?? allCountries,
              onCountrySelected: (country) => Navigator.pop(context, country),
              scrollController: scrollController,
              favoritesCountries: favorites ?? [],
              addSeparator: addSeparator,
              showDialCode: showDialCode,
              sortCountries: sortCountries,
              noResultMessage: noResultMessage,
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
