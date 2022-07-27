part of 'phone_field.dart';

class PhoneFieldState extends State<PhoneField> {
  PhoneFieldController get controller => widget.controller;

  PhoneFieldState();

  @override
  void initState() {
    controller.focusNode.addListener(onFocusChange);
    super.initState();
  }

  void onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    controller.focusNode.removeListener(onFocusChange);
    super.dispose();
  }

  void selectCountry() async {
    if (!widget.isCountrySelectionEnabled) {
      return;
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    final selected = await widget.selectorNavigator.navigate(context);
    if (selected != null) {
      controller.isoCode = selected.isoCode;
    }
    controller.focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  @override
  Widget build(BuildContext context) {
    // the idea here is to have a mouse region that surround every thing
    // that has a text cursor.
    // When the country chip is not shown it request focus.
    // When the country chip is shown, clicking on it request country selection
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: GestureDetector(
        onTap: controller.focusNode.requestFocus,
        child: AbsorbPointer(
          // absorb pointer when the country chip is not shown, else flutter
          // still allows the country chip to be clicked even though it is not shown
          absorbing: _isEffectivelyEmpty() && !controller.focusNode.hasFocus,
          child: InputDecorator(
            decoration: _getOutterInputDecoration(),
            isFocused: controller.focusNode.hasFocus,
            isEmpty: _isEffectivelyEmpty(),
            child: TextField(
              focusNode: controller.focusNode,
              controller: controller.nationalNumberController,
              enabled: widget.enabled,
              decoration: _getInnerInputDecoration(),
              inputFormatters: widget.inputFormatters ??
                  [
                    FilteringTextInputFormatter.allow(RegExp(
                        '[${Constants.plus}${Constants.digits}${Constants.punctuation}]')),
                  ],
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
              toolbarOptions: widget.toolbarOptions,
              showCursor: widget.showCursor,
              onEditingComplete: widget.onEditingComplete,
              onSubmitted: widget.onSubmitted,
              onAppPrivateCommand: widget.onAppPrivateCommand,
              cursorWidth: widget.cursorWidth,
              cursorHeight: widget.cursorHeight,
              cursorRadius: widget.cursorRadius,
              cursorColor: widget.cursorColor,
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
              enableIMEPersonalizedLearning:
                  widget.enableIMEPersonalizedLearning,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getCountryCodeChip() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: selectCountry,
        // material here else the click pass through empty spaces
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
            child: CountryCodeChip(
              key: const ValueKey('country-code-chip'),
              isoCode: controller.isoCode,
              showFlag: widget.showFlagInInput,
              textStyle: widget.countryCodeStyle ??
                  widget.decoration.labelStyle ??
                  TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.caption?.color,
                  ),
              flagSize: widget.flagSize,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _getInnerInputDecoration() {
    return InputDecoration.collapsed(
      hintText: widget.decoration.hintText,
      hintStyle: widget.decoration.hintStyle,
    ).copyWith(
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
    );
  }

  InputDecoration _getOutterInputDecoration() {
    return widget.decoration.copyWith(
      hintText: null,
      errorText: widget.errorText,
      prefix: _getCountryCodeChip(),
    );
  }

  bool _isEffectivelyEmpty() {
    if (widget.isCountryChipPersistent) return false;
    final outterDecoration = _getOutterInputDecoration();
    // when there is not label and an hint text we need to have
    // isEmpty false so the country code is displayed along the
    // hint text to not have the hint text in the middle
    if (outterDecoration.label == null && outterDecoration.hintText != null) {
      return false;
    }
    return controller.nationalNumberController.text.isEmpty;
  }
}
