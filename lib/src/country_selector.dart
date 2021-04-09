import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/search_box.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class CountrySelector extends StatefulWidget {
  final Function(Country) onCountrySelected;
  final bool displayLeadingDigitsInDialCode;

  CountrySelector({
    required this.onCountrySelected,
    required this.displayLeadingDigitsInDialCode,
  });

  @override
  _CountrySelectorState createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  List<Country> _filteredCountries = countries;

  _onSearch(String txt) {
    final filtered = countries
        .where(
          (c) =>
              c.name.toLowerCase().contains(txt.toLowerCase()) ||
              c.isoCode.toLowerCase().contains(txt.toLowerCase()),
        )
        .toList();
    setState(() => _filteredCountries = filtered);
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
            displayLeadingDigitsInDialCode:
                widget.displayLeadingDigitsInDialCode,
            onTap: (country) {
              widget.onCountrySelected(country);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
