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

  PhoneField({
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
  });

  @override
  _PhoneFieldState createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  /// size of input so we can render inkwell at correct height
  Size? _size;

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

  Widget build(BuildContext context) {
    // The idea here is to have an InputDecorat with a prefix where the prefix
    // is the flag + country code which visible (when focussed).
    // Then we stack an InkWell with the country code (invisible) so
    // it is the right width
    return Stack(
      children: [
        MeasureInitialSize(
          onSizeFound: (size) => setState(() => _size = size),
          child: _textField(),
        ),
        if (controller.focusNode.hasFocus || controller.national != null)
          _inkWellOverlay(),
      ],
    );
  }

  Widget _textField() {
    return TextField(
      focusNode: controller.focusNode,
      controller: controller.nationalController,
      enabled: widget.enabled,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(
            '[${Constants.PLUS}${Constants.DIGITS}${Constants.PUNCTUATION}]')),
      ],
      decoration: widget.decoration.copyWith(
        errorText: widget.errorText,
        prefix: _getDialCodeChip(),
      ),
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
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
    );
  }

  Widget _inkWellOverlay() {
    return InkWell(
      key: const ValueKey('country-code-overlay'),
      onTap: () {},
      onTapDown: (_) => selectCountry(),
      child: ConstrainedBox(
        // we set the size to input size
        constraints: BoxConstraints(
          minHeight: _size?.height ?? 0,
        ),
        child: Padding(
          // outline border has padding on the left
          // but only when prefixIcon is used
          // so we need to make it a 12 bigger
          padding: _isOutlineBorder
              ? const EdgeInsets.only(left: 12)
              : const EdgeInsets.all(0),
          child: _getDialCodeChip(visible: false),
        ),
      ),
    );
  }

  Widget _getDialCodeChip({bool visible = true}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: visible,
        child: CountryCodeChip(
          key: visible
              ? const ValueKey('country-code-chip')
              : const ValueKey('country-code-chip-hidden'),
          country: Country(controller.isoCode ?? controller.defaultIsoCode),
          showFlag: widget.showFlagInInput,
          textStyle: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.caption?.color,
          ),
          flagSize: widget.flagSize,
        ),
      ),
    );
  }
}
