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
  final bool shouldFormat;
  final bool required;
  final bool mobileOnly;

  const PhoneFieldView({
    Key? key,
    required this.inputKey,
    required this.controller,
    required this.selectorNavigator,
    required this.withLabel,
    required this.outlineBorder,
    required this.shouldFormat,
    required this.required,
    required this.mobileOnly,
  }) : super(key: key);

  PhoneNumberInputValidator? _getValidator() {
    List<PhoneNumberInputValidator> validators = [];
    if (required) {
      validators.add(PhoneValidator.required());
    }
    if (mobileOnly) {
      validators.add(PhoneValidator.validMobile());
    } else {
      validators.add(PhoneValidator.valid());
    }
    return validators.isNotEmpty ? PhoneValidator.compose(validators) : null;
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: PhoneFormField(
        key: inputKey,
        controller: controller,
        shouldFormat: shouldFormat,
        autofocus: true,
        autofillHints: [AutofillHints.telephoneNumber],
        selectorNavigator: selectorNavigator,
        defaultCountry: 'FR',
        decoration: InputDecoration(
          label: withLabel ? Text('Phone') : null,
          hintText: 'Phone',
          border: outlineBorder ? OutlineInputBorder() : UnderlineInputBorder(),
        ),
        enabled: true,
        showFlagInInput: true,
        validator: _getValidator(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: Theme.of(context).colorScheme.primary,
        onSaved: (p) => print('saved $p'),
        onChanged: (p) => print('changed $p'),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp();

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
  bool mobileOnly = true;
  bool shouldFormat = true;
  bool required = false;
  bool withLabel = true;
  CountrySelectorNavigator selectorNavigator = const BottomSheetNavigator();
  final formKey = GlobalKey<FormState>();
  final phoneKey = GlobalKey<FormFieldState<PhoneNumber>>();

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
                    SwitchListTile(
                      value: outlineBorder,
                      onChanged: (v) => setState(() => outlineBorder = v),
                      title: Text('Outlined border'),
                    ),
                    // SwitchListTile(
                    //   value: withLabel,
                    //   onChanged: (v) => setState(() => withLabel = v),
                    //   title: Text('Label'),
                    // ),
                    // SwitchListTile(
                    //   value: isCountryCodeFixed,
                    //   onChanged: (v) => setState(() => isCountryCodeFixed = v),
                    //   title: Text('fixed country code'),
                    // ),
                    SwitchListTile(
                      value: required,
                      onChanged: (v) => setState(() => required = v),
                      title: Text('Required'),
                    ),
                    SwitchListTile(
                      value: mobileOnly,
                      onChanged: (v) => setState(() => mobileOnly = v),
                      title: Text('Mobile phone number only'),
                    ),
                    SwitchListTile(
                      value: shouldFormat,
                      onChanged: (v) => setState(() => shouldFormat = v),
                      title: Text('Should format'),
                    ),
                    ListTile(
                      title: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
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
                                child: Text('Draggable modal sheet'),
                                value:
                                    const DraggableModalBottomSheetNavigator(),
                              ),
                              DropdownMenuItem(
                                child: Text('Modal sheet'),
                                value: const ModalBottomSheetNavigator(),
                              ),
                              DropdownMenuItem(
                                child: Text('Dialog'),
                                value: const DialogNavigator(),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                        required: required,
                        mobileOnly: mobileOnly,
                        shouldFormat: shouldFormat,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(controller.value.toString()),
                    Text('is valid mobile number '
                        '${controller.value?.validate(type: PhoneNumberType.mobile) ?? 'false'}'),
                    Text(
                        'is valid fixed line number ${controller.value?.validate(type: PhoneNumberType.fixedLine) ?? 'false'}'),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: controller.value == null
                          ? null
                          : () => controller.reset(),
                      child: Text('reset'),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => controller.selectNationalNumber(),
                      child: Text('Select national number'),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () =>
                          controller.value = PhoneNumber.fromIsoCode(
                        'fr',
                        '699999999',
                      ),
                      child: Text('Set +33 699 999 999'),
                    ),
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
