part of 'phone_form_field.dart';

class PhoneFormFieldState extends FormFieldState<PhoneNumber> {
  late final PhoneController controller;
  late final FocusNode focusNode;

  int? _maxValidLength;

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
    controller.addListener(_onControllerValueChanged);
    focusNode = widget.focusNode ?? FocusNode();

    if (widget.limitLength) {
      _changeMaxValidLength();
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerValueChanged);
    super.dispose();
  }

  // overriding method from FormFieldState
  @override
  void didChange(PhoneNumber? value) {
    if (value == null) {
      return;
    }
    super.didChange(value);

    if (controller.value != value) {
      controller.value = value;
    }
  }

  void _onControllerValueChanged() {
    /// when the controller changes because the user called
    /// controller.value = x we need to change the value of the form field
    if (controller.value != value) {
      didChange(controller.value);
    }
  }

  void _onTextfieldChanged(String value) {
    controller.changeNationalNumber(value);
    didChange(controller.value);
    widget.onChanged?.call(controller.value);
  }

  // overriding method of form field, so when the user resets a form,
  // and subsequently every form field descendant, the controller is updated
  @override
  void reset() {
    controller.value = controller.initialValue;
    super.reset();
  }

  void _selectCountry(BuildContext context) async {
    if (!widget.isCountrySelectionEnabled) {
      return;
    }
    final selected = await widget.countrySelectorNavigator.show(context);
    if (selected != null) {
      controller.changeCountry(selected);
      didChange(controller.value);
      widget.onChanged?.call(controller.value);

      if (widget.limitLength) {
        _changeMaxValidLength();
      }
    }
    focusNode.requestFocus();
  }

  Widget builder() {
    final textAlignment = _computeTextAlign();
    final countryButtonForEachSlot =
        _buildCountryButtonForEachSlot(textAlignment);
    return PhoneFieldSemantics(
      hasFocus: focusNode.hasFocus,
      enabled: widget.enabled,
      inputDecoration: widget.decoration,
      child: TextField(
        maxLength: _maxValidLength,
        decoration: widget.decoration.copyWith(
          errorText: errorText,
          prefix: countryButtonForEachSlot[_CountryButtonSlot.prefix],
          prefixIcon: countryButtonForEachSlot[_CountryButtonSlot.prefixIcon],
          suffix: countryButtonForEachSlot[_CountryButtonSlot.suffix],
          suffixIcon: countryButtonForEachSlot[_CountryButtonSlot.suffixIcon],
        ),
        controller: controller._formattedNationalNumberController,
        focusNode: focusNode,
        enabled: widget.enabled,
        inputFormatters: widget.inputFormatters ??
            [
              FilteringTextInputFormatter.allow(RegExp(
                  '[${AllowedCharacters.plus}${AllowedCharacters.digits}${AllowedCharacters.punctuation}]')),
            ],
        onChanged: _onTextfieldChanged,
        textAlign: _computeTextAlign(),
        autofillHints: widget.autofillHints,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        style: widget.style,
        strutStyle: widget.strutStyle,
        textAlignVertical: widget.textAlignVertical,
        autofocus: widget.autofocus,
        obscuringCharacter: widget.obscuringCharacter,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
        enableSuggestions: widget.enableSuggestions,
        showCursor: widget.showCursor,
        onEditingComplete: widget.onEditingComplete,
        onSubmitted: (_) => widget.onSubmitted?.call(controller.value),
        onAppPrivateCommand: widget.onAppPrivateCommand,
        cursorWidth: widget.cursorWidth,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorColor: widget.cursorColor,
        onTapOutside: widget.onTapOutside,
        selectionHeightStyle: widget.selectionHeightStyle,
        selectionWidthStyle: widget.selectionWidthStyle,
        keyboardAppearance: widget.keyboardAppearance,
        scrollPadding: widget.scrollPadding,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        selectionControls: widget.selectionControls,
        mouseCursor: widget.mouseCursor,
        scrollController: widget.scrollController,
        scrollPhysics: widget.scrollPhysics,
        restorationId: widget.restorationId,
        enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      ),
    );
  }

  TextAlign _computeTextAlign() {
    final directionality = Directionality.of(context);
    return directionality == TextDirection.ltr
        ? TextAlign.start
        : TextAlign.end;
  }

  /// returns where the country button is placed in the input
  Map<_CountryButtonSlot, Widget?> _buildCountryButtonForEachSlot(
    TextAlign textAlign,
  ) {
    final countryButton = _buildCountryButton(context);
    if (textAlign == TextAlign.start) {
      if (widget.isCountryButtonPersistent) {
        return {_CountryButtonSlot.prefixIcon: countryButton};
      } else {
        return {_CountryButtonSlot.prefix: countryButton};
      }
    } else {
      if (widget.isCountryButtonPersistent) {
        return {_CountryButtonSlot.suffixIcon: countryButton};
      } else {
        return {_CountryButtonSlot.suffix: countryButton};
      }
    }
  }

  Widget _buildCountryButton(BuildContext context) {
    return ExcludeFocus(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => CountryButton(
            key: const ValueKey('country-code-chip'),
            isoCode: controller.value.isoCode,
            onTap: widget.enabled ? () => _selectCountry(context) : null,
            padding: _computeCountryButtonPadding(context),
            showFlag: widget.countryButtonStyle.showFlag,
            showIsoCode: widget.countryButtonStyle.showIsoCode,
            showDialCode: widget.countryButtonStyle.showDialCode,
            showDropdownIcon: widget.countryButtonStyle.showDropdownIcon,
            dropdownIconColor: widget.countryButtonStyle.dropdownIconColor,
            textStyle: widget.countryButtonStyle.textStyle,
            flagSize: widget.countryButtonStyle.flagSize,
            enabled: widget.enabled,
          ),
        ),
      ),
    );
  }

  /// computes the padding inside the country button
  /// this is used to align the flag and dial code with the rest
  /// of the phone number.
  /// The padding must work for this matrix:
  /// - has label or not
  /// - is border underline or outline
  /// - is country button shown as a prefix or prefixIcon (isCountryChipPersistent)
  /// - text direction
  EdgeInsets _computeCountryButtonPadding(BuildContext context) {
    final userDefinedPadding = widget.countryButtonStyle.padding;
    final isUnderline = widget.decoration.border is UnderlineInputBorder;
    final hasLabel =
        widget.decoration.label != null || widget.decoration.labelText != null;
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    EdgeInsets padding = isLtr
        ? const EdgeInsets.fromLTRB(12, 16, 4, 16)
        : const EdgeInsets.fromLTRB(4, 16, 12, 16);
    if (userDefinedPadding != null) {
      return userDefinedPadding;
    }
    if (!widget.isCountryButtonPersistent) {
      padding = isLtr
          ? const EdgeInsets.only(right: 4, left: 12)
          : const EdgeInsets.only(left: 4, right: 12);
    } else if (isUnderline && hasLabel) {
      padding = isLtr
          ? const EdgeInsets.fromLTRB(12, 25, 4, 7)
          : const EdgeInsets.fromLTRB(4, 25, 12, 7);
    } else if (isUnderline && !hasLabel) {
      padding = isLtr
          ? const EdgeInsets.fromLTRB(12, 2, 4, 0)
          : const EdgeInsets.fromLTRB(4, 2, 12, 0);
    }
    return padding;
  }

  // Updates `_maxValidLength` based on the selected country's maximum valid phone number length.
  //
  // 1. We retrieve the longest possible valid NSN length (mobile or fixed line) for the selected isoCode.
  //    This ensures we allow users to enter the full number, regardless of type.
  //
  // 2. We get an example number from the metadata for that isoCode and pad it to match the maximum length.
  //    This gives us a realistic phone number to simulate formatting.
  //
  // 3. We format the number using `.formatNsn()` — this applies national formatting (spaces, dashes, etc).
  //    Since this formatted version is what the user sees in the input field, we use its length as the
  //    `maxLength` constraint on the TextField.
  //
  // Note: The formatted length may be longer than the raw digit length due to separators.
  // Setting the max length based on formatting ensures the user can complete their input.
  void _changeMaxValidLength() {
    final isoCode = controller.value.isoCode;

    // We select the last possible length for the selected isoCode, because a
    // country can have multipe max length numbers and they are stored in
    // ascending order in phone_numbers_parser package. As this package
    // supports both, fixed and mobile numbers we need to get the max of them

    final maxMobileLengthForSelectedIso =
        metadataLenghtsByIsoCode[isoCode]?.mobile.last;

    final maxFixedLengthForSelectedIso =
        metadataLenghtsByIsoCode[isoCode]?.fixedLine.last;

    if (maxMobileLengthForSelectedIso == null &&
        maxFixedLengthForSelectedIso == null) {
      return;
    }

    int? maxLength;
    String? nsnExample;

    if (maxMobileLengthForSelectedIso != null &&
        maxMobileLengthForSelectedIso > (maxFixedLengthForSelectedIso ?? 0)) {
      maxLength = maxMobileLengthForSelectedIso;
      nsnExample = metadataExamplesByIsoCode[isoCode]?.mobile;
    } else {
      maxLength = maxFixedLengthForSelectedIso;
      nsnExample = metadataExamplesByIsoCode[isoCode]?.fixedLine;
    }

    if (maxLength == null || nsnExample == null) {
      return;
    }

    final nsn = _padExampleNsn(nsnExample, maxLength);

    // .formatNsn() returns the formatted nsn number, which is the actual
    // value inside the TextField
    final finalMaxLength = PhoneNumber(isoCode: isoCode, nsn: nsn).formatNsn();

    _maxValidLength = finalMaxLength.length;
  }

  // Pads the given example number with 0s to match the total length.
  // If the example is longer than needed, it trims it.
  String _padExampleNsn(String example, int totalLength) {
    if (example.length >= totalLength) {
      return example.substring(0, totalLength);
    }
    return example.padRight(totalLength, '0');
  }
}

enum _CountryButtonSlot {
  prefix,
  prefixIcon,
  suffix,
  suffixIcon,
}
