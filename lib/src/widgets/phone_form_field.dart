import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/src/constants/constants.dart';
import 'package:phone_form_field/src/helpers/validator_translator.dart';
import 'package:phone_form_field/src/models/phone_field_controller.dart';
import 'package:phone_form_field/src/models/phone_controller.dart';
import 'package:phone_form_field/src/validator/phone_validator.dart';
import 'package:phone_form_field/src/widgets/phone_field.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'country_selector/country_selector_navigator.dart';
import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

part 'phone_form_field_state.dart';

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
  final ValueChanged<PhoneNumber?>? onChanged;

  /// country that is displayed when there is no value
  final IsoCode defaultCountry;

  /// the focusNode of the national number
  final FocusNode? focusNode;

  PhoneFormField({
    Key? key,
    this.controller,
    this.shouldFormat = true,
    this.onChanged,
    this.focusNode,
    bool showFlagInInput = true,
    CountrySelectorNavigator countrySelectorNavigator =
        const CountrySelectorNavigator.searchDelegate(),
    Function(PhoneNumber?)? onSaved,
    this.defaultCountry = IsoCode.US,
    InputDecoration decoration =
        const InputDecoration(border: UnderlineInputBorder()),
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    PhoneNumber? initialValue,
    double flagSize = 16,
    PhoneNumberInputValidator? validator,
    bool isCountrySelectionEnabled = true,
    bool isCountryChipPersistent = false,
    // textfield inputs
    TextInputType keyboardType = TextInputType.phone,
    TextInputAction? textInputAction,
    TextStyle? style,
    TextStyle? countryCodeStyle,
    StrutStyle? strutStyle,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    String obscuringCharacter = '*',
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    AppPrivateCommandCallback? onAppPrivateCommand,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    ui.BoxHeightStyle selectionHeightStyle = ui.BoxHeightStyle.tight,
    ui.BoxWidthStyle selectionWidthStyle = ui.BoxWidthStyle.tight,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    TextSelectionControls? selectionControls,
    MouseCursor? mouseCursor,
    ScrollPhysics? scrollPhysics,
    ScrollController? scrollController,
    Iterable<String>? autofillHints,
    String? restorationId,
    bool enableIMEPersonalizedLearning = true,
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
          validator: validator ?? PhoneValidator.valid(),
          restorationId: restorationId,
          builder: (state) {
            final field = state as PhoneFormFieldState;
            return PhoneField(
              controller: field._childController,
              showFlagInInput: showFlagInInput,
              selectorNavigator: countrySelectorNavigator,
              errorText: field.getErrorText(),
              flagSize: flagSize,
              decoration: decoration,
              enabled: enabled,
              isCountrySelectionEnabled: isCountrySelectionEnabled,
              isCountryChipPersistent: isCountryChipPersistent,
              // textfield params
              autofillHints: autofillHints,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              style: style,
              countryCodeStyle: countryCodeStyle,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textAlignVertical: textAlignVertical,
              autofocus: autofocus,
              obscuringCharacter: obscuringCharacter,
              obscureText: obscureText,
              autocorrect: autocorrect,
              smartDashesType: smartDashesType,
              smartQuotesType: smartQuotesType,
              enableSuggestions: enableSuggestions,
              toolbarOptions: toolbarOptions,
              showCursor: showCursor,
              onEditingComplete: onEditingComplete,
              onSubmitted: onSubmitted,
              onAppPrivateCommand: onAppPrivateCommand,
              cursorWidth: cursorWidth,
              cursorHeight: cursorHeight,
              cursorRadius: cursorRadius,
              cursorColor: cursorColor,
              selectionHeightStyle: selectionHeightStyle,
              selectionWidthStyle: selectionWidthStyle,
              keyboardAppearance: keyboardAppearance,
              scrollPadding: scrollPadding,
              enableInteractiveSelection: enableInteractiveSelection,
              selectionControls: selectionControls,
              mouseCursor: mouseCursor,
              scrollController: scrollController,
              scrollPhysics: scrollPhysics,
              restorationId: restorationId,
              enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
              inputFormatters: inputFormatters,
            );
          },
        );

  @override
  PhoneFormFieldState createState() => PhoneFormFieldState();
}
