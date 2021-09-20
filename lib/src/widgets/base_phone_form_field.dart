import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/src/models/simple_phone_number.dart';

import '../models/country.dart';
import 'country_picker/country_selector_navigator.dart';
import 'flag_dial_code_chip.dart';

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
      _nationalNumberController.text = national;
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

  selectCountry() async {
    final selected = await widget.selectorNavigator.navigate(context);
    if (selected != null) {
      _updateValue(SimplePhoneNumber(
          isoCode: selected.isoCode, national: value?.national ?? ''));
    }
    _focusNode.requestFocus();
  }

  Widget build(BuildContext context) {
    // the idea here is to have a TextField with a prefix where the prefix
    // is the flag + dial code which is the same height as text so it's well
    // aligned with the typed text. It also does not push labels etc
    // around and keep the same form factor as TextFormField.
    //
    // Then we stack an InkWell on top of that to add the clickable part
    return Stack(
      children: [
        _textField(),
        if (_focusNode.hasFocus) _inkWellOverlay(),
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
      decoration: widget.decoration.copyWith(
        errorText: widget.errorText,
        prefix: _getDialCodeChip(),
      ),
    );
  }

  Widget _inkWellOverlay() {
    return InkWell(
      onTap: () {},
      onTapDown: (_) => selectCountry(),
      // we make the country dial code
      // invisible but we still have to put it here
      // to have the correct width
      child: Opacity(
        opacity: 0,
        child: Padding(
          // outline border has padding on the left
          // so we need to make it a 12 bigger
          // and we add 16 horizontally to make it the whole height
          padding: _isOutlineBorder
              ? const EdgeInsets.fromLTRB(12, 16, 0, 16)
              : const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: _getDialCodeChip(),
        ),
      ),
    );
  }

  Widget _getDialCodeChip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: FlagDialCodeChip(
        country: Country(_isoCode),
        showFlag: widget.showFlagInInput,
        textStyle: TextStyle(fontSize: 16),
        flagSize: 20,
      ),
    );
  }
}
