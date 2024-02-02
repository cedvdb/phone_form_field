part of 'phone_form_field.dart';

class PhoneFormFieldState extends FormFieldState<PhoneNumber> {
  late final PhoneController controller;
  late final FocusNode focusNode;

  @override
  PhoneFormField get widget => super.widget as PhoneFormField;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        PhoneController(
          initialValue: widget.initialValue ??
              const PhoneNumber(isoCode: IsoCode.US, nsn: ''),
        );
    focusNode = widget.focusNode ?? FocusNode();
  }

  /// gets the localized error text if any
  String? getErrorText() {
    final errorText = this.errorText;
    if (errorText != null) {
      return ValidatorTranslator.message(context, errorText);
    }
    return null;
  }
}
