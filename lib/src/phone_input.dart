import 'package:flutter/material.dart';
import 'package:phone_number_input/src/country_selector.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'country_button.dart';

enum DialCodeType { withLeadingDigits, dialCodeOnly }

class PhoneFormField extends FormField<PhoneNumber> {
  final DialCodeType dialCodeType;
  final bool autofocus;
  final bool showFlagInCountrySelection;
  final bool showFlagInInput;
  final TextStyle inputTextStyle;

  static String _defaultValidator(PhoneNumber? phoneNumber) {
    return phoneNumber == null || phoneNumber.valid
        ? ''
        : 'Invalid phone number';
  }

  PhoneFormField({
    // form field params
    Key? key,
    void Function(PhoneNumber?)? onSaved,
    PhoneNumber? initialValue,
    bool enabled = true,
    String? Function(PhoneNumber?)? validator = _defaultValidator,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    // our params
    this.dialCodeType = DialCodeType.withLeadingDigits,
    this.autofocus = false,
    this.showFlagInCountrySelection = true,
    this.showFlagInInput = true,
    this.inputTextStyle = const TextStyle(),
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
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

  _PhoneFormFieldState();

  @override
  PhoneFormField get widget => super.widget as PhoneFormField;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue?.nsn ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onCountrySelected(Country country) {
    PhoneNumber newPhoneNumber;
    if (widget.initialValue != null) {
      newPhoneNumber = widget.initialValue!.copyWithIsoCode(
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
      builder: (_) => CountrySelector(onCountrySelected: _onCountrySelected),
    );
  }

  Widget builder() {
    return InputDecorator(
      // when the input has focus
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(0),
        border: UnderlineInputBorder(),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CountryButton(
              country:
                  widget.initialValue?.country ?? Country.fromIsoCode('us'),
              onPressed: () => widget.enabled ? openCountrySelection() : () {},
              showFlag: widget.showFlagInInput,
              textStyle: widget.inputTextStyle,
            ),
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
