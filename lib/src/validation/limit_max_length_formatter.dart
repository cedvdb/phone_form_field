import 'package:flutter/services.dart';

class LimitMaxLengthFormatter extends TextInputFormatter {
  final int maxLength;

  LimitMaxLengthFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String rawInput = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (rawInput.length > maxLength) {
      rawInput = rawInput.substring(0, maxLength);
      return newValue.copyWith(
        text: rawInput,
        selection: TextSelection.collapsed(offset: rawInput.length),
      );
    }

    return newValue;
  }
}
