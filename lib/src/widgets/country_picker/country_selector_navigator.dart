import 'package:flutter/material.dart';
import 'package:phone_form_field/src/models/all_countries.dart';
import 'package:phone_form_field/src/models/country.dart';

import 'country_selector.dart';

abstract class CountrySelectorNavigator {
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
    Country? selected;
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

class DraggableModalBottomSheetNavigator implements CountrySelectorNavigator {
  final List<Country>? countries;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final BorderRadiusGeometry? borderRadius;

  const DraggableModalBottomSheetNavigator({
    this.countries,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.85,
    this.borderRadius,
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
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
