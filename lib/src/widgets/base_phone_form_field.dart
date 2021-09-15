import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization.dart';
import 'package:phone_form_field/src/models/phone_number_input.dart';

import '../models/country.dart';
import 'country_picker/country_selector_navigator.dart';
import 'flag_dial_code_chip.dart';

/// That is the base for the PhoneFormField
///
/// This deals with mostly UI and has no dependency on any phone parser library
class BasePhoneFormField extends FormField<PhoneNumberInput> {
  final ValueNotifier<PhoneNumberInput?>? controller;
  final String defaultCountry;
  final bool autofocus;
  final bool showFlagInInput;
  final String errorText;

  /// input decoration applied to the input
  final InputDecoration decoration;
  final TextStyle inputTextStyle;
  final Color? cursorColor;
  final ValueChanged<PhoneNumberInput?>? onChanged;
  final Iterable<String>? autoFillHints;
  final Function()? onEditingComplete;

  /// configures the way the country picker selector is shown
  final CountrySelectorNavigator selectorNavigator;

  BasePhoneFormField({
    // form field params
    Key? key,
    PhoneNumberInput? initialValue,
    bool enabled = true,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    void Function(PhoneNumberInput?)? onSaved,
    String? Function(PhoneNumberInput?)? validator,
    // our params
    this.controller,
    this.onChanged,
    this.defaultCountry = 'US',
    this.autofocus = true,
    this.showFlagInInput = true,
    this.autoFillHints,
    this.onEditingComplete,
    this.errorText = 'Invalid phone number',
    this.decoration = const InputDecoration(border: UnderlineInputBorder()),
    this.inputTextStyle = const TextStyle(),
    this.cursorColor,
    this.selectorNavigator = const BottomSheetNavigator(),
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          enabled: enabled,
          autovalidateMode: autovalidateMode,
          validator: validator,
          builder: (field) {
            final state = field as _BasePhoneFormFieldState;
            return state.builder();
          },
        );

  @override
  _BasePhoneFormFieldState createState() => _BasePhoneFormFieldState();
}

class _BasePhoneFormFieldState extends FormFieldState<PhoneNumberInput> {
  final FocusNode _focusNode = FocusNode();

  /// this is the controller for the national phone number
  late final TextEditingController _nationalController;
  late final ValueNotifier<String> _isoCodeController;
  late final ValueNotifier<PhoneNumberInput?> _phoneController;

  @override
  BasePhoneFormField get widget => super.widget as BasePhoneFormField;

  bool get isOutlineBorder => widget.decoration.border is OutlineInputBorder;

  _BasePhoneFormFieldState();

  @override
  void initState() {
    super.initState();
    _nationalController =
        TextEditingController(text: widget.initialValue?.national);
    _isoCodeController = ValueNotifier<String>(
      widget.initialValue?.isoCode ?? widget.defaultCountry,
    );
    _phoneController = widget.controller ??
        ValueNotifier<PhoneNumberInput?>(widget.initialValue);
    _nationalController.addListener(_reflectChangesOnParentController);
    _isoCodeController.addListener(_reflectChangesOnParentController);
    _phoneController.addListener(_reflectChangesOnChildControllers);
    _phoneController.addListener(_onChange);
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _nationalController.dispose();
    _isoCodeController.dispose();
    // dispose the phoneController only when it's initialised in this
    // instance otherwise this should be done where instance is created
    if (widget.controller == null) {
      _phoneController.dispose();
    }
    super.dispose();
  }

  /// called when one of the sub inputs changes
  _reflectChangesOnParentController() {
    final national = _nationalController.text;
    final isoCode = _isoCodeController.value;
    _phoneController.value = PhoneNumberInput(
      isoCode: isoCode,
      national: national,
    );
  }

  /// called when the main controller changes to change the children
  _reflectChangesOnChildControllers() {
    final national = _phoneController.value?.national ?? '';
    final isoCode = _phoneController.value?.isoCode;
    _nationalController.value = TextEditingValue(
      text: national,
      selection: TextSelection.fromPosition(
        TextPosition(offset: national.length),
      ),
    );
    _isoCodeController.value = isoCode ?? widget.defaultCountry;
  }

  /// called when the phone controller changes
  _onChange() {
    if (_phoneController.value != value) {
      didChange(_phoneController.value);
      widget.onChanged?.call(value);
    }
  }

  selectCountry() async {
    final selected = await widget.selectorNavigator.navigate(context);
    if (selected != null) {
      _isoCodeController.value = selected.isoCode;
    }
    _focusNode.requestFocus();
  }

  Widget builder() {
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
      controller: _nationalController,
      style: widget.inputTextStyle,
      autofocus: widget.autofocus,
      autofillHints: widget.autoFillHints,
      onEditingComplete: widget.onEditingComplete,
      enabled: widget.enabled,
      textDirection: TextDirection.ltr,
      keyboardType: TextInputType.phone,
      cursorColor: widget.cursorColor,
      decoration: _getEffectiveDecoration(),
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
          padding: isOutlineBorder
              ? const EdgeInsets.fromLTRB(12, 16, 0, 16)
              : const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: _getDialCodeChip(),
        ),
      ),
    );
  }

  InputDecoration _getEffectiveDecoration() {
    return widget.decoration.copyWith(
      errorText: getErrorText(),
      prefix: _getDialCodeChip(),
    );
  }

  Widget _getDialCodeChip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: FlagDialCodeChip(
        country: Country(_isoCodeController.value),
        showFlag: widget.showFlagInInput,
        textStyle: TextStyle(fontSize: 16),
        flagSize: 20,
      ),
    );
  }

  // // which error text to show
  String? getErrorText() {
    if (!hasError) return null;
    return PhoneFieldLocalization.of(context)?.invalidPhoneNumber ?? errorText;
  }
}
