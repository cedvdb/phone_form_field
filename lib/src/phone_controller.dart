part of 'phone_form_field.dart';

class PhoneController extends ChangeNotifier {
  /// focus node of the national number
  // final FocusNode focusNode;
  final PhoneNumber initialValue;
  PhoneNumber _value;
  PhoneNumber get value => _value;

  set value(PhoneNumber phoneNumber) {
    _value = phoneNumber;
    final formattedNsn = _value.formatNsn();
    if (_formattedNationalNumberController.text != formattedNsn) {
      changeNationalNumber(formattedNsn);
    } else {
      notifyListeners();
    }
  }

  /// text editing controller of the nsn ( where user types the phone number )
  late final TextEditingController _formattedNationalNumberController;
  PhoneController({
    this.initialValue = const PhoneNumber(isoCode: IsoCode.US, nsn: ''),
  })  : _value = initialValue,
        _formattedNationalNumberController = TextEditingController(
          text: initialValue.formatNsn(),
        );

  changeCountry(IsoCode isoCode) {
    _value = PhoneNumber.parse(
      _value.nsn,
      destinationCountry: isoCode,
    );
    _changeFormattedNationalNumber(_value.formatNsn());
    notifyListeners();
  }

  changeNationalNumber(String? text) {
    text = text ?? '';
    final oldFormattedText = _value.formatNsn();
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
        newFormattedText = _value.formatNsn();
      }
    } else if (isDeleting &&
        text.startsWith(
            RegExp('^\\([${AllowedCharacters.digits}]+(?!.*\\))'))) {
      // Handle case where the phone number contains an area code such as (416), and user has begun to delete it, i.e. the text input is now (416.
      // We need to skip parsing/formatting here, else the parentheses will be added back
    } else {
      final phoneNumber = PhoneNumber.parse(
        text,
        destinationCountry: _value.isoCode,
      );
      _value = phoneNumber;
      newFormattedText = phoneNumber.formatNsn();
    }
    _changeFormattedNationalNumber(newFormattedText);
    notifyListeners();
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

  selectNationalNumber() {
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
