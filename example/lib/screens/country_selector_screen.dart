import 'package:example/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

class CountrySelectorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Phone_form_field'),
      ),
      body: Container(
        child: CountrySelector(onCountrySelected: (c) {}),
      ),
    );
  }
}
