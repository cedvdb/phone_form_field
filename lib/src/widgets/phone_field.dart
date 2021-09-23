import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/src/constants/constants.dart';
import 'package:phone_form_field/src/models/simple_phone_number.dart';
import 'package:phone_form_field/src/widgets/measure_initial_size.dart';

import '../../phone_form_field.dart';
import '../models/country.dart';
import 'country_picker/country_selector_navigator.dart';
import 'country_code_chip.dart';

/// Phone field
///
/// This deals with mostly UI and has no dependency on any phone parser library
class PhoneField extends StatefulWidget {
  final ValueNotifier<SimplePhoneNumber?> controller;
  final String defaultCountry;
  final bool autofocus;
  final bool showFlagInInput;
  final bool? enabled;
  final String? errorText;
  final bool isCountryCodeFixed;

  /// input decoration applied to the input
  final InputDecoration decoration;
  final Color? cursorColor;
  final Iterable<String>? autoFillHints;
  final Function()? onEditingComplete;

  /// configures the way the country picker selector is shown
  final CountrySelectorNavigator selectorNavigator;

  PhoneField({
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
    required CountryCodeVisibility countryCodeVisibility,
  }) : isCountryCodeFixed =
            _getIsCountryCodeFixed(countryCodeVisibility, decoration);

  static bool _getIsCountryCodeFixed(
      CountryCodeVisibility countryCodeVisibility, InputDecoration decoration) {
    switch (countryCodeVisibility) {
      case CountryCodeVisibility.alwaysOn:
        return true;
      case CountryCodeVisibility.onFocus:
        return false;
      case CountryCodeVisibility.auto:
        return decoration.label == null && decoration.labelText == null;
      default:
        return false;
    }
  }

  @override
  _PhoneFieldState createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  final FocusNode _focusNode = FocusNode();
  Size? _size;

  /// this is the controller for the national phone number
  late TextEditingController _nationalNumberController;

  bool get _hasLabel =>
      widget.decoration.label != null || widget.decoration.labelText != null;
  bool get _isCountryCodeFixed => widget.isCountryCodeFixed;
  bool get _isOutlineBorder => widget.decoration.border is OutlineInputBorder;
  SimplePhoneNumber? get value => widget.controller.value;
  String get _isoCode => value?.isoCode ?? widget.defaultCountry;

  _PhoneFieldState();

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
        if (_focusNode.hasFocus || _isCountryCodeFixed) _inkWellOverlay(),
      ],
    );
  }

  Widget _textField() {
    // this is hacky but flutter does not provide a way to
    // align the different prefix options with the text which might
    // ultimately be a bug
    double paddingBottom = 0;
    double paddingLeft = 0;
    double paddingTop = 0;
    if (_isOutlineBorder && _isCountryCodeFixed && _hasLabel) paddingBottom = 2;
    if (_isOutlineBorder && _isCountryCodeFixed) paddingLeft = 12;
    if (!_isOutlineBorder && _isCountryCodeFixed) paddingTop = 16;
    if (_isOutlineBorder && !_hasLabel) paddingBottom = 3;
    if (!_isOutlineBorder && !_hasLabel) paddingBottom = 5;

    final padding =
        EdgeInsets.fromLTRB(paddingLeft, paddingTop, 0, paddingBottom);
    return TextField(
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
        prefix: _isCountryCodeFixed
            ? null
            : Padding(
                padding: padding,
                child: _getDialCodeChip(),
              ),
        prefixIcon: _isCountryCodeFixed
            ? Padding(
                padding: padding,
                child: _getDialCodeChip(),
              )
            : null,
      ),
    );
  }

  Widget _inkWellOverlay() {
    return InkWell(
      onTap: () {},
      onTapDown: (_) => selectCountry(),
      child: ConstrainedBox(
        // we set the size to input size
        constraints: BoxConstraints(
          minHeight: _size?.height ?? 0,
        ),
        child: Padding(
          // outline border has padding on the left
          // but only when prefixIcon is used (!isCountryCodeFixed)
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
          country: Country(_isoCode),
          showFlag: widget.showFlagInInput,
          textStyle: TextStyle(
              fontSize: 16, color: Theme.of(context).textTheme.caption?.color),
          flagSize: _isOutlineBorder ? 16 : 16,
        ),
      ),
    );
  }
}
