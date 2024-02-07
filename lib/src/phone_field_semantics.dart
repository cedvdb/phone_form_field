import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

/// Will talk back the following:
/// "Editbox, Phone number, detected text: +1 650 555 1234", ...
/// It will not give access to the country selection button, as the
/// user can just type the full phone number inside the text field
class PhoneFieldSemantics extends StatelessWidget {
  final Widget child;
  final bool hasFocus;
  final bool enabled;
  final InputDecoration inputDecoration;

  const PhoneFieldSemantics({
    super.key,
    required this.child,
    required this.hasFocus,
    required this.enabled,
    required this.inputDecoration,
  });

  @override
  Widget build(BuildContext context) {
    String label = PhoneFieldLocalization.of(context).phoneNumber;
    final labelText = inputDecoration.labelText ?? '';
    final hintText = inputDecoration.hintText ?? '';
    if (labelText.isNotEmpty) {
      label = labelText;
    } else if (hintText.isNotEmpty) {
      label = hintText;
    }

    return Semantics(
      label: label,
      textField: true,
      container: true,
      focusable: true,
      focused: hasFocus,
      enabled: enabled,
      child: ExcludeSemantics(
        child: child,
      ),
    );
  }
}
