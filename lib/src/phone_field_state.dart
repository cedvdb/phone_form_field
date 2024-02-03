part of 'phone_field.dart';

class PhoneFieldState extends State<PhoneField> {
  PhoneController get controller => widget.controller;
  FocusNode get focusNode => widget.focusNode;
  PhoneFieldState();

  @override
  void initState() {
    _preloadFlagsInMemory();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _preloadFlagsInMemory() {
    CircleFlag.preload(IsoCode.values.map((isoCode) => isoCode.name).toList());
  }

  void selectCountry() async {
    if (!widget.isCountrySelectionEnabled) {
      return;
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    final selected = await widget.selectorNavigator.navigate(context);
    if (selected != null) {
      controller.changeCountry(selected.isoCode);
    }
    focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  static Widget _defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: focusNode,
        builder: (context, _) {
          return TextFormField(
            decoration: widget.decoration.copyWith(
              errorText: widget.errorText,
              prefixIcon: _getCountryCodeChip(),
            ),
            focusNode: focusNode,
            controller: controller.nationalNumberController,
            enabled: widget.enabled,
            // decoration: _getInnerInputDecoration(),
            inputFormatters: widget.inputFormatters ??
                [
                  FilteringTextInputFormatter.allow(RegExp(
                      '[${AllowedCharacters.plus}${AllowedCharacters.digits}${AllowedCharacters.punctuation}]')),
                ],
            onChanged: (txt) => controller.changeText(txt),
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
            contextMenuBuilder:
                widget.contextMenuBuilder ?? _defaultContextMenuBuilder,
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
          );
        });
  }

  Widget? _getCountryCodeChip() {
    if (widget.isCountryChipPersistent || focusNode.hasFocus) {
      return InkWell(
        onTap: widget.enabled ? selectCountry : null,
        child: Padding(
          padding: _computeCountryButtonPadding(),
          child: CountryChip(
            key: const ValueKey('country-code-chip'),
            isoCode: controller.value.isoCode,
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
        ),
      );
    }
    return null;
  }

  EdgeInsets _computeCountryButtonPadding() {
    final countryButtonPadding = widget.countryButtonPadding;
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 12, vertical: 16);
    final isUnderline = widget.decoration.border is UnderlineInputBorder;
    final hasLabel =
        widget.decoration.label != null || widget.decoration.labelText != null;
    if (countryButtonPadding != null) {
      padding = countryButtonPadding;
    } else if (isUnderline && hasLabel) {
      padding = const EdgeInsets.fromLTRB(12, 25, 12, 7);
    } else if (isUnderline && !hasLabel) {
      padding = const EdgeInsets.fromLTRB(12, 2, 12, 0);
    }
    return padding;
  }
}
