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

/// Phone input extending form field.
///
/// ### controller:
/// {@template controller}
/// Use a [PhoneController] for PhoneFormField when you need to dynamically
/// change the value.
///
/// Whenever the user modifies the phone field with an
/// associated [controller], the phone field updates
/// the display value and the controller notifies its listeners.
/// {@endtemplate}
///
/// You can also use an [initialValue]:
/// {@template initialValue}
/// The initial value used.
///
/// Only one of [initialValue] and [controller] can be specified.
/// If [controller] is specified the [initialValue] will be
/// the first value of the [PhoneController]
/// {@endtemplate}
///
/// ### formatting:
/// {@template shouldFormat}
/// Specify whether the field will format the national number with [shouldFormat] = true (default)
/// eg: +33677784455 will be displayed as +33 6 77 78 44 55.
///
/// The formats are localized for the country code.
/// eg: +1 677-784-455 & +33 6 77 78 44 55
///
///
/// This does not affect the output value, only the display.
/// Therefor [onChange] will still return a [PhoneNumber]
/// with nsn of 677784455.
/// {@endtemplate}
///
/// ### phoneNumberType:
/// {@template phoneNumberType}
/// specify the type of phone number with [phoneNumberType].
///
/// accepted values are:
///   - null (can be mobile or fixedLine)
///   - mobile
///   - fixedLine
/// {@endtemplate}
///
///
/// ### Country picker:
///
/// {@template selectorNavigator}
/// specify which type of country selector will be shown with [selectorNavigator].
///
/// Uses one of:
///  - const BottomSheetNavigator()
///  - const DraggableModalBottomSheetNavigator()
///  - const ModalBottomSheetNavigator()
///  - const DialogNavigator()
/// {@endtemplate}
///
/// ### Country Code visibility:
///
/// The country dial code will be visible when:
/// - the field is focussed.
/// - the field has a value for national number.
/// - the field has no label obstructing the view.
class PhoneFormField extends FormField<PhoneNumber> {
  /// {@macro controller}
  final PhoneController? controller;

  /// {@macro shouldFormat}
  final bool shouldFormat;

  /// {@macro selectorNavigator}
  final CountrySelectorNavigator selectorNavigator;

  // The properties below this line are not used by this widget and
  // only passed around to child or super.Those are kept here for
  // adding documentation

  /// {@macro flutter.widgets.editableText.autofillHints}
  /// {@macro flutter.services.AutofillConfiguration.autofillHints}
  final List<String>? autofillHints;

  /// whether this form field is enabled
  final bool enabled;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// whether a flag is shown next to the dial code
  final bool showFlagInInput;

  /// the default country used when the input is displayed for the first time
  final String defaultCountry;

  /// triggered when the value changes
  final Function(PhoneNumber?)? onChanged;

  /// triggered when the form is saved via FormState.save.
  final Function(PhoneNumber?)? onSaved;

  /// Used to configure the auto validation of FormField and Form widgets.
  final AutovalidateMode autovalidateMode;

  /// the [InputDecoration] used by this PhoneFormField
  final InputDecoration decoration;

  /// the color of the cursor in the text input
  final Color? cursorColor;

  /// {@macro initialValue}
  final PhoneNumber? initialValue;

  PhoneFormField({
    Key? key,
    this.controller,
    this.shouldFormat = true,
    this.autofillHints = const [],
    this.autofocus = false,
    this.enabled = true,
    this.showFlagInInput = true,
    this.selectorNavigator = const BottomSheetNavigator(),
    this.onChanged,
    this.onSaved,
    this.defaultCountry = 'US',
    this.decoration = const InputDecoration(border: UnderlineInputBorder()),
    this.cursorColor,
    PhoneNumberInputValidator? validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.initialValue,
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

  /// when the controller changes this function will
  /// update the baseController so the [BasePhoneFormField] which
  /// deals with the UI can display the correct value.
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

  /// when the base controller changes (when the user manually input something)
  /// then we need to update the local controller's value.
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

  /// converts the phone number value to a formatted value
  /// usable by the baseController, The [BasePhoneFormField]
  /// which deals with the UI, will display that value
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

  /// gets the localized error text if any
  String? getErrorText() {
    if (errorText != null) {
      return ValidatorTranslator.message(context, errorText!);
    }
  }
}
