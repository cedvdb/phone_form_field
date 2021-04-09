import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/country_selector.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'country_button.dart';

class PhoneFormField extends FormField<PhoneNumber> {
  final bool displayLeadingDigitsInDialCode;
  final bool autofocus;
  final bool showFlagInInput;
  final InputBorder inputBorder;
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
    this.displayLeadingDigitsInDialCode = true,
    this.autofocus = false,
    this.showFlagInInput = true,
    this.inputBorder = const UnderlineInputBorder(),
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
        displayLeadingDigitsInDialCode: widget.displayLeadingDigitsInDialCode,
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
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(0),
            border: widget.inputBorder,
            errorText: _getErrorText(),
          ),
          child: Row(
            children: [
              CountryButton(
                country: _selectedCountry,
                onPressed: () =>
                    widget.enabled ? openCountrySelection() : () {},
                showFlag: widget.showFlagInInput,
                textStyle: widget.inputTextStyle,
                displayLeadingDigitsInDialCode:
                    widget.displayLeadingDigitsInDialCode,
              ),
              // need to use expanded to make the text field fill the remaining space
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    cursorColor: Theme.of(context).accentColor,
                    style: widget.inputTextStyle,
                    autofocus: widget.autofocus,
                    autofillHints: ['telephoneNumberNational'],
                    enabled: widget.enabled,
                    textDirection: TextDirection.ltr,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d{0,30}$'))
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
