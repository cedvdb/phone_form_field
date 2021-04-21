import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/country_selector.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'flag_dial_code_chip.dart';

class PhoneFormField extends FormField<PhoneNumber> {
  final bool autofocus;
  final bool showFlagInInput;
  final InputDecoration decoration;
  final TextStyle inputTextStyle;
  final Color? cursorColor;
  final bool withHint;
  final ValueChanged<PhoneNumber?>? onChanged;

  static String? _defaultValidator(PhoneNumber? phoneNumber) {
    return phoneNumber == null || phoneNumber.valid || phoneNumber.nsn == ''
        ? null
        : 'Invalid phone number';
  }

  PhoneFormField({
    // form field params
    Key? key,
    void Function(PhoneNumber)? onSaved,
    PhoneNumber? initialValue,
    bool enabled = true,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    // our params
    this.onChanged,
    this.autofocus = false,
    this.showFlagInInput = true,
    this.decoration = const InputDecoration(border: UnderlineInputBorder()),
    this.inputTextStyle = const TextStyle(),
    this.cursorColor,
    this.withHint = true,
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: (p) => onSaved != null ? onSaved(p!) : (p) {},
          enabled: enabled,
          autovalidateMode: autovalidateMode,
          validator: (p) => _defaultValidator(p),
          builder: (field) {
            final state = field as _PhoneFormFieldState;
            return state.builder();
          },
        );

  @override
  _PhoneFormFieldState createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends FormFieldState<PhoneNumber> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();

  _PhoneFormFieldState();

  get country => value?.country ?? Country.fromIsoCode('us');

  get isOutlineBorder => widget.decoration.border is OutlineInputBorder;

  @override
  PhoneFormField get widget => super.widget as PhoneFormField;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onNationalNumberChanges);
  }

  @override
  void didChange(PhoneNumber? value) {
    super.didChange(value);
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  _onNationalNumberChanges() {
    final newPhoneNumber = PhoneNumber.fromIsoCode(
      country.isoCode,
      _controller.text,
    );
    didChange(newPhoneNumber);
  }

  _onCountrySelected(Country country) {
    PhoneNumber newPhoneNumber;
    if (value != null) {
      newPhoneNumber = value!.copyWithIsoCode(
        country.isoCode,
      );
    } else {
      newPhoneNumber = PhoneNumber.fromIsoCode(country.isoCode, '');
    }
    didChange(newPhoneNumber);
  }

  openCountrySelection() {
    showModalBottomSheet(
      context: context,
      builder: (_) => CountrySelector(
        onCountrySelected: _onCountrySelected,
      ),
    );
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
    return TextField(
      focusNode: _focusNode,
      controller: _controller,
      onSubmitted: (p) => widget.onSaved!(value),
      style: widget.inputTextStyle,
      autofocus: widget.autofocus,
      autofillHints: widget.enabled && widget.withHint
          ? [AutofillHints.telephoneNumberNational]
          : null,
      enabled: widget.enabled,
      textDirection: TextDirection.ltr,
      keyboardType: TextInputType.phone,
      cursorColor: widget.cursorColor,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.singleLineFormatter,
        // FilteringTextInputFormatter.allow(RegExp(r'^\d{0,30}$'))
      ],
      decoration: _getEffectiveDecoration(),
    );
  }

  Widget _inkWellOverlay() {
    return InkWell(
      onTap: openCountrySelection,
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
          child: _getDialCode(),
        ),
      ),
    );
  }

  Widget _getDialCode() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: FlagDialCodeChip(
        country: country,
        enabled: widget.enabled,
        onPressed: openCountrySelection,
        showFlag: widget.showFlagInInput,
        textStyle: TextStyle(fontSize: 16),
        flagSize: 20,
      ),
    );
  }

  InputDecoration _getEffectiveDecoration() {
    return widget.decoration.copyWith(
      errorText: getErrorText(),
      prefix: _getDialCode(),
    );
  }

  // which error text to show
  String? getErrorText() {
    if (!hasError) return null;
    return PhoneFieldLocalization.of(context)?.translate(errorText!) ??
        errorText;
  }
}
