import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/validation/allowed_characters.dart';

class PhoneController extends ChangeNotifier {
  final bool shouldFormat;

  /// focus node of the national number
  // final FocusNode focusNode;
  final PhoneNumber initialValue;
  PhoneNumber _value;
  PhoneNumber get value => _value;
  set value(PhoneNumber phoneNumber) {
    _value = phoneNumber;
    changeCountry(_value.isoCode);
    changeText(_value.nsn);
  }

  late final TextEditingController nationalNumberController;

  PhoneController({
    this.initialValue = const PhoneNumber(isoCode: IsoCode.US, nsn: ''),
    this.shouldFormat = true,
  })  : _value = initialValue,
        nationalNumberController = TextEditingController(
            text: shouldFormat
                ? initialValue.getFormattedNsn()
                : initialValue.nsn);

  reset() {
    _value = initialValue;
    notifyListeners();
  }

  changeCountry(IsoCode isoCode) {
    _value = PhoneNumber.parse(
      _value.nsn,
      destinationCountry: isoCode,
    );
    notifyListeners();
  }

  changeText(String? text) {
    text = text ?? '';
    // if starts with + then we parse the whole number
    // to figure out the country code
    if (text.startsWith(RegExp('[${AllowedCharacters.plus}]'))) {
      _value = PhoneNumber.parse(text);
    } else {
      _value = PhoneNumber.parse(
        text,
        destinationCountry: _value.isoCode,
      );
    }
    nationalNumberController.text =
        shouldFormat ? _value.getFormattedNsn() : _value.nsn;
    notifyListeners();
  }

  selectNationalNumber() {
    nationalNumberController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: nationalNumberController.value.text.length,
    );
  }

  @override
  void dispose() {
    nationalNumberController.dispose();
    super.dispose();
  }
}
