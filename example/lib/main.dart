import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  runApp(const MyApp());
}

// this example makes uses of lots of properties that would not be there
// in a real scenario for the sake of showing the features.
// For a simpler example see the README

class PhoneFieldView extends StatelessWidget {
  final PhoneController controller;
  final FocusNode focusNode;
  final CountrySelectorNavigator selectorNavigator;
  final bool withLabel;
  final bool outlineBorder;
  final bool isCountryButtonPersistant;
  final bool mobileOnly;
  final bool useRtl;

  const PhoneFieldView({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.selectorNavigator,
    required this.withLabel,
    required this.outlineBorder,
    required this.isCountryButtonPersistant,
    required this.mobileOnly,
    required this.useRtl,
  }) : super(key: key);

  PhoneNumberInputValidator? _getValidator(BuildContext context) {
    List<PhoneNumberInputValidator> validators = [];
    if (mobileOnly) {
      validators.add(PhoneValidator.validMobile(context));
    } else {
      validators.add(PhoneValidator.valid(context));
    }
    return validators.isNotEmpty ? PhoneValidator.compose(validators) : null;
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Directionality(
        textDirection: useRtl ? TextDirection.rtl : TextDirection.ltr,
        child: PhoneFormField(
          focusNode: focusNode,
          controller: controller,
          isCountryButtonPersistent: isCountryButtonPersistant,
          autofocus: false,
          autofillHints: const [AutofillHints.telephoneNumber],
          countrySelectorNavigator: selectorNavigator,
          decoration: InputDecoration(
            label: withLabel ? const Text('Phone') : null,
            border: outlineBorder
                ? const OutlineInputBorder()
                : const UnderlineInputBorder(),
            hintText: withLabel ? '' : 'Phone',
          ),
          enabled: true,
          countryButtonStyle: const CountryButtonStyle(
            showFlag: true,
            showIsoCode: false,
            showDialCode: true,
            showDropdownIcon: true,
          ),
          validator: _getValidator(context),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: Theme.of(context).colorScheme.primary,
          // ignore: avoid_print
          onSaved: (p) => print('saved $p'),
          // ignore: avoid_print
          onChanged: (p) => print('changed $p'),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: PhoneFieldLocalization.delegates,
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
        Locale('es', ''),
        Locale('el', ''),
        Locale('de', ''),
        Locale('it', ''),
        Locale('ru', ''),
        Locale('sv', ''),
        Locale('tr', ''),
        Locale('zh', ''),
        // ...
      ],
      title: 'Phone field demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const PhoneFormFieldScreen(),
    );
  }
}

class PhoneFormFieldScreen extends StatefulWidget {
  const PhoneFormFieldScreen({Key? key}) : super(key: key);

  @override
  PhoneFormFieldScreenState createState() => PhoneFormFieldScreenState();
}

class PhoneFormFieldScreenState extends State<PhoneFormFieldScreen> {
  late PhoneController controller;
  final FocusNode focusNode = FocusNode();

  bool outlineBorder = true;
  bool mobileOnly = true;
  bool isCountryButtonPersistent = true;
  bool withLabel = true;
  bool useRtl = false;
  CountrySelectorNavigator selectorNavigator =
      const CountrySelectorNavigator.page();
  final formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    controller = PhoneController();
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
                      value: isCountryButtonPersistent,
                      onChanged: (v) =>
                          setState(() => isCountryButtonPersistent = v),
                      title: const Text('Persistent country chip'),
                    ),
                    SwitchListTile(
                      value: mobileOnly,
                      onChanged: (v) => setState(() => mobileOnly = v),
                      title: const Text('Mobile phone number only'),
                    ),
                    SwitchListTile(
                      value: useRtl,
                      onChanged: (v) {
                        setState(() => useRtl = v);
                      },
                      title: const Text('RTL'),
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
                                value: CountrySelectorNavigator.bottomSheet(
                                    favorites: [IsoCode.GU, IsoCode.GY]),
                                child: Text('Bottom sheet'),
                              ),
                              DropdownMenuItem(
                                value: CountrySelectorNavigator
                                    .draggableBottomSheet(),
                                child: Text('Draggable modal sheet'),
                              ),
                              DropdownMenuItem(
                                value:
                                    CountrySelectorNavigator.modalBottomSheet(),
                                child: Text('Modal sheet'),
                              ),
                              DropdownMenuItem(
                                value: CountrySelectorNavigator.dialog(
                                  width: 720,
                                ),
                                child: Text('Dialog'),
                              ),
                              DropdownMenuItem(
                                value: CountrySelectorNavigator.page(),
                                child: Text('Page'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          PhoneFieldView(
                            controller: controller,
                            focusNode: focusNode,
                            selectorNavigator: selectorNavigator,
                            withLabel: withLabel,
                            outlineBorder: outlineBorder,
                            isCountryButtonPersistant:
                                isCountryButtonPersistent,
                            mobileOnly: mobileOnly,
                            useRtl: useRtl,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(controller.value.toString()),
                    Text('is valid mobile number '
                        '${controller.value.isValid(type: PhoneNumberType.mobile)}'),
                    Text(
                        'is valid fixed line number ${controller.value.isValid(type: PhoneNumberType.fixedLine)}'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => formKey.currentState?.reset(),
                      child: const Text('reset'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        controller.selectNationalNumber();
                        focusNode.requestFocus();
                      },
                      child: const Text('Select national number'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => controller.value =
                          PhoneNumber.parse('+33 699 999 999'),
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
