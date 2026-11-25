part of 'phone_form_field.dart';

class PhoneController extends ChangeNotifier {
  /// focus node of the national number
  // final FocusNode focusNode;
  final PhoneNumber initialValue;
  PhoneNumber _value;
  PhoneNumber get value => _value;

  set value(PhoneNumber phoneNumber) {
    _value = phoneNumber;
    // Display the new value without parsing it back: parsing the formatted
    // national number can strip a national prefix from the nsn, which would
    // silently change the value that was just assigned.
    _changeFormattedNationalNumber(_formattedNational(_value));
    notifyListeners();
  }

  /// How the [value] is written in the text field.
  ///
  /// The national prefix is only part of the display when the dial code is not
  /// shown next to the field: `+32` followed by `0477 88 99 22` reads as an
  /// invalid number, while `0477 88 99 22` alone only makes sense in a
  /// national context.
  NsnFormat get displayFormat => _displayFormat;
  set displayFormat(NsnFormat format) {
    if (_displayFormat == format) {
      return;
    }
    _displayFormat = format;
    _changeFormattedNationalNumber(_formattedNational(_value));
  }

  NsnFormat _displayFormat = NsnFormat.nationalWithoutPrefix;

  /// Number of national prefix digits that the formatted text contains.
  int get displayedPrefixLength {
    if (displayFormat != NsnFormat.national) {
      return 0;
    }
    return metadataByIsoCode[_value.isoCode]?.nationalPrefix?.length ?? 0;
  }

  String _formattedNational(PhoneNumber phoneNumber) =>
      phoneNumber.formatNsn(format: displayFormat);

  /// text editing controller of the nsn ( where user types the phone number )
  late final TextEditingController _formattedNationalNumberController;
  PhoneController({
    this.initialValue = const PhoneNumber(isoCode: IsoCode.US, nsn: ''),
  })  : _value = initialValue,
        _formattedNationalNumberController = TextEditingController(
          text: initialValue.formatNsn(
            format: NsnFormat.nationalWithoutPrefix,
          ),
        );

  void changeCountry(IsoCode isoCode) {
    _value = PhoneNumber.parse(
      _value.nsn,
      destinationCountry: isoCode,
    );
    _changeFormattedNationalNumber(_formattedNational(_value));
    notifyListeners();
  }

  void changeNationalNumber(String? text) {
    text = text ?? '';
    final oldFormattedText = _formattedNational(_value);
    var newFormattedText = text;

    bool isDeleting = text.length < oldFormattedText.length;

    // if starts with + then we parse the whole number
    final startsWithPlus =
        text.startsWith(RegExp('[${AllowedCharacters.plus}]'));

    if (startsWithPlus) {
      final phoneNumber = _tryParseWithPlus(text);
      // if we could parse the phone number we can change the value inside
      // the national number field to remove the "+ country dial code"
      if (phoneNumber != null) {
        _value = phoneNumber;
        newFormattedText = _formattedNational(_value);
      }
    } else if (isDeleting &&
        text.startsWith(
            RegExp('^\\([${AllowedCharacters.digits}]+(?!.*\\))'))) {
      // Handle case where the phone number contains an area code such as (416), and user has begun to delete it, i.e. the text input is now (416.
      // We need to skip parsing/formatting here, else the parentheses will be added back
    } else {
      final phoneNumber = _parseNationalNumber(text);
      _value = phoneNumber;
      newFormattedText = _formattedNational(phoneNumber);
    }
    _changeFormattedNationalNumber(newFormattedText);
    notifyListeners();
  }

  /// Parses [text] typed without a leading `+` as a national number.
  ///
  /// [PhoneNumber.parse] reads a leading country calling code as an
  /// international prefix when the whole input is not valid without it. In a
  /// national input field that silently removes the first digits the user
  /// typed: `4705555` in Norway became `05555`. The calling code is only
  /// honoured when the digits are too long for a national number.
  PhoneNumber _parseNationalNumber(String text) {
    final phoneNumber = PhoneNumber.parse(
      text,
      destinationCountry: _value.isoCode,
    );
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    // A short local number gets its area code prepended (`778144` in Guernsey
    // becomes `1481778144`), but while typing it is usually the start of a
    // longer number, so the digits are kept as typed.
    if (phoneNumber.nsn.length > digits.length) {
      return PhoneNumber(isoCode: phoneNumber.isoCode, nsn: digits);
    }
    final countryCode = phoneNumber.countryCode;
    final countryCodeWasStripped = digits.startsWith(countryCode) &&
        digits.substring(countryCode.length) == phoneNumber.nsn;
    if (countryCodeWasStripped &&
        digits.length <=
            _maxNsnLength(phoneNumber.isoCode) + displayedPrefixLength) {
      return PhoneNumber(isoCode: phoneNumber.isoCode, nsn: digits);
    }
    return phoneNumber;
  }

  /// Longest national significant number accepted for [isoCode].
  int _maxNsnLength(IsoCode isoCode) {
    final mobileLength = metadataLengthsByIsoCode[isoCode]?.mobile.last ?? 0;
    final fixedLineLength =
        metadataLengthsByIsoCode[isoCode]?.fixedLine.last ?? 0;
    return mobileLength > fixedLineLength ? mobileLength : fixedLineLength;
  }

  void _changeFormattedNationalNumber(String newFormattedText) {
    if (newFormattedText != _formattedNationalNumberController.text) {
      _formattedNationalNumberController.value = TextEditingValue(
        text: newFormattedText,
        selection: _computeSelection(
            _formattedNationalNumberController.text, newFormattedText),
      );
    }
  }

  /// When the cursor is at the end of the text we need to preserve that.
  /// Since there is formatting going on we need to explicitely do it.
  /// We don't want to do it in the middle because the user might have
  /// used arrow keys to move inside the text.
  TextSelection _computeSelection(String originalText, String newText) {
    final currentSelectionOffset =
        _formattedNationalNumberController.selection.extentOffset;
    final isCursorAtEnd = currentSelectionOffset == originalText.length;
    var offset = currentSelectionOffset;

    if (isCursorAtEnd || currentSelectionOffset >= newText.length) {
      offset = newText.length;
    }
    return TextSelection.fromPosition(
      TextPosition(offset: offset),
    );
  }

  PhoneNumber? _tryParseWithPlus(String text) {
    try {
      return PhoneNumber.parse(text);
      // parsing "+", a country code won't be found
    } on PhoneNumberException {
      return null;
    }
  }

  void selectNationalNumber() {
    _formattedNationalNumberController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _formattedNationalNumberController.value.text.length,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _formattedNationalNumberController.dispose();
    super.dispose();
  }
}
