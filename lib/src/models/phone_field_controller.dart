import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/models/iso_code.dart';

class PhoneFieldController extends ChangeNotifier {
  late final ValueNotifier<Country?> countryController;
  late final TextEditingController nationalNumberController;

  /// focus node of the national number
  final FocusNode focusNode;

  Country? get country => countryController.value;
  String? get national => nationalNumberController.text.isEmpty
      ? null
      : nationalNumberController.text;

  set country(Country? country) => countryController.value = country;

  set national(String? national) {
    final currentSelectionOffset =
        nationalNumberController.selection.extentOffset;
    final isCursorAtEnd =
        currentSelectionOffset == nationalNumberController.text.length;
    // when the cursor is at the end we need to preserve that
    // since there is formatting going on we need to explicitely do it
    nationalNumberController.value = TextEditingValue(
      text: national ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: isCursorAtEnd
              ? (national?.length ?? currentSelectionOffset)
              : currentSelectionOffset,
        ),
      ),
    );
  }

  PhoneFieldController({
    required String? national,
    required Country? country,
    required this.defaultIsoCode,
    required this.focusNode,
  }) {
    countryController = ValueNotifier(country);
    nationalNumberController = TextEditingController(text: national);
    countryController.addListener(notifyListeners);
    nationalNumberController.addListener(notifyListeners);
  }

  selectNationalNumber() {
    nationalNumberController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: nationalNumberController.value.text.length,
    );
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    countryController.dispose();
    nationalNumberController.dispose();
    super.dispose();
  }
}
