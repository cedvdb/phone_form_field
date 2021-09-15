import 'package:example/main.dart';
import 'package:example/screens/country_selector_screen.dart';
import 'package:example/screens/dial_code_chip_screen.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('phone_form_field'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => PhoneFormFieldScreen())),
          ),
          ListTile(
            title: Text('country_selector'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => CountrySelectorScreen())),
          ),
          ListTile(
            title: Text('dial_code_chip'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => DialCodeChipScreen())),
          ),
        ],
      ),
    );
  }
}
