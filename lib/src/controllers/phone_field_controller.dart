import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

class PhoneFieldController extends ChangeNotifier {
  late final ValueNotifier<IsoCode> isoCodeController;
  late final TextEditingController nationalNumberController;

  /// focus node of the national number
  final FocusNode focusNode;

  IsoCode get isoCode => isoCodeController.value;
  String? get national => nationalNumberController.text;

  set isoCode(IsoCode isoCode) => isoCodeController.value = isoCode;

  set national(String? national) {
    national = national ?? '';
    final currentSelectionOffset =
        nationalNumberController.selection.extentOffset;
    final isCursorAtEnd =
        currentSelectionOffset == nationalNumberController.text.length;
    var offset = national.length;

    if (isCursorAtEnd) {
      offset = national.length;
    } else if (currentSelectionOffset <= national.length) {
      offset = currentSelectionOffset;
    }
    // when the cursor is at the end we need to preserve that
    // since there is formatting going on we need to explicitely do it
    nationalNumberController.value = TextEditingValue(
      text: national,
      selection: TextSelection.fromPosition(
        TextPosition(offset: offset),
      ),
    );
  }

  PhoneFieldController({
    required String? national,
    required IsoCode isoCode,
    required this.focusNode,
  }) {
    isoCodeController = ValueNotifier(isoCode);
    nationalNumberController = TextEditingController(text: national);
    isoCodeController.addListener(notifyListeners);
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
    isoCodeController.dispose();
    nationalNumberController.dispose();
    super.dispose();
  }
}
