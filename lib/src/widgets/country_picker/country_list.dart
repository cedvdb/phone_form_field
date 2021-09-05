import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/country.dart';

class CountryList extends StatelessWidget {
  /// Callback function triggered when user select a country
  final Function(Country) onTap;

  /// List of countries to display
  final List<Country> countries;

  /// proxy to the ListView.builder controller (ie: [ScrollView.controller])
  final ScrollController? scrollController;

  /// whether the country dialcode should be displayed as the [ListTile.subtitle]
  final bool showDialCode;

  /// the index of the listview where divider should be added
  final int? separatorIndex;

  const CountryList({
    Key? key,
    required this.countries,
    required this.onTap,
    this.scrollController,
    this.separatorIndex = null,
    this.showDialCode = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int listLength = countries.isNotEmpty && separatorIndex != null
        ? countries.length + 1
        : countries.length;

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: listLength,
      itemBuilder: (BuildContext context, int index) {
        if (index == separatorIndex) {
          return Divider(key: Key('countryListSeparator.$hashCode'));
        }

        // when separator is reached, the country list index is shift
        // by 1 from the list builder index
        final countryIndexDelta =
            separatorIndex != null && index >= separatorIndex! ? 1 : 0;
        Country country = countries[index - countryIndexDelta];

        return ListTile(
          key: Key(country.isoCode),
          leading: CircleFlag(
            country.isoCode,
            size: showDialCode ? null : 40,
          ),
          title: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              country.localisedName(context),
              textAlign: TextAlign.start,
            ),
          ),
          subtitle: showDialCode
              ? Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    country.displayDialCode,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.start,
                  ),
                )
              : null,
          onTap: () => onTap(country),
        );
      },
    );
  }
}
