import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/src/constants/patterns.dart';
import 'package:phone_form_field/src/controllers/phone_field_controller.dart';

import '../../phone_form_field.dart';

part 'phone_field_state.dart';

/// Phone field
///
/// This deals with mostly UI and has no dependency on any phone parser library
class PhoneField extends StatefulWidget {
  const PhoneField({
    // form field params
    Key? key,
    required this.controller,
    required this.showFlagInInput,
    required this.selectorNavigator,
    required this.flagSize,
    required this.errorText,
    required this.decoration,
    required this.isCountrySelectionEnabled,
    required this.isCountryChipPersistent,
    // textfield  inputs
    required this.keyboardType,
    required this.textInputAction,
    required this.style,
    required this.countryCodeStyle,
    required this.strutStyle,
    required this.textAlign,
    required this.textAlignVertical,
    required this.autofocus,
    required this.obscuringCharacter,
    required this.obscureText,
    required this.autocorrect,
    required this.smartDashesType,
    required this.smartQuotesType,
    required this.enableSuggestions,
    required this.contextMenuBuilder,
    required this.showCursor,
    required this.onEditingComplete,
    required this.onSubmitted,
    required this.onAppPrivateCommand,
    required this.enabled,
    required this.cursorWidth,
    required this.cursorHeight,
    required this.cursorRadius,
    required this.cursorColor,
    required this.selectionHeightStyle,
    required this.selectionWidthStyle,
    required this.keyboardAppearance,
    required this.scrollPadding,
    required this.enableInteractiveSelection,
    required this.selectionControls,
    required this.mouseCursor,
    required this.scrollPhysics,
    required this.scrollController,
    required this.autofillHints,
    required this.restorationId,
    required this.enableIMEPersonalizedLearning,
    required this.inputFormatters,
    required this.showDialCode,
    this.countryButtonSuffix,
    required this.showIsoCodeInInput,
  }) : super(key: key);

  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;
  final bool autocorrect;
  final Iterable<String>? autofillHints;
  final bool autofocus;
  final PhoneFieldController controller;
  final Widget? countryButtonSuffix;
  final TextStyle? countryCodeStyle;
  final Color? cursorColor;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final double cursorWidth;
  final InputDecoration decoration;
  final bool enableIMEPersonalizedLearning;
  final bool enableInteractiveSelection;
  final bool enableSuggestions;
  final bool? enabled;
  final String? errorText;
  final double flagSize;
  final List<TextInputFormatter>? inputFormatters;
  final bool isCountryChipPersistent;
  final bool isCountrySelectionEnabled;
  final Brightness? keyboardAppearance;
  // textfield inputs
  final TextInputType keyboardType;

  final MouseCursor? mouseCursor;
  final bool obscureText;
  final String obscuringCharacter;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final String? restorationId;
  final ScrollController? scrollController;
  final EdgeInsets scrollPadding;
  final ScrollPhysics? scrollPhysics;
  final TextSelectionControls? selectionControls;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;

  /// configures the way the country picker selector is shown
  final CountrySelectorNavigator selectorNavigator;

  final bool? showCursor;
  final bool showDialCode;
  final bool showFlagInInput;
  final bool showIsoCodeInInput;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final StrutStyle? strutStyle;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextInputAction? textInputAction;

  @override
  PhoneFieldState createState() => PhoneFieldState();

  bool get selectionEnabled => enableInteractiveSelection;
}
