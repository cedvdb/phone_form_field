import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/country_selector.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'base_form_field.dart';
import 'country_button.dart';

class PhoneFormField extends BaseFormField<PhoneNumber> {
  final bool autofocus;
  final bool showFlagInInput;
  final InputDecoration decoration;
  final TextStyle inputTextStyle;
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
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: (p) => onSaved != null ? onSaved(p!) : (p) {},
          enabled: enabled,
          autovalidateMode: autovalidateMode,
          validator: (p) => _defaultValidator(p),
          builder: (field) {
            final state = field as _PhoneFormFieldState;
            return state.wrapper(state.builder());
          },
        );

  @override
  _PhoneFormFieldState createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends BaseFormFieldState<PhoneNumber> {
  _PhoneFormFieldState();

  get country => value?.country ?? Country.fromIsoCode('us');

  @override
  PhoneFormField get widget => super.widget as PhoneFormField;

  // tells the InputDecorator where to put the label
  @override
  bool get isEmpty => value == null || value!.nsn == '';

  @override
  void initState() {
    super.initState();
    controller.addListener(_onNationalNumberChanges);
  }

  _onNationalNumberChanges() {
    final newPhoneNumber = PhoneNumber.fromIsoCode(
      country.isoCode,
      controller.text,
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

  String? _getErrorText() {
    if (errorText == null) return null;
    return PhoneFieldLocalization.of(context)?.translate(errorText!) ??
        errorText;
  }

  Widget builder() {
    return Row(
      children: [
        Expanded(child: _textField()),
      ],
    );
  }

  Widget _countryButton() {
    return CountryButton(
      country: country,
      enabled: widget.enabled,
      onPressed: openCountrySelection,
      showFlag: widget.showFlagInInput,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      textStyle: TextStyle(fontSize: 16),
      flagSize: 16,
    );
  }

  Widget _textField() {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      onSubmitted: (p) => widget.onSaved!(value),
      style: widget.inputTextStyle,
      autofocus: widget.autofocus,
      autofillHints:
          widget.enabled ? [AutofillHints.telephoneNumberNational] : null,
      enabled: widget.enabled,
      textDirection: TextDirection.ltr,
      keyboardType: TextInputType.phone,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d{0,30}$'))
      ],
      decoration: _innerInputDecoration(),
    );
  }

  InputDecoration _outterInputDecoration() {
    return widget.decoration.copyWith(
      // isDense: true,
      // contentPadding: const EdgeInsets.all(0),
      errorText: _getErrorText(),
    );
  }

  InputDecoration _innerInputDecoration() {
    return const InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      isDense: true,
      contentPadding: const EdgeInsets.all(0),
    );
  }
}
