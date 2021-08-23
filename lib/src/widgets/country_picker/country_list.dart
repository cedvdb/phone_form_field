import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/country.dart';
import '../../localization/phone_field_localization.dart';

class CountryList extends StatelessWidget {
  final Function(Country) onTap;
  final List<Country> countries;

  const CountryList({
    Key? key,
    required this.countries,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // controller: widget.scrollController,
      shrinkWrap: true,
      itemCount: countries.length,
      itemBuilder: (BuildContext context, int index) {
        final country = countries[index];
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
              country.displayDialCode,
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
