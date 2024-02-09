part of 'phone_form_field.dart';

class PhoneFormFieldState extends FormFieldState<PhoneNumber> {
  late PhoneController _controller;
  PhoneController get controller => _controller;

  late final FocusNode focusNode;

  @override
  PhoneFormField get widget => super.widget as PhoneFormField;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? _newLocalController();
    _controller.addListener(_onControllerValueChanged);
    focusNode = widget.focusNode ?? FocusNode();
    CountrySelector.preloadFlags();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerValueChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(PhoneFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerValueChanged);
      widget.controller?.addListener(_onControllerValueChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        // Old: has controller
        // New: has no controller
        // Result: create local controller without disposing the old one (owned by old widget)
        _controller = _newLocalController();
      }

      if (widget.controller != null) {
        setValue(widget.controller!.value);
        if (oldWidget.controller == null) {
          // Old: hasn't controller
          // New: has controller
          // Result: dispose old controller and set controller to new one
          _controller.dispose();
          _controller = widget.controller!;
        }
      }
    }
  }

  // overriding method from FormFieldState
  @override
  void didChange(PhoneNumber? value) {
    if (value == null) {
      return;
    }
    super.didChange(value);

    if (_controller.value != value) {
      _controller.value = value;
    }
  }

  void _onControllerValueChanged() {
    /// when the controller changes because the user called
    /// controller.value = x we need to change the value of the form field
    if (_controller.value != value) {
      didChange(_controller.value);
    }
  }

  void _onTextfieldChanged(String value) {
    _controller.changeNationalNumber(value);
    didChange(_controller.value);
    widget.onChanged?.call(_controller.value);
  }

  // overriding method of form field, so when the user resets a form,
  // and subsequently every form field descendant, the controller is updated
  @override
  void reset() {
    if (_controller.initialValue case final initialValue) {
      _controller.value = initialValue;
    }

    super.reset();
  }

  void _selectCountry() async {
    if (!widget.isCountrySelectionEnabled) {
      return;
    }
    final selected = await widget.countrySelectorNavigator.show(context);
    if (selected != null) {
      _controller.changeCountry(selected);
    }
    focusNode.requestFocus();
  }

  PhoneController _newLocalController() => PhoneController(
        initialValue: widget.initialValue ??
            // remove this line when defaultCountry is removed (now deprecated)
            // and just use the US default country if no initialValue is set
            PhoneNumber(isoCode: widget.defaultCountry, nsn: ''),
      );

  Widget builder() {
    return PhoneFieldSemantics(
      hasFocus: focusNode.hasFocus,
      enabled: widget.enabled,
      inputDecoration: widget.decoration,
      child: TextField(
        decoration: widget.decoration.copyWith(
          errorText: errorText,
          prefixIcon: widget.isCountryButtonPersistent ? _buildCountryCodeChip(context) : null,
          prefix: widget.isCountryButtonPersistent ? null : _buildCountryCodeChip(context),
        ),
        controller: _controller._formattedNationalNumberController,
        focusNode: focusNode,
        enabled: widget.enabled,
        inputFormatters: widget.inputFormatters ??
            [
              FilteringTextInputFormatter.allow(
                  RegExp('[${AllowedCharacters.plus}${AllowedCharacters.digits}${AllowedCharacters.punctuation}]')),
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

  Widget _buildCountryCodeChip(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CountryButton(
        key: const ValueKey('country-code-chip'),
        isoCode: _controller.value.isoCode,
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
    final hasLabel = widget.decoration.label != null || widget.decoration.labelText != null;
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    EdgeInsets padding = isLtr ? const EdgeInsets.fromLTRB(12, 16, 4, 16) : const EdgeInsets.fromLTRB(4, 16, 12, 16);
    if (countryButtonPadding != null) {
      padding = countryButtonPadding;
    } else if (!widget.isCountryButtonPersistent) {
      padding = isLtr ? const EdgeInsets.only(right: 4, left: 12) : const EdgeInsets.only(left: 4, right: 12);
    } else if (isUnderline && hasLabel) {
      padding = isLtr ? const EdgeInsets.fromLTRB(12, 25, 4, 7) : const EdgeInsets.fromLTRB(4, 25, 12, 7);
    } else if (isUnderline && !hasLabel) {
      padding = isLtr ? const EdgeInsets.fromLTRB(12, 2, 4, 0) : const EdgeInsets.fromLTRB(4, 2, 12, 0);
    }
    return padding;
  }
}
