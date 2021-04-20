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
  PhoneNumber phoneNumber = PhoneNumber.fromIsoCode('BE', '');
  bool outlineBorder = false;
  bool withLabel = true;
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
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AutofillGroup(
                  child: Column(
                    children: [
                      SwitchEl(
                        value: outlineBorder,
                        onChanged: (v) => setState(() => outlineBorder = v),
                        title: 'Outlined border',
                      ),
                      SwitchEl(
                        value: autovalidate,
                        onChanged: (v) => setState(() => autovalidate = v),
                        title: 'Autovalidate',
                      ),
                      SwitchEl(
                        value: withLabel,
                        onChanged: (v) => setState(() => withLabel = v),
                        title: 'Label',
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        autofillHints: [
                          AutofillHints.name,
                          AutofillHints.email
                        ],
                        decoration: InputDecoration(
                          labelText: withLabel ? 'Name' : null,
                          prefixIcon: Icon(Icons.phone),
                          border: outlineBorder
                              ? OutlineInputBorder()
                              : UnderlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          // icon: Icon(Icons.phone),
                          labelText: withLabel ? 'Name' : null,
                          border: outlineBorder
                              ? OutlineInputBorder()
                              : UnderlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      PhoneFormField(
                        initialValue: phoneNumber,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: withLabel ? 'icon' : null,
                          border: outlineBorder
                              ? OutlineInputBorder()
                              : UnderlineInputBorder(),
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
                        height: 12,
                      ),
                      PhoneFormField(
                        initialValue: phoneNumber,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: withLabel ? 'Prefix' : null,
                          border: outlineBorder
                              ? OutlineInputBorder()
                              : UnderlineInputBorder(),
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
                        height: 12,
                      ),
                      PhoneFormField(
                        initialValue: phoneNumber,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: withLabel ? 'prefixIcon' : null,
                          border: outlineBorder
                              ? OutlineInputBorder()
                              : UnderlineInputBorder(),
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
                        height: 12,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: withLabel ? 'Name' : null,
                          border: outlineBorder
                              ? OutlineInputBorder()
                              : UnderlineInputBorder(),
                        ),
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
      ),
    );
  }
}

class SwitchEl extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const SwitchEl({
    required this.value,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
        ),
        Text(title),
      ],
    );
  }
}
