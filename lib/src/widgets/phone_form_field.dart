import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/src/constants/constants.dart';
import 'package:phone_form_field/src/helpers/validator_translator.dart';
import 'package:phone_form_field/src/models/phone_controller.dart';
import 'package:phone_form_field/src/models/simple_phone_number.dart';
import 'package:phone_form_field/src/validator/phone_validator.dart';
import 'package:phone_form_field/src/widgets/phone_field.dart';
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
/// Therefor [onSizeFound] will still return a [PhoneNumber]
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

  /// callback called when the input value changes
  final Function(PhoneNumber?)? onChanged;

  PhoneFormField({
    Key? key,
    this.controller,
    this.shouldFormat = true,
    this.onChanged,
    List<String> autofillHints = const [],
    bool autofocus = false,
    bool enabled = true,
    bool showFlagInInput = true,
    CountrySelectorNavigator selectorNavigator = const BottomSheetNavigator(),
    Function(PhoneNumber?)? onSaved,
    String defaultCountry = 'US',
    InputDecoration decoration =
        const InputDecoration(border: UnderlineInputBorder()),
    Color? cursorColor,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    PhoneNumber? initialValue,
    double flagSize = 16,
    PhoneNumberInputValidator? validator,
    String? restorationId,
  })  : assert(
          initialValue == null || controller == null,
          'One of initialValue or controller can be specified at a time',
        ),
        super(
          key: key,
          autovalidateMode: AutovalidateMode.always,
          enabled: enabled,
          initialValue:
              controller != null ? controller.initialValue : initialValue,
          onSaved: onSaved,
          validator: validator ?? PhoneValidator.invalid(),
          restorationId: restorationId,
          builder: (state) {
            final field = state as _PhoneFormFieldState;
            return PhoneField(
              controller: field._childController,
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
              flagSize: flagSize,
            );
          },
        );

  @override
  _PhoneFormFieldState createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends FormFieldState<PhoneNumber> {
  late final PhoneController _controller;
  late final ValueNotifier<SimplePhoneNumber?> _childController;

  @override
  PhoneFormField get widget => super.widget as PhoneFormField;

  @override
  void initState() {
    super.initState();
    final simplePhoneNumber = _convertPhoneNumberToFormattedSimplePhone(value);
    _controller = widget.controller ?? PhoneController(value);
    _childController = ValueNotifier(simplePhoneNumber);
    _controller.addListener(_onControllerChange);
    _childController
        .addListener(() => _onChildControllerChange(_childController.value));
  }

  @override
  void dispose() {
    super.dispose();
    _childController.dispose();
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
  /// update the childController so the [PhoneField] which
  /// deals with the UI can display the correct value.
  void _onControllerChange() {
    final phone = _controller.value;
    final base = _childController.value;

    widget.onChanged?.call(phone);
    didChange(phone);
    final formatted = _convertPhoneNumberToFormattedSimplePhone(phone);
    if (base?.national != formatted?.national ||
        base?.isoCode != formatted?.isoCode) {
      _childController.value = formatted;
    }
  }

  /// when the base controller changes (when the user manually input something)
  /// then we need to update the local controller's value.
  void _onChildControllerChange(SimplePhoneNumber? simplePhone) {
    if (simplePhone?.national == _controller.value?.nsn &&
        simplePhone?.isoCode == _controller.value?.isoCode) {
      return;
    }
    if (simplePhone == null) {
      return _controller.value = null;
    }
    // we convert the simple phone number to a full blown PhoneNumber
    // to access validation, formatting etc.
    PhoneNumber phoneNumber;
    // when the base input change we check if its not a whole number
    // to allow for copy pasting and auto fill. If it is one then
    // we parse it accordingly
    if (simplePhone.national.startsWith(RegExp('[${Constants.PLUS}]'))) {
      // if starts with + then we parse the whole number
      // to figure out the country code
      final international = simplePhone.national;
      phoneNumber = PhoneNumber.fromRaw(international);
    } else {
      phoneNumber = PhoneNumber.fromNational(
        simplePhone.isoCode,
        simplePhone.national,
      );
    }
    _controller.value = phoneNumber;
  }

  /// converts the phone number value to a formatted value
  /// usable by the childController, The [PhoneField]
  /// which deals with the UI, will display that value
  SimplePhoneNumber? _convertPhoneNumberToFormattedSimplePhone(
      PhoneNumber? phoneNumber) {
    if (phoneNumber == null) return null;
    var formattedNsn = phoneNumber.nsn;
    if (widget.shouldFormat) {
      formattedNsn = phoneNumber.getFormattedNsn();
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
