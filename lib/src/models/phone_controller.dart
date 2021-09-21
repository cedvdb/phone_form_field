import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

class PhoneController extends ValueNotifier<PhoneNumber?> {
  final PhoneNumber? initialValue;
  PhoneController(this.initialValue) : super(initialValue);
}
