import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phone_number_input/phone_number_input.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PhoneNumber phoneNumber = PhoneNumber.fromIsoCode('us', '011');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        PhoneFieldLocalization.delegate
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('es', ''),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              children: [
                PhoneFormField(
                  initialValue: phoneNumber,
                  autofocus: true,
                  onChanged: (p) => print(p),
                  onSaved: (p) {
                    setState(() => phoneNumber = p);
                  },
                ),
                TextFormField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
