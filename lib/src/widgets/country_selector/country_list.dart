import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';

import '../../../l10n/generated/phone_field_localization.dart';
import 'country.dart';

class CountryList extends StatelessWidget {
  /// Callback function triggered when user select a country
  final Function(Country) onTap;

  /// List of countries to display
  final List<Country> countries;
  final double flagSize;

  /// list of favorite countries to display at the top
  final List<Country> favorites;

  /// proxy to the ListView.builder controller (ie: [ScrollView.controller])
  final ScrollController? scrollController;

  /// The [ScrollPhysics] of the Country List
  final ScrollPhysics? scrollPhysics;

  /// whether the country dialcode should be displayed as the [ListTile.subtitle]
  final bool showDialCode;

  final String? noResultMessage;

  late final List<Country?> _allListElement;

  final TextStyle? subtitleStyle;
  final TextStyle? titleStyle;
  final FlagCache? flagCache;

  CountryList({
    Key? key,
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
  }) : super(key: key) {
    _allListElement = [
      ...favorites,
      if (favorites.isNotEmpty) null, // delimiter
      ...countries,
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_allListElement.isEmpty) {
      return Center(
        child: Text(
          noResultMessage ??
              PhoneFieldLocalization.of(context)?.noResultMessage ??
              'No result found',
          key: const ValueKey('no-result'),
        ),
      );
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
                    country.displayCountryCode,
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
