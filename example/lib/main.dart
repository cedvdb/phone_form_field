import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  runApp(const MyApp());
}

// this example makes uses of lots of properties that would not be there
// in a real scenario for the sake of showing the features.
// For a simpler example see the README

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
        autofillHints: const [AutofillHints.telephoneNumber],
        countrySelectorNavigator: selectorNavigator,
        defaultCountry: 'FR',
        decoration: InputDecoration(
          label: withLabel ? const Text('Phone') : null,
          border: outlineBorder
              ? const OutlineInputBorder()
              : const UnderlineInputBorder(),
        ),
        enabled: true,
        showFlagInInput: true,
        validator: _getValidator(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: Theme.of(context).colorScheme.primary,
        // ignore: avoid_print
        onSaved: (p) => print('saved $p'),
        // ignore: avoid_print
        onChanged: (p) => print('changed $p'),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        ...GlobalMaterialLocalizations.delegates,
        PhoneFieldLocalization.delegate
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('de', ''),
        Locale('fr', ''),
        Locale('it', ''),
        Locale('ru', ''),
        // ...
      ],
      title: 'Phone field demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: const PhoneFormFieldScreen(),
    );
  }
}

class PhoneFormFieldScreen extends StatefulWidget {
  const PhoneFormFieldScreen({Key? key}) : super(key: key);

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
  CountrySelectorNavigator selectorNavigator =
      const CountrySelectorNavigator.bottomSheet();
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
        title: const Text('Phone_form_field'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: outlineBorder,
                      onChanged: (v) => setState(() => outlineBorder = v),
                      title: const Text('Outlined border'),
                    ),
                    SwitchListTile(
                      value: withLabel,
                      onChanged: (v) => setState(() => withLabel = v),
                      title: const Text('Label'),
                    ),
                    SwitchListTile(
                      value: required,
                      onChanged: (v) => setState(() => required = v),
                      title: const Text('Required'),
                    ),
                    SwitchListTile(
                      value: mobileOnly,
                      onChanged: (v) => setState(() => mobileOnly = v),
                      title: const Text('Mobile phone number only'),
                    ),
                    SwitchListTile(
                      value: shouldFormat,
                      onChanged: (v) => setState(() => shouldFormat = v),
                      title: const Text('Should format'),
                    ),
                    ListTile(
                      title: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text('Country selector: '),
                          DropdownButton<CountrySelectorNavigator>(
                            value: selectorNavigator,
                            onChanged: (CountrySelectorNavigator? value) {
                              if (value != null) {
                                setState(() => selectorNavigator = value);
                              }
                            },
                            items: const [
                              DropdownMenuItem(
                                child: Text('Bottom sheet'),
                                value: CountrySelectorNavigator.bottomSheet(),
                              ),
                              DropdownMenuItem(
                                child: Text('Draggable modal sheet'),
                                value: CountrySelectorNavigator
                                    .draggableBottomSheet(),
                              ),
                              DropdownMenuItem(
                                child: Text('Modal sheet'),
                                value:
                                    CountrySelectorNavigator.modalBottomSheet(
                                  favorites: ['BE', 'FR'],
                                ),
                              ),
                              DropdownMenuItem(
                                child: Text('Dialog'),
                                value: CountrySelectorNavigator.dialog(),
                              ),
                              DropdownMenuItem(
                                child: Text('Page'),
                                value: CountrySelectorNavigator.page(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
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
                    const SizedBox(height: 12),
                    Text(controller.value.toString()),
                    Text('is valid mobile number '
                        '${controller.value?.validate(type: PhoneNumberType.mobile) ?? 'false'}'),
                    Text(
                        'is valid fixed line number ${controller.value?.validate(type: PhoneNumberType.fixedLine) ?? 'false'}'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: controller.value == null
                          ? null
                          : () => controller.reset(),
                      child: const Text('reset'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => controller.selectNationalNumber(),
                      child: const Text('Select national number'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () =>
                          controller.value = PhoneNumber.fromIsoCode(
                        'fr',
                        '699999999',
                      ),
                      child: const Text('Set +33 699 999 999'),
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
