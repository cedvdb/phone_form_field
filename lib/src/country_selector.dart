import 'package:flutter/material.dart';
import 'package:phone_form_field/src/search_box.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'country_list.dart';

class CountrySelector extends StatefulWidget {
  final Function(Country) onCountrySelected;

  CountrySelector({
    required this.onCountrySelected,
  });

  @override
  _CountrySelectorState createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  List<Country> _filteredCountries = countries;

  _onSearch(String txt) {
    // if the txt is a number we check the dial code instead
    final asInt = int.tryParse(txt);
    final isNum = asInt != null;
    var filtered;
    if (isNum) {
      // toString to remove any + in front if its an int
      filtered = _filterByDialCode(asInt!.toString());
    } else {
      filtered = _filterByName(txt);
    }
    setState(() => _filteredCountries = filtered);
  }

  List<Country> _filterByDialCode(String dialCode) {
    final getSortPoint =
        (Country c) => c.dialCode.length == dialCode.length ? 1 : 0;
    return countries.where((c) => c.dialCode.contains(dialCode)).toList()
      // puts the closest match at the top
      ..sort((a, b) => getSortPoint(b) - getSortPoint(a));
  }

  List<Country> _filterByName(String txt) {
    final lowerCaseTxt = txt.toLowerCase();
    final getSortPoint = (Country c) =>
        c.name.toLowerCase().startsWith(lowerCaseTxt) ||
                c.isoCode.toLowerCase().startsWith(lowerCaseTxt)
            ? 1
            : 0;
    return countries
        .where((c) =>
            c.name.toLowerCase().contains(lowerCaseTxt) ||
            c.isoCode.toLowerCase().contains(lowerCaseTxt))
        .toList()
          // puts the ones that begin by txt first
          ..sort((a, b) => getSortPoint(b) - getSortPoint(a));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          width: double.infinity,
          child: SearchBox(
            onChanged: _onSearch,
          ),
        ),
        Expanded(
          flex: 9,
          child: CountryList(
            countries: _filteredCountries,
            onTap: (country) {
              widget.onCountrySelected(country);
            },
          ),
        ),
      ],
    );
  }
}
