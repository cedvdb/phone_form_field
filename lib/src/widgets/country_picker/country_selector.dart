import 'package:flutter/material.dart';
import 'package:phone_form_field/src/helpers/country_finder.dart';
import 'package:phone_form_field/src/models/all_countries.dart';
import 'package:phone_form_field/src/widgets/country_picker/search_box.dart';

import '../../models/country.dart';
import 'country_list.dart';

class CountrySelector extends StatefulWidget {
  final List<Country> countries;
  final Function(Country) onCountrySelected;
  final ScrollController? scrollController;

  CountrySelector({
    Key? key,
    required this.onCountrySelected,
    this.scrollController,
    List<Country>? countries,
  })  : countries = countries ?? allCountries,
        super(key: key);

  @override
  _CountrySelectorState createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  late List<Country> _filteredCountries;
  late final _countryFinder;

  @override
  initState() {
    super.initState();
    _filteredCountries = widget.countries;
    _countryFinder = CountryFinder(widget.countries);
  }

  _onSearch(String txt) {
    setState(() => _filteredCountries = _countryFinder.filter(txt, context));
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
        Flexible(
          child: CountryList(
            countries: _filteredCountries,
            onTap: (country) {
              widget.onCountrySelected(country);
            },
            scrollController: widget.scrollController,
          ),
        ),
      ],
    );
  }
}
