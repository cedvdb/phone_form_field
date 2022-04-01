import 'package:dart_countries/dart_countries.dart' show isoCodes;

import 'country.dart';

final allCountries = isoCodes

    /// those 3 (small) islands dont have flags in the circle_flags library
    /// it's unlikely anyone with a phone will be from there anyway
    /// those will be added when added to the circle_flags library
    .where((iso) => iso != 'AC' && iso != 'BQ' && iso != 'TA')
    .map((iso) => Country(iso))
    .toSet();
