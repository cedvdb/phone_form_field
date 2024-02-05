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
              // remove this line when defaultCountry is removed (now deprecated)
              // and just use the US default country if no initialValue is set
              PhoneNumber(isoCode: widget.defaultCountry, nsn: ''),
        );
    controller.addListener(_onControllerValueChanged);
    focusNode = widget.focusNode ?? FocusNode();
    CountrySelector.preloadFlags();
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

  void _selectCountry() async {
    if (!widget.isCountrySelectionEnabled) {
      return;
    }
    final selected = await widget.countrySelectorNavigator.show(context);
    if (selected != null) {
      controller.changeCountry(selected);
    }
    focusNode.requestFocus();
  }

  Widget builder() {
    final localization = PhoneFieldLocalization.of(context);
    return Semantics(
      label: localization.enterPhoneNumber,
      child: TextField(
        decoration: widget.decoration.copyWith(
          errorText: errorText,
          prefixIcon: widget.isCountryButtonPersistent
              ? _getCountryCodeChip(context)
              : null,
          prefix: widget.isCountryButtonPersistent
              ? null
              : _getCountryCodeChip(context),
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
        autofillHints: widget.autofillHints,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        style: widget.style,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
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

  Widget _getCountryCodeChip(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => CountryButton(
        key: const ValueKey('country-code-chip'),
        isoCode: controller.value.isoCode,
        onTap: widget.enabled ? _selectCountry : null,
        padding: _computeCountryButtonPadding(context),
        showFlag: widget.showFlagInInput,
        showIsoCode: widget.showIsoCodeInInput,
        showDialCode: widget.showDialCode,
        textStyle: widget.countryCodeStyle ??
            widget.decoration.labelStyle ??
            TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
        flagSize: widget.flagSize,
        enabled: widget.enabled,
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
    final countryButtonPadding = widget.countryButtonPadding;
    final isUnderline = widget.decoration.border is UnderlineInputBorder;
    final hasLabel =
        widget.decoration.label != null || widget.decoration.labelText != null;
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    EdgeInsets padding = isLtr
        ? const EdgeInsets.fromLTRB(12, 16, 4, 16)
        : const EdgeInsets.fromLTRB(4, 16, 12, 16);
    if (countryButtonPadding != null) {
      padding = countryButtonPadding;
    } else if (!widget.isCountryButtonPersistent) {
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
}
