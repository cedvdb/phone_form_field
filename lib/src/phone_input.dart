import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:phone_number_input/src/country_selector.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class PhoneInput extends StatefulWidget {
  final Function(PhoneNumber) onChange;
  late final PhoneNumber phoneNumber;
  final bool autofocus;
  final bool valid;
  final bool readonly;
  final bool showFlagInCountrySelection;
  final bool showFlagInInput;
  final FormFieldValidator? validator;
  final TextStyle inputTextStyle;

  PhoneInput({
    required this.onChange,
    required this.phoneNumber,
    this.valid = true,
    this.readonly = false,
    this.autofocus = false,
    this.showFlagInCountrySelection = true,
    this.showFlagInInput = true,
    this.validator,
    this.inputTextStyle = const TextStyle(),
  });

  @override
  _PhoneInputState createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  _PhoneInputState();
  // keeps track of the focus on the input
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.phoneNumber.nsn;
    print(widget.phoneNumber.nsn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  openCountrySelection() {
    showModalBottomSheet(
      context: context,
      builder: (_) => CountrySelector(
        onCountrySelected: (c) {
          final newPhoneNumber = PhoneNumber.fromIsoCode(
            c.isoCode,
            widget.phoneNumber.nsn,
          );
          widget.onChange(newPhoneNumber);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField(builder: (state) {
      // creates an input type box
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
                country: widget.phoneNumber.country,
                onPressed: () => openCountrySelection(),
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
                  readOnly: widget.readonly,
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
    });
  }
}

class CountryButton extends StatelessWidget {
  final Country country;
  final bool showFlag;
  final Function() onPressed;
  final TextStyle textStyle;

  CountryButton({
    required this.country,
    required this.onPressed,
    required this.showFlag,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showFlag) ...[
            CircleFlag(
              country.isoCode,
              size: 20,
            ),
            SizedBox(
              width: 8,
            ),
          ],
          Text(
            country.dialCode,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
