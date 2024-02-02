import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../country/localized_country.dart';
import 'no_result_view.dart';

class CountryListView extends StatelessWidget {
  /// Callback function triggered when user select a country
  final Function(LocalizedCountry) onTap;

  /// List of countries to display
  final List<LocalizedCountry> countries;
  final double flagSize;

  /// list of favorite countries to display at the top
  final List<LocalizedCountry> favorites;

  /// proxy to the ListView.builder controller (ie: [ScrollView.controller])
  final ScrollController? scrollController;

  /// The [ScrollPhysics] of the Country List
  final ScrollPhysics? scrollPhysics;

  /// whether the country dialcode should be displayed as the [ListTile.subtitle]
  final bool showDialCode;

  final String? noResultMessage;

  late final List<LocalizedCountry?> _allListElement;

  final TextStyle? subtitleStyle;
  final TextStyle? titleStyle;
  final FlagCache? flagCache;

  CountryListView({
    super.key,
    required this.countries,
    required this.favorites,
    required this.onTap,
    required this.noResultMessage,
    required this.flagCache,
    this.scrollController,
    this.scrollPhysics,
    this.showDialCode = true,
    this.flagSize = 40,
    this.subtitleStyle,
    this.titleStyle,
  }) {
    if (listEquals(countries, favorites)) {
      _allListElement = countries;
    } else {
      _allListElement = [
        ...favorites,
        if (favorites.isNotEmpty) null, // delimiter
        ...countries,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_allListElement.isEmpty) {
      return NoResultView(title: noResultMessage);
    }
    return ListView.builder(
      physics: scrollPhysics,
      controller: scrollController,
      itemCount: _allListElement.length,
      itemBuilder: (BuildContext context, int index) {
        final country = _allListElement[index];
        if (country == null) {
          return const Divider(key: ValueKey('countryListSeparator'));
        }

        return ListTile(
          key: ValueKey(country.isoCode.name),
          leading: CircleFlag(
            country.isoCode.name,
            key: ValueKey('circle-flag-${country.isoCode.name}'),
            size: flagSize,
            cache: flagCache,
          ),
          title: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              country.name,
              textAlign: TextAlign.start,
              style: titleStyle,
            ),
          ),
          subtitle: showDialCode
              ? Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    country.formattedCountryDialingCode,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.start,
                    style: subtitleStyle,
                  ),
                )
              : null,
          onTap: () => onTap(country),
        );
      },
    );
  }
}
