import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phone_form_field/src/models/simple_phone_number.dart';

class PhoneFieldController extends ChangeNotifier {
  ValueNotifier<String> _isoCodeController = ValueNotifier('');
  TextEditingController _nationalController = TextEditingController();
  // when we want to select the national number
  final StreamController _selectionRequest$ = StreamController();
  Stream get selectionRequest$ => _selectionRequest$.stream;

  PhoneFieldController({required Strnational, required this.isoCode});

  selectNationalNumber() {
    _selectionRequest$.add(null);
  }

  @override
  void dispose() {
    _selectionRequest$.close();
    super.dispose();
  }
}
