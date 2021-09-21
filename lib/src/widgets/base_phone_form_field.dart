import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/src/constants/constants.dart';
import 'package:phone_form_field/src/models/simple_phone_number.dart';

import '../../phone_form_field.dart';
import '../models/country.dart';
import 'country_picker/country_selector_navigator.dart';
import 'country_code_chip.dart';

/// That is the base for the PhoneFormField
///
/// This deals with mostly UI and has no dependency on any phone parser library
class BasePhoneFormField extends StatefulWidget {
  final ValueNotifier<SimplePhoneNumber?> controller;
  final String defaultCountry;
  final bool autofocus;
  final bool showFlagInInput;
  final bool? enabled;
  final String? errorText;

  /// input decoration applied to the input
  final InputDecoration decoration;
  final Color? cursorColor;
  final Iterable<String>? autoFillHints;
  final Function()? onEditingComplete;

  /// configures the way the country picker selector is shown
  final CountrySelectorNavigator selectorNavigator;

  BasePhoneFormField({
    // form field params
    Key? key,
    required this.controller,
    required this.autoFillHints,
    required this.enabled,
    required this.defaultCountry,
    required this.autofocus,
    required this.showFlagInInput,
    required this.onEditingComplete,
    required this.errorText,
    required this.decoration,
    required this.cursorColor,
    required this.selectorNavigator,
  });

  @override
  _BasePhoneFormFieldState createState() => _BasePhoneFormFieldState();
}

class _BasePhoneFormFieldState extends State<BasePhoneFormField> {
  final FocusNode _focusNode = FocusNode();

  /// this is the controller for the national phone number
  late TextEditingController _nationalNumberController;

  bool get _isOutlineBorder => widget.decoration.border is OutlineInputBorder;
  SimplePhoneNumber? get value => widget.controller.value;
  String get _isoCode => value?.isoCode ?? widget.defaultCountry;

  _BasePhoneFormFieldState();

  @override
  void initState() {
    _nationalNumberController = TextEditingController(text: value?.national);
    widget.controller.addListener(() => _updateValue(widget.controller.value));
    _focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  /// to update the current value of the input
  void _updateValue(SimplePhoneNumber? phoneNumber) async {
    final national = phoneNumber?.national ?? '';
    // if the national number has changed from outside we need to update
    // the controller value
    if (national != _nationalNumberController.text) {
      // we need to use a future here because when resetting
      // there is a race condition between the focus out event (clicking on reset)
      // which updates the value to the current one without text selection
      // and the actual reset
      await Future.value();
      _nationalNumberController.value = TextEditingValue(
        text: national,
        selection: TextSelection.fromPosition(
          TextPosition(offset: national.length),
        ),
      );
    }
    // when updating from within
    if (widget.controller.value != phoneNumber) {
      widget.controller.value = phoneNumber;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _nationalNumberController.dispose();
    super.dispose();
  }

  void selectCountry() async {
    final selected = await widget.selectorNavigator.navigate(context);
    if (selected != null) {
      _updateValue(SimplePhoneNumber(
          isoCode: selected.isoCode, national: value?.national ?? ''));
    }
    _focusNode.requestFocus();
  }

  Widget build(BuildContext context) {
    // the idea here is to have a TextField with a prefix where the prefix
    // is the flag + country code which invisible.
    // Then we stack an InkWell with the country code top of that
    // to add the clickable part
    return Stack(
      children: [
        _textField(),
        _dialCodeOverlay(),
      ],
    );
  }

  Widget _textField() {
    return TextFormField(
      focusNode: _focusNode,
      controller: _nationalNumberController,
      onChanged: (national) => _updateValue(
          SimplePhoneNumber(isoCode: _isoCode, national: national)),
      autofocus: widget.autofocus,
      autofillHints: widget.autoFillHints,
      onEditingComplete: widget.onEditingComplete,
      enabled: widget.enabled,
      textDirection: TextDirection.ltr,
      keyboardType: TextInputType.phone,
      cursorColor: widget.cursorColor,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(
            '[${Constants.PLUS}${Constants.DIGITS}${Constants.PUNCTUATION}]')),
      ],
      decoration: widget.decoration.copyWith(
        errorText: widget.errorText,
        prefix: _getDialCodeChip(visible: false),
      ),
    );
  }

  Widget _dialCodeOverlay() {
    final hasLabel = widget.decoration.labelText != null;
    final floatingLabelBehavior = widget.decoration.floatingLabelBehavior;
    // the country code ship must remain visible when there is no label
    // that takes his place
    final isCountryCodeVisible = _focusNode.hasFocus ||
        !hasLabel ||
        floatingLabelBehavior == FloatingLabelBehavior.always ||
        (_nationalNumberController.text != '');

    final dialCode = Padding(
      padding: _isOutlineBorder
          ? const EdgeInsets.fromLTRB(12, 15, 0, 17)
          : EdgeInsets.fromLTRB(0, hasLabel ? 24.0 : 14.5, 0, 8),
      child: _getDialCodeChip(visible: isCountryCodeVisible),
    );

    if (!_focusNode.hasFocus)
      return GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: MouseRegion(
          cursor: SystemMouseCursors.text,
          child: dialCode,
        ),
      );
    else
      return InkWell(
        enableFeedback: true,
        // canRequestFocus: _focusNode.hasFocus ? true : false,
        onTap: () {},
        onTapDown: (_) => selectCountry(),
        child: dialCode,
      );
  }

  Widget _getDialCodeChip({bool visible = true}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: visible,
        child: CountryCodeChip(
          country: Country(_isoCode),
          showFlag: widget.showFlagInInput,
          textStyle: TextStyle(
              fontSize: 16, color: Theme.of(context).textTheme.caption?.color),
          flagSize: _isOutlineBorder ? 20 : 16,
        ),
      ),
    );
  }
}
