part of 'phone_form_field.dart';

class PhoneFormFieldState extends FormFieldState<PhoneNumber> {
  late final PhoneController _controller;
  late final PhoneFieldController _childController;
  late final StreamSubscription<void> _selectionSubscription;

  @override
  PhoneFormField get widget => super.widget as PhoneFormField;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? PhoneController(value);
    _childController = PhoneFieldController(
      isoCode: _controller.value?.isoCode ?? widget.defaultCountry,
      national: _getFormattedNsn(),
      focusNode: widget.focusNode ?? FocusNode(),
    );
    _controller.addListener(_onControllerChange);
    _childController.addListener(() => _onChildControllerChange());
    // to expose text selection of national number
    _selectionSubscription = _controller.selectionRequestStream
        .listen((event) => _childController.selectNationalNumber());
  }

  @override
  void dispose() {
    super.dispose();
    _childController.dispose();
    _selectionSubscription.cancel();
    _controller.removeListener(_onControllerChange);
    // dispose the controller only when it's initialised in this instance
    // otherwise this should be done where instance is created
    if (widget.controller == null) {
      _controller.dispose();
    }
  }

  @override
  void reset() {
    _controller.value = widget.initialValue;
    super.reset();
  }

  /// when the controller changes this function will
  /// update the childController so the [PhoneField] which
  /// deals with the UI can display the correct value.
  void _onControllerChange() {
    final phone = _controller.value;

    widget.onChanged?.call(phone);
    didChange(phone);
    final formatted = _getFormattedNsn();
    if (_childController.national != formatted) {
      _childController.national = formatted;
    }
    if (_childController.isoCode != phone?.isoCode) {
      _childController.isoCode = phone?.isoCode ?? widget.defaultCountry;
    }
  }

  /// when the base controller changes (when the user manually input something)
  /// then we need to update the local controller's value.
  void _onChildControllerChange() {
    if (_childController.national == _controller.value?.nsn &&
        _childController.isoCode == _controller.value?.isoCode) {
      return;
    }

    if (_childController.national == null) {
      return _controller.value = null;
    }
    // we convert the multiple controllers from the child controller
    // to a full blown PhoneNumber to access validation, formatting etc.
    PhoneNumber phoneNumber;
    // when the nsn input change we check if its not a whole number
    // to allow for copy pasting and auto fill. If it is one then
    // we parse it accordingly.
    // we assume it's a whole phone number if it starts with +
    final childNsn = _childController.national;
    if (childNsn != null && childNsn.startsWith(RegExp('[${Patterns.plus}]'))) {
      // if starts with + then we parse the whole number
      // to figure out the country code
      final international = childNsn;
      try {
        phoneNumber = PhoneNumber.parse(international);
      } on PhoneNumberException {
        return;
      }
    } else {
      phoneNumber = PhoneNumber.parse(
        childNsn ?? '',
        destinationCountry: _childController.isoCode,
      );
    }
    _controller.value = phoneNumber;
  }

  String? _getFormattedNsn() {
    if (widget.shouldFormat) {
      return _controller.value?.getFormattedNsn();
    }
    return _controller.value?.nsn;
  }

  /// gets the localized error text if any
  String? getErrorText() {
    if (errorText != null) {
      return ValidatorTranslator.message(context, errorText!);
    }
    return null;
  }
}
