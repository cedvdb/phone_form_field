import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/country_selector.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'country_button.dart';

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

  @override
  PhoneFormField get widget => super.widget as PhoneFormField;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onNationalNumberChanges);
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
    return Stack(
      children: [
        _textField(),
        // _getCountryButton(EdgeInsets.all(8)),
        Positioned(top: 0, child: _getCountryButton(EdgeInsets.all(16))),
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
        FilteringTextInputFormatter.allow(RegExp(r'^\d{0,30}$'))
      ],
      decoration: _getEffectiveDecoration(),
    );
  }

  Widget _getCountryButton([EdgeInsets? padding]) {
    return IgnorePointer(
      ignoring: !_focusNode.hasFocus,
      child: CountryButton(
        country: country,
        enabled: widget.enabled,
        onPressed: openCountrySelection,
        showFlag: widget.showFlagInInput,
        padding: padding ?? const EdgeInsets.fromLTRB(10, 0, 10, 0),
        textStyle: TextStyle(fontSize: 16),
        flagSize: 16,
      ),
    );
  }

  InputDecoration _getEffectiveDecoration() {
    return widget.decoration.copyWith(
      errorText: getErrorText(),
      prefix: Opacity(opacity: 0, child: _getCountryButton()),
    );
  }

  // which error text to show
  String? getErrorText() {
    if (!hasError) return null;
    return PhoneFieldLocalization.of(context)?.translate(errorText!) ??
        errorText;
  }
}
