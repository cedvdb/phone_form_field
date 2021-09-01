import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/models/phone_number_input.dart';
import 'package:phone_form_field/src/validator/phone_validator.dart';
import 'package:phone_form_field/src/widgets/base_phone_form_field.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

typedef PhoneController = ValueNotifier<PhoneNumber?>;

class PhoneFormField extends StatefulWidget {
  final PhoneNumber? initialValue;
  final PhoneController? controller;
  final bool withHint;
  final bool enabled;
  final bool autofocus;
  final bool showFlagInInput;
  final String defaultCountry;
  final CountrySelectorNavigator selectorNavigator;
  final Function(PhoneNumber?)? onChanged;
  final Function(PhoneNumber?)? onSaved;
  final InputDecoration decoration;
  final AutovalidateMode autovalidateMode;
  final bool lightParser;
  final PhoneNumberInputValidator? validator;

  PhoneFormField({
    Key? key,
    this.initialValue,
    this.controller,
    this.withHint = true,
    this.autofocus = false,
    this.enabled = true,
    this.showFlagInInput = true,
    this.selectorNavigator = const BottomSheetNavigator(),
    this.onChanged,
    this.onSaved,
    this.defaultCountry = 'US',
    this.decoration = const InputDecoration(border: UnderlineInputBorder()),
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.lightParser = false,
    this.validator,
  }) : super(key: key);

  @override
  _PhoneFormFieldState createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends State<PhoneFormField> {
  late final BasePhoneParser parser;
  late final PhoneController controller;
  late final ValueNotifier<PhoneNumberInput?> baseController;

  @override
  void initState() {
    super.initState();
    parser = widget.lightParser ? LightPhoneParser() : PhoneParser();
    controller = widget.controller ?? PhoneController(widget.initialValue);
    baseController = ValueNotifier(null);
    baseController
        .addListener(() => _onBaseControllerChange(baseController.value));
    controller.addListener(_onControllerChange);
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

  void _onControllerChange() {
    final phoneInput = baseController.value;
    final phone = controller.value;
    widget.onChanged?.call(controller.value);
    if (phoneInput?.national == phone?.nsn &&
        phoneInput?.isoCode == phone?.isoCode) {
      return;
    }
    baseController.value = _convertPhoneNumberToPhoneNumberInput(phone);
  }

  void _onBaseControllerChange(PhoneNumberInput? phoneInput) {
    if (phoneInput?.national == controller.value?.nsn &&
        phoneInput?.isoCode == controller.value?.isoCode) {
      return;
    }
    if (phoneInput == null) {
      return controller.value = null;
    }
    // we convert the simple phone number to a full blown phone number
    PhoneNumber phoneNumber;
    // when the base input change we check if its not a whole number
    // to allow for copy pasting and auto fill. If it is one then
    // we parse it accordingly
    if (phoneInput.national.startsWith(RegExp('[+＋]'))) {
      // if starts with + then we parse the whole number
      phoneNumber = parser.parseRaw(phoneInput.national);
    } else {
      phoneNumber = parser.parseWithIsoCode(
        phoneInput.isoCode,
        phoneInput.national,
      );
    }
    controller.value = phoneNumber;
    baseController.value = PhoneNumberInput(
        isoCode: phoneNumber.isoCode, national: phoneNumber.nsn);
  }

  PhoneNumberInput? _convertPhoneNumberToPhoneNumberInput(
      PhoneNumber? phoneNumber) {
    if (phoneNumber == null) return null;
    return PhoneNumberInput(
        isoCode: phoneNumber.isoCode, national: phoneNumber.nsn);
  }

  PhoneNumber? _convertInputToPhoneNumber(PhoneNumberInput? phoneNumberInput) {
    if (phoneNumberInput == null) return null;
    return PhoneNumber(
        isoCode: phoneNumberInput.isoCode, nsn: phoneNumberInput.national);
  }

  String? _validate(PhoneNumberInput? phoneNumberInput) {
    final validator = widget.validator ?? PhoneValidator.invalid(context);
    final phoneNumber = _convertInputToPhoneNumber(phoneNumberInput);
    return validator.call(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return BasePhoneFormField(
      controller: baseController,
      validator: _validate,
      initialValue: _convertPhoneNumberToPhoneNumberInput(widget.initialValue),
      onChanged: _onBaseControllerChange,
      onSaved: (inp) => widget.onSaved?.call(_convertInputToPhoneNumber(inp)),
      autoFillHints: widget.withHint ? [AutofillHints.telephoneNumber] : null,
      onEditingComplete:
          widget.withHint ? () => TextInput.finishAutofillContext() : null,
      enabled: widget.enabled,
      showFlagInInput: widget.showFlagInInput,
      autovalidateMode: widget.autovalidateMode,
      decoration: widget.decoration,
      autofocus: widget.autofocus,
      defaultCountry: widget.defaultCountry,
      selectorNavigator: widget.selectorNavigator,
    );
  }
}
