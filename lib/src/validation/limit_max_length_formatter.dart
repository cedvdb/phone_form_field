import 'package:flutter/services.dart';

class LimitMaxLengthFormatter extends TextInputFormatter {
  final int maxLength;

  /// The national prefix of the selected country, if it is displayed.
  ///
  /// The prefix is not part of the national significant number, so it is not
  /// counted against [maxLength]: `0477 88 99 22` has 9 digits after the `0`.
  final String? nationalPrefix;

  LimitMaxLengthFormatter(this.maxLength, {this.nationalPrefix});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String rawInput = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    final prefix = nationalPrefix ?? '';
    final hasPrefix = prefix.isNotEmpty && rawInput.startsWith(prefix);
    final digits = hasPrefix ? rawInput.substring(prefix.length) : rawInput;

    if (digits.length > maxLength) {
      final truncated = digits.substring(0, maxLength);
      final text = hasPrefix ? prefix + truncated : truncated;
      return newValue.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    return newValue;
  }
}
