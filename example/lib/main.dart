import 'package:flutter/material.dart';
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
                  phoneNumber: phoneNumber,
                  onChange: (p) {
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
