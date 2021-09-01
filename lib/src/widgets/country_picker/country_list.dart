import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../localization/phone_field_localization.dart';
import '../../models/country.dart';

class CountryList extends StatelessWidget {
  final Function(Country) onTap;
  final List<Country> countries;
  final ScrollController? scrollController;

  const CountryList({
    Key? key,
    required this.countries,
    required this.onTap,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
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
