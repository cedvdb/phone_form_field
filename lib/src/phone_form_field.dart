import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/src/validation/allowed_characters.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'country/country_button.dart';
import 'country_selection/country_selector_navigator.dart';
import 'validation/phone_validator.dart';

part 'phone_controller.dart';
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
class PhoneFormField extends StatefulWidget {
  /// {@macro controller}
  final PhoneController? controller;

  /// {@macro initialValue}
  final PhoneNumber? initialValue;

  /// Validator for the phone number.
  /// example: PhoneValidator.validType(expectedType: PhoneNumberType.mobile)
  final PhoneNumberInputValidator validator;

  final bool shouldFormat;

  /// callback called when the input value changes
  final Function(PhoneNumber)? onChanged;

  /// country that is displayed when there is no value
  final IsoCode defaultCountry;

  /// the focusNode of the national number
  final FocusNode? focusNode;

  /// whether the input is enabled
  final bool enabled;

  /// how to display the country selection
  final CountrySelectorNavigator countrySelectorNavigator;

  /// padding inside country button,
  /// this can be used to align the country button with the phone number
  /// and is mostly useful when using [isCountryButtonPersistent] as true.
  final EdgeInsets? countryButtonPadding;

  /// whether the user can select a new country when pressing the country button
  final bool isCountrySelectionEnabled;

  /// This controls wether the country button is alway shown or is hidden by
  /// the label when the national number is empty. In flutter terms this controls
  /// whether the country button is shown as a prefix or prefixIcon inside
  /// the text field.
  final bool isCountryButtonPersistent;

  /// show Dial Code or not in the country button
  final bool showDialCode;

  /// show selected iso code or not in the country button
  final bool showIsoCodeInInput;

  /// The size of the flag inside the country button
  final double flagSize;

  /// whether the flag is shown inside the country button
  final bool showFlagInInput;

  // form field inputs
  final AutovalidateMode autovalidateMode;
  final Function(PhoneNumber?)? onSaved;

  // textfield inputs
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextStyle? countryCodeStyle;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;
  final bool? showCursor;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final Function(PointerDownEvent)? onTapOutside;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  bool get selectionEnabled => enableInteractiveSelection;
  final MouseCursor? mouseCursor;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final Iterable<String>? autofillHints;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;
  final List<TextInputFormatter>? inputFormatters;

  PhoneFormField({
    super.key,
    this.controller,
    @Deprecated('This is now always true and has no effect anymore')
    this.shouldFormat = true,
    this.onChanged,
    this.focusNode,
    this.showFlagInInput = true,
    this.countrySelectorNavigator = const CountrySelectorNavigator.page(),
    @Deprecated(
        'Use [initialValue] or [controller] to set the initial phone number')
    this.defaultCountry = IsoCode.US,
    this.initialValue,
    this.flagSize = 16,
    PhoneNumberInputValidator? validator,
    this.isCountrySelectionEnabled = true,
    bool? isCountryButtonPersistent,
    @Deprecated('Use [isCountryButtonPersistent]')
    bool? isCountryChipPersistent,
    this.showDialCode = true,
    this.showIsoCodeInInput = false,
    this.countryButtonPadding,
    // form field inputs
    this.onSaved,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    // textfield inputs
    this.decoration = const InputDecoration(),
    this.keyboardType = TextInputType.phone,
    this.textInputAction,
    this.style,
    this.countryCodeStyle,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.obscuringCharacter = '*',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.contextMenuBuilder,
    this.showCursor,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.onTapOutside,
    this.inputFormatters,
    this.enabled = true,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.mouseCursor,
    this.scrollPhysics,
    this.scrollController,
    this.autofillHints,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
  })  : assert(
          initialValue == null || controller == null,
          'One of initialValue or controller can be specified at a time',
        ),
        validator = validator ?? PhoneValidator.valid(),
        isCountryButtonPersistent =
            isCountryButtonPersistent ?? isCountryChipPersistent ?? true;

  @override
  PhoneFormFieldState createState() => PhoneFormFieldState();
}
