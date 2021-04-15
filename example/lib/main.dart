import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PhoneNumber phoneNumber = PhoneNumber.fromIsoCode('us', '011');
  bool outlineBorder = false;
  bool autovalidate = true;

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
        const Locale('de', ''),
        const Locale('fr', ''),
        const Locale('it', ''),
        const Locale('ru', ''),
        // ...
      ],
      title: 'Phone field demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: outlineBorder,
                          onChanged: (v) => setState(() => outlineBorder = v),
                        ),
                        Text('Outlined border'),
                      ],
                    ),
                    Row(
                      children: [
                        Switch(
                          value: autovalidate,
                          onChanged: (v) => setState(() => autovalidate = v),
                        ),
                        Text('Autovalidate'),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    PhoneFormField(
                      initialValue: phoneNumber,
                      autofocus: true,
                      inputDecoration: InputDecoration(
                        border: outlineBorder ? OutlineInputBorder() : null,
                        focusedBorder: outlineBorder
                            ? OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              )
                            : null,
                      ),
                      onChanged: (p) => setState(() => phoneNumber = p!),
                      onSaved: (p) => setState(() => phoneNumber = p),
                      enabled: true,
                      showFlagInInput: true,
                      autovalidateMode: autovalidate
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: phoneNumber.valid ? () {} : null,
                      child: Text('next'),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(phoneNumber.toString()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
