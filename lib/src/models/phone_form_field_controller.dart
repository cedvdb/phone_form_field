import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

class PhoneController extends ValueNotifier<PhoneNumber?> {
  final PhoneNumber? initialValue;
  // when we want to select the national number
  final StreamController<void> _selectionRequest$ = StreamController();
  Stream<void> get selectionRequest$ => _selectionRequest$.stream;

  PhoneController(this.initialValue) : super(initialValue);

  selectNationalNumber() {
    _selectionRequest$.add(null);
  }

  reset() {
    value = null;
  }

  @override
  void dispose() {
    _selectionRequest$.close();
    super.dispose();
  }
}
