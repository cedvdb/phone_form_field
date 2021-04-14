import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/country_selector.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'country_button.dart';

class PhoneFormField extends FormField<PhoneNumber> {
  final bool autofocus;
  final bool showFlagInInput;
  final InputDecoration inputDecoration;
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
    this.inputDecoration =
        const InputDecoration(border: UnderlineInputBorder()),
    this.inputTextStyle = const TextStyle(fontSize: 14),
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
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  Country _selectedCountry = Country.fromIsoCode('us');

  _PhoneFormFieldState();

  @override
  PhoneFormField get widget => super.widget as PhoneFormField;

  @override
  void didChange(PhoneNumber? phoneNumber) {
    super.didChange(phoneNumber);
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onNationalNumberChanges);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onNationalNumberChanges() {
    final phoneNumber = PhoneNumber.fromIsoCode(
      _selectedCountry.isoCode,
      _controller.text,
    );
    didChange(phoneNumber);
  }

  _onCountrySelected(Country country) {
    _selectedCountry = country;
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
    return Column(
      children: [
        InputDecorator(
          // when the input has focus
          isFocused: _focusNode.hasFocus,
          decoration: _outterInputDecoration(),
          child: Row(
            children: [
              _countryButton(),
              // need to use expanded to make the text field fill the remaining space
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _textField(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  CountryButton _countryButton() {
    return CountryButton(
      country: _selectedCountry,
      enabled: widget.enabled,
      onPressed: openCountrySelection,
      showFlag: widget.showFlagInInput,
      textStyle: widget.inputTextStyle,
    );
  }

  TextField _textField() {
    return TextField(
      focusNode: _focusNode,
      controller: _controller,
      onSubmitted: (p) => widget.onSaved!(value),
      cursorColor: Theme.of(context).accentColor,
      style: widget.inputTextStyle,
      autofocus: widget.autofocus,
      autofillHints: widget.enabled ? ['telephoneNumberNational'] : null,
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
    return widget.inputDecoration.copyWith(
      isDense: true,
      contentPadding: EdgeInsets.all(0),
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
    );
  }
}
