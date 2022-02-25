import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/src/constants/constants.dart';
import 'package:phone_form_field/src/models/phone_field_controller.dart';
import 'package:phone_form_field/src/widgets/measure_initial_size.dart';

import '../../phone_form_field.dart';
import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

/// Phone field
///
/// This deals with mostly UI and has no dependency on any phone parser library
class PhoneField extends StatefulWidget {
  final PhoneFieldController controller;
  final bool showFlagInInput;
  final String? errorText;
  final double flagSize;
  final InputDecoration decoration;

  /// configures the way the country picker selector is shown
  final CountrySelectorNavigator selectorNavigator;

  // textfield inputs
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextStyle? countryCodeStyle;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool autofocus;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final ToolbarOptions? toolbarOptions;
  final bool? showCursor;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final bool? enabled;
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

  const PhoneField({
    // form field params
    Key? key,
    required this.controller,
    required this.showFlagInInput,
    required this.selectorNavigator,
    required this.flagSize,
    required this.errorText,
    required this.decoration,
    // textfield  inputs
    required this.keyboardType,
    required this.textInputAction,
    required this.style,
    required this.countryCodeStyle,
    required this.strutStyle,
    required this.textAlign,
    required this.textAlignVertical,
    required this.textDirection,
    required this.autofocus,
    required this.obscuringCharacter,
    required this.obscureText,
    required this.autocorrect,
    required this.smartDashesType,
    required this.smartQuotesType,
    required this.enableSuggestions,
    required this.toolbarOptions,
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
  }) : super(key: key);

  @override
  _PhoneFieldState createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  /// size of input so we can render inkwell at correct height
  Size? _sizeInput;
  Size? _countryCodeSize;

  bool get _isOutlineBorder => widget.decoration.border is OutlineInputBorder;
  PhoneFieldController get controller => widget.controller;

  _PhoneFieldState();

  @override
  void initState() {
    controller.focusNode.addListener(onFocusChange);
    super.initState();
  }

  void onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    controller.focusNode.removeListener(onFocusChange);
    super.dispose();
  }

  void selectCountry() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    final selected = await widget.selectorNavigator.navigate(context);
    if (selected != null) {
      controller.isoCode = selected.isoCode;
    }
    controller.focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  @override
  Widget build(BuildContext context) {
    // The idea here is to have an InputDecorat with a prefix where the prefix
    // is the flag + country code which visible (when focussed).
    // Then we stack an InkWell with the country code (invisible) so
    // it is the right width
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: Stack(
        children: [
          MeasureSize(
            onChange: (size) => setState(() => _sizeInput = size),
            child: GestureDetector(
              onTap: () => controller.focusNode.requestFocus(),
              child: _textField(),
            ),
          ),
          if (controller.focusNode.hasFocus || controller.national != null)
            _getInkWellOverlay(),
        ],
      ),
    );
  }

  Widget _textField() {
    return InputDecorator(
      decoration: _getOutterInputDecoration(),
      isFocused: controller.focusNode.hasFocus,
      isEmpty: _isEffectivelyEmpty(),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: controller.focusNode,
              controller: controller.nationalController,
              enabled: widget.enabled,
              decoration: _getInnerInputDecoration(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(
                    '[${Constants.plus}${Constants.digits}${Constants.punctuation}]')),
              ],
              autofillHints: widget.autofillHints,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              style: widget.style,
              strutStyle: widget.strutStyle,
              textAlign: widget.textAlign,
              textAlignVertical: widget.textAlignVertical,
              textDirection: widget.textDirection,
              autofocus: widget.autofocus,
              obscuringCharacter: widget.obscuringCharacter,
              obscureText: widget.obscureText,
              autocorrect: widget.autocorrect,
              smartDashesType: widget.smartDashesType,
              smartQuotesType: widget.smartQuotesType,
              enableSuggestions: widget.enableSuggestions,
              toolbarOptions: widget.toolbarOptions,
              showCursor: widget.showCursor,
              onEditingComplete: widget.onEditingComplete,
              onSubmitted: widget.onSubmitted,
              onAppPrivateCommand: widget.onAppPrivateCommand,
              cursorWidth: widget.cursorWidth,
              cursorHeight: widget.cursorHeight,
              cursorRadius: widget.cursorRadius,
              cursorColor: widget.cursorColor,
              selectionHeightStyle: widget.selectionHeightStyle,
              selectionWidthStyle: widget.selectionWidthStyle,
              keyboardAppearance: widget.keyboardAppearance,
              scrollPadding: widget.scrollPadding,
              enableInteractiveSelection: widget.enableInteractiveSelection,
              selectionControls: widget.selectionControls,
              mouseCursor: widget.mouseCursor,
              scrollController: widget.scrollController,
              scrollPhysics: widget.scrollPhysics,
              restorationId: widget.restorationId,
              enableIMEPersonalizedLearning:
                  widget.enableIMEPersonalizedLearning,
            ),
          ),
        ],
      ),
    );
  }

  /// gets the inkwell that is displayed on top of the input
  /// for feedback on country code click
  Widget _getInkWellOverlay() {
    // width and height calculation are a bit hacky but a better way
    // that works when the input is resized was not found
    var height = _sizeInput?.height ?? 0;
    var width = _countryCodeSize?.width ?? 0;
    // when there is an error the widget height contains the error
    // se we need to remove the error height
    if (widget.errorText != null) {
      height -= 20;
    }

    if (_isOutlineBorder) {
      // outline border adds padding to the left
      width += 12;
    }

    if (widget.decoration.prefixIconConstraints != null) {
      width += widget.decoration.prefixIconConstraints!.maxWidth;
    } else if (widget.decoration.prefixIcon != null) {
      // prefix icon default size is 48px
      width += 48;
    }

    return InkWell(
      key: const ValueKey('country-code-overlay'),
      onTap: () {},
      onTapDown: (_) => selectCountry(),
      child: SizedBox(
        height: height,
        width: width,
      ),
    );
  }

  Widget _getCountryCodeChip() {
    return MeasureSize(
      onChange: (size) => setState(() => _countryCodeSize = size),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: CountryCodeChip(
          key: const ValueKey('country-code-chip'),
          country: Country(controller.isoCode ?? controller.defaultIsoCode),
          showFlag: widget.showFlagInInput,
          textStyle: widget.countryCodeStyle ??
              widget.decoration.labelStyle ??
              TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.caption?.color,
          ),
          flagSize: widget.flagSize,
        ),
      ),
    );
  }

  InputDecoration _getInnerInputDecoration() {
    return InputDecoration.collapsed(
      hintText: widget.decoration.hintText,
    );
  }

  InputDecoration _getOutterInputDecoration() {
    return widget.decoration.copyWith(
      hintText: null,
      errorText: widget.errorText,
      prefix: _getCountryCodeChip(),
    );
  }

  bool _isEffectivelyEmpty() {
    final outterDecoration = _getOutterInputDecoration();
    // when there is not label and an hint text we need to have
    // isEmpty false so the country code is displayed along the
    // hint text to not have the hint text in the middle
    if (outterDecoration.label == null && outterDecoration.hintText != null) {
      return false;
    }
    return controller.nationalController.text.isEmpty;
  }
}
