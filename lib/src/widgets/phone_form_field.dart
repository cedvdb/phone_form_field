import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/src/constants/constants.dart';
import 'package:phone_form_field/src/helpers/validator_translator.dart';
import 'package:phone_form_field/src/models/phone_controller.dart';
import 'package:phone_form_field/src/models/simple_phone_number.dart';
import 'package:phone_form_field/src/validator/phone_validator.dart';
import 'package:phone_form_field/src/widgets/base_phone_form_field.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'country_picker/country_selector_navigator.dart';

class PhoneFormField extends FormField<PhoneNumber> {
  final PhoneController? controller;
  final List<String>? autofillHints;
  final bool shouldFormat;
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
    this.shouldFormat = true,
    this.autofillHints,
    this.autofocus = false,
    this.enabled = true,
    this.showFlagInInput = true,
    this.selectorNavigator = const BottomSheetNavigator(),
    this.onChanged,
    this.defaultCountry = 'US',
    this.decoration = const InputDecoration(border: UnderlineInputBorder()),
    this.cursorColor,
    PhoneNumberInputValidator? validator,
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
          validator: validator ?? PhoneValidator.invalid(),
          restorationId: restorationId,
          builder: (state) {
            final field = state as _PhoneFormFieldState;
            return BasePhoneFormField(
              controller: field._baseController,
              autoFillHints: autofillHints,
              onEditingComplete: () => TextInput.finishAutofillContext(),
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

  @override
  _PhoneFormFieldState createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends FormFieldState<PhoneNumber> {
  late final PhoneParser _parser;
  late final PhoneController _controller;
  late final ValueNotifier<SimplePhoneNumber?> _baseController;

  @override
  PhoneFormField get widget => super.widget as PhoneFormField;

  @override
  void initState() {
    super.initState();
    final simplePhoneNumber = _convertPhoneNumberToFormattedSimplePhone(value);
    _parser = PhoneParser();
    _controller = widget.controller ?? PhoneController(value);
    _baseController = ValueNotifier(simplePhoneNumber);
    _controller.addListener(_onControllerChange);
    _baseController
        .addListener(() => _onBaseControllerChange(_baseController.value));
  }

  @override
  void dispose() {
    super.dispose();
    _baseController.dispose();
    // dispose the controller only when it's initialised in this instance
    // otherwise this should be done where instance is created
    if (widget.controller == null) {
      _controller.dispose();
    }
  }

  @override
  void reset() {
    _controller.value = widget.initialValue;
    super.reset();
  }

  void _onControllerChange() {
    final phone = _controller.value;
    final base = _baseController.value;

    widget.onChanged?.call(phone);
    didChange(phone);
    final formatted = _convertPhoneNumberToFormattedSimplePhone(phone);
    if (base?.national != formatted?.national ||
        base?.isoCode != formatted?.isoCode) {
      _baseController.value = formatted;
    }
  }

  void _onBaseControllerChange(SimplePhoneNumber? basePhone) {
    if (basePhone?.national == _controller.value?.nsn &&
        basePhone?.isoCode == _controller.value?.isoCode) {
      return;
    }
    if (basePhone == null) {
      return _controller.value = null;
    }
    // we convert the simple phone number to a full blown PhoneNumber
    // to access validation, formatting etc.
    PhoneNumber phoneNumber;
    // when the base input change we check if its not a whole number
    // to allow for copy pasting and auto fill. If it is one then
    // we parse it accordingly
    if (basePhone.national.startsWith(RegExp('[${Constants.PLUS}]'))) {
      // if starts with + then we parse the whole number
      // to figure out the country code
      phoneNumber = _parser.parseRaw(basePhone.national);
    } else {
      phoneNumber = _parser.parseNational(
        basePhone.isoCode,
        basePhone.national,
      );
    }
    _controller.value = phoneNumber;
  }

  SimplePhoneNumber? _convertPhoneNumberToFormattedSimplePhone(
      PhoneNumber? phoneNumber) {
    if (phoneNumber == null) return null;
    var formattedNsn = phoneNumber.nsn;
    if (widget.shouldFormat) {
      PhoneNumberFormatter formatter = PhoneNumberFormatter();
      formattedNsn = formatter.formatNsn(phoneNumber);
    }
    return SimplePhoneNumber(
      isoCode: phoneNumber.isoCode,
      national: formattedNsn,
    );
  }

  String? getErrorText() {
    if (errorText != null) {
      return ValidatorTranslator.message(context, errorText!);
    }
  }
}
