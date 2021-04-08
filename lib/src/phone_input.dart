import 'package:flutter/material.dart';
import 'package:phone_number_input/src/country_selector.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'country_button.dart';

class PhoneFormField extends FormField<PhoneNumber> {
  final bool displayLeadingDigitsInDialCode;
  final bool autofocus;
  final bool showFlagInInput;
  final TextStyle inputTextStyle;
  final ValueChanged<PhoneNumber?>? onChanged;

  static String _defaultValidator(PhoneNumber? phoneNumber) {
    return phoneNumber == null || phoneNumber.valid
        ? ''
        : 'Invalid phone number';
  }

  PhoneFormField({
    // form field params
    Key? key,
    void Function(PhoneNumber)? onSaved,
    PhoneNumber? initialValue,
    bool enabled = true,
    String? Function(PhoneNumber?)? validator = _defaultValidator,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    // our params
    this.onChanged,
    this.displayLeadingDigitsInDialCode = true,
    this.autofocus = false,
    this.showFlagInInput = true,
    this.inputTextStyle = const TextStyle(),
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: (p) => onSaved != null ? onSaved(p!) : (p) {},
          enabled: enabled,
          autovalidateMode: autovalidateMode,
          validator: validator,
          builder: (field) {
            final state = field as _PhoneFormFieldState;
            return state.builder();
          },
        );

  @override
  _PhoneFormFieldState createState() => _PhoneFormFieldState();
}

class _PhoneFormFieldState extends FormFieldState<PhoneNumber> {
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

  Widget builder() {
    return InputDecorator(
      // when the input has focus
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(0),
        border: OutlineInputBorder(),
      ),
      child: Row(
        children: [
          CountryButton(
            country: _selectedCountry,
            onPressed: () => widget.enabled ? openCountrySelection() : () {},
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
                controller: _controller,
                cursorColor: Theme.of(context).accentColor,
                style: widget.inputTextStyle,
                autofocus: widget.autofocus,
                autofillHints: ['telephoneNumberNational'],
                enabled: widget.enabled,
                textDirection: TextDirection.ltr,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
