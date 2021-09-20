import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization.dart';
import 'package:phone_form_field/src/models/phone_controller.dart';
import 'package:phone_form_field/src/models/simple_phone_number.dart';
import 'package:phone_form_field/src/widgets/base_phone_form_field.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'country_picker/country_selector_navigator.dart';

class PhoneFormField extends FormField<PhoneNumber> {
  final PhoneController? controller;
  final String? errorText;
  final PhoneNumberType? phoneNumberType;
  final bool withHint;
  final bool enabled;
  final bool autofocus;
  final bool showFlagInInput;
  final String defaultCountry;
  final CountrySelectorNavigator selectorNavigator;
  final Function(PhoneNumber?)? onChanged;
  final InputDecoration decoration;
  final Color? cursorColor;

  PhoneFormField({
    Key? key,
    this.controller,
    this.phoneNumberType,
    this.errorText = 'Invalid phone number',
    this.withHint = true,
    this.autofocus = false,
    this.enabled = true,
    this.showFlagInInput = true,
    this.selectorNavigator = const BottomSheetNavigator(),
    this.onChanged,
    this.defaultCountry = 'US',
    this.decoration = const InputDecoration(border: UnderlineInputBorder()),
    this.cursorColor,
    Function(PhoneNumber?)? onSaved,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    PhoneNumber? initialValue,
    String? restorationId,
  })  : assert(
          initialValue == null || controller == null,
          'One of initialValue or controller can be specified at a time',
        ),
        super(
          key: key,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          initialValue:
              controller != null ? controller.initialValue : initialValue,
          onSaved: onSaved,
          validator:
              _getDefaultValidator(type: phoneNumberType, errorText: errorText),
          restorationId: restorationId,
          builder: (state) {
            final field = state as _PhoneFormFieldState;
            return BasePhoneFormField(
              controller: field.baseController,
              autoFillHints: withHint ? [AutofillHints.telephoneNumber] : null,
              onEditingComplete:
                  withHint ? () => TextInput.finishAutofillContext() : null,
              enabled: enabled,
              showFlagInInput: showFlagInInput,
              decoration: decoration,
              autofocus: autofocus,
              defaultCountry: defaultCountry,
              selectorNavigator: selectorNavigator,
              cursorColor: cursorColor,
              errorText: field.getErrorText(),
            );
          },
        );

  static _getDefaultValidator({
    required PhoneNumberType? type,
    required String? errorText,
  }) {
    final parser = PhoneParser();
    return (PhoneNumber? phoneNumber) {
      if (phoneNumber == null) return null;
      if (phoneNumber.nsn.isEmpty) return null;
      final isValid = parser.validate(phoneNumber, type);
      if (!isValid) return errorText;
    };
  }

  @override
  _PhoneFormFieldState createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends FormFieldState<PhoneNumber> {
  late final BasePhoneParser parser;
  late final PhoneController controller;
  late final ValueNotifier<SimplePhoneNumber?> baseController;

  @override
  PhoneFormField get widget => super.widget as PhoneFormField;

  @override
  void initState() {
    super.initState();
    final simplePhoneNumber = _convertPhoneNumberToSimplePhoneNumber(value);
    parser = PhoneParser();
    controller = widget.controller ?? PhoneController(value);
    baseController = ValueNotifier(simplePhoneNumber);
    controller.addListener(_onControllerChange);
    baseController
        .addListener(() => _onBaseControllerChange(baseController.value));
  }

  @override
  void dispose() {
    super.dispose();
    baseController.dispose();
    // dispose the controller only when it's initialised in this instance
    // otherwise this should be done where instance is created
    if (widget.controller == null) {
      controller.dispose();
    }
  }

  @override
  void reset() {
    controller.value = widget.initialValue;
    super.reset();
  }

  void _onControllerChange() {
    final basePhone = baseController.value;
    final phone = controller.value;
    widget.onChanged?.call(controller.value);
    didChange(phone);
    if (basePhone?.national == phone?.nsn &&
        basePhone?.isoCode == phone?.isoCode) {
      return;
    }
    baseController.value = _convertPhoneNumberToSimplePhoneNumber(phone);
  }

  void _onBaseControllerChange(SimplePhoneNumber? basePhone) {
    if (basePhone?.national == controller.value?.nsn &&
        basePhone?.isoCode == controller.value?.isoCode) {
      return;
    }
    if (basePhone == null) {
      return controller.value = null;
    }
    // we convert the simple phone number to a full blown PhoneNumber
    // to access validation, formatting etc.
    PhoneNumber phoneNumber;
    // when the base input change we check if its not a whole number
    // to allow for copy pasting and auto fill. If it is one then
    // we parse it accordingly
    if (basePhone.national.startsWith(RegExp('[+＋]'))) {
      // if starts with + then we parse the whole number
      // to figure out the country code
      phoneNumber = parser.parseRaw(basePhone.national);
    } else {
      phoneNumber = parser.parseWithIsoCode(
        basePhone.isoCode,
        basePhone.national,
      );
    }
    controller.value = phoneNumber;
    baseController.value = SimplePhoneNumber(
      isoCode: phoneNumber.isoCode,
      national: phoneNumber.nsn,
    );
  }

  SimplePhoneNumber? _convertPhoneNumberToSimplePhoneNumber(
      PhoneNumber? phoneNumber) {
    if (phoneNumber == null) return null;
    return SimplePhoneNumber(
        isoCode: phoneNumber.isoCode, national: phoneNumber.nsn);
  }

  String? getErrorText() {
    if (!hasError) {
      return null;
    }
    if (widget.errorText != null) {
      return widget.errorText;
    }
    return PhoneFieldLocalization.of(context)?.invalidPhoneNumber ??
        'Invalid Phone Number';
  }
}
