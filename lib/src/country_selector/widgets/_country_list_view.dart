import 'package:circle_flags/circle_flags.dart';
import 'package:material_ui/material_ui.dart';

import '../search/searchable_country.dart';
import '_no_result_view.dart';

class CountryListView extends StatelessWidget {
  /// Callback function triggered when user select a country
  final Function(SearchableCountry) onTap;

  /// List of countries to display
  final List<SearchableCountry> countries;
  final double flagSize;

  /// list of favorite countries to display at the top
  final List<SearchableCountry> favorites;

  /// proxy to the ListView.builder controller (ie: [ScrollView.controller])
  final ScrollController? scrollController;

  /// The [ScrollPhysics] of the Country List
  final ScrollPhysics? scrollPhysics;

  /// whether the country dialcode should be displayed as the [ListTile.subtitle]
  final bool showDialCode;

  final String? noResultMessage;

  final TextStyle? subtitleStyle;
  final TextStyle? titleStyle;

  const CountryListView({
    super.key,
    required this.countries,
    required this.favorites,
    required this.onTap,
    required this.noResultMessage,
    this.scrollController,
    this.scrollPhysics,
    this.showDialCode = true,
    this.flagSize = 40,
    this.subtitleStyle,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final allListElements = [
      ...favorites,
      if (favorites.isNotEmpty) null, // delimiter
      ...countries,
    ];

    if (allListElements.isEmpty) {
      return NoResultView(title: noResultMessage);
    }

    return ListView.builder(
      physics: scrollPhysics,
      controller: scrollController,
      itemCount: allListElements.length,
      itemBuilder: (BuildContext context, int index) {
        final country = allListElements[index];
        if (country == null) {
          return const Divider(key: ValueKey('countryListSeparator'));
        }

        return ListTile(
          key: ValueKey(country.isoCode.name),
          leading: CircleFlag(
            country.isoCode.name,
            key: ValueKey('circle-flag-${country.isoCode.name}'),
            size: flagSize,
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
