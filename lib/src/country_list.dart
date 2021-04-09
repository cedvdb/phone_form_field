import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'localization/phone_field_localization.dart';

class CountryList extends StatelessWidget {
  final bool displayLeadingDigitsInDialCode;
  final Function(Country) onTap;
  final List<Country> countries;

  const CountryList({
    required this.countries,
    required this.onTap,
    required this.displayLeadingDigitsInDialCode,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // controller: widget.scrollController,
      shrinkWrap: true,
      itemCount: countries.length,
      itemBuilder: (BuildContext context, int index) {
        Country country = countries[index];
        return ListTile(
          key: Key(country.isoCode),
          leading: CircleFlag(country.isoCode),
          title: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              PhoneFieldLocalization.of(context)?.translate(country.isoCode) ??
                  country.name,
              textAlign: TextAlign.start,
            ),
          ),
          subtitle: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              country.getDialCodeForDisplay(
                withLeadingDigits: displayLeadingDigitsInDialCode,
              ),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.start,
            ),
          ),
          onTap: () => onTap(country),
        );
      },
    );
  }
}
