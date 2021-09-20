import 'package:example/widgets/switch_el.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  runApp(MyApp());
}

/// putting the widget at the top so it's easily findable in pub.dev example

class PhoneFieldView extends StatelessWidget {
  final Key inputKey;
  final PhoneController controller;
  final CountrySelectorNavigator selectorNavigator;
  final bool withLabel;
  final bool outlineBorder;
  final bool mobileOnly;
  final bool autovalidate;
  final Function(PhoneNumber?) onChanged;

  const PhoneFieldView({
    Key? key,
    required this.inputKey,
    required this.controller,
    required this.selectorNavigator,
    required this.withLabel,
    required this.outlineBorder,
    required this.mobileOnly,
    required this.autovalidate,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: PhoneFormField(
        key: inputKey,
        autofocus: true,
        withHint: true,
        controller: controller,
        selectorNavigator: selectorNavigator,
        defaultCountry: 'FR',
        decoration: InputDecoration(
          labelText: withLabel ? 'Phone' : null,
          border: outlineBorder ? OutlineInputBorder() : UnderlineInputBorder(),
        ),
        enabled: true,
        showFlagInInput: true,
        phoneNumberType: mobileOnly ? PhoneNumberType.mobile : null,
        autovalidateMode: autovalidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        errorText: 'Invalid phone',
        onChanged: onChanged,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
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
      home: PhoneFormFieldScreen(),
    );
  }
}

class PhoneFormFieldScreen extends StatefulWidget {
  @override
  _PhoneFormFieldScreenState createState() => _PhoneFormFieldScreenState();
}

class _PhoneFormFieldScreenState extends State<PhoneFormFieldScreen> {
  late PhoneController controller;
  bool outlineBorder = true;
  bool withLabel = true;
  bool autovalidate = true;
  bool mobileOnly = true;
  CountrySelectorNavigator selectorNavigator = const BottomSheetNavigator();
  final formKey = GlobalKey<FormState>();
  final phoneKey = GlobalKey<FormFieldState>();

  @override
  initState() {
    super.initState();
    controller = PhoneController(null);
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  // _getSubmitState() {
  //   if (mobileOnly)
  //     return phoneNumber.validate(PhoneNumberType.mobile) ? () {} : null;
  //   return phoneNumber.validate(null) ? () {} : null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Phone_form_field'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                    SwitchEl(
                      value: mobileOnly,
                      onChanged: (v) => setState(() => mobileOnly = v),
                      title: 'Mobile phone number only',
                    ),
                    Row(
                      children: [
                        Text('Country selector: '),
                        DropdownButton<CountrySelectorNavigator>(
                          value: selectorNavigator,
                          onChanged: (CountrySelectorNavigator? value) {
                            if (value != null) {
                              setState(() => selectorNavigator = value);
                            }
                          },
                          items: [
                            DropdownMenuItem(
                              child: Text('Bottom sheet'),
                              value: const BottomSheetNavigator(),
                            ),
                            DropdownMenuItem(
                              child: Text('Modal sheet'),
                              value: const ModalBottomSheetNavigator(),
                            ),
                            DropdownMenuItem(
                              child: Text('Dialog'),
                              value: const DialogNavigator(),
                            ),
                            DropdownMenuItem(
                              child: Text('Draggable modal sheet'),
                              value: const DraggableModalBottomSheetNavigator(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Form(
                      key: formKey,
                      child: PhoneFieldView(
                        inputKey: phoneKey,
                        controller: controller,
                        selectorNavigator: selectorNavigator,
                        withLabel: withLabel,
                        outlineBorder: outlineBorder,
                        mobileOnly: mobileOnly,
                        autovalidate: autovalidate,
                        onChanged: (p) => print('changed $p'),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: controller.value == null
                          ? null
                          : () => formKey.currentState?.reset(),
                      child: Text('reset'),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(controller.value.toString()),
                    Text('is valid mobile number '
                        '${controller.value != null ? PhoneParser().validate(controller.value!, PhoneNumberType.mobile) : 'false'}'),
                    Text(
                        'is valid fixed line number ${controller.value != null ? PhoneParser().validate(controller.value!, PhoneNumberType.fixedLine) : 'false'}'),
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
