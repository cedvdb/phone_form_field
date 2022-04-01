part of 'phone_field.dart';

class _PhoneFieldState extends State<PhoneField> {
  /// size of input so we can render inkwell at correct height
  Size? _sizeInput;
  Size? _countryCodeSize;

  bool get _isOutlineBorder => widget.decoration.border is OutlineInputBorder;
  PhoneFieldController get controller => widget.controller;

  _PhoneFieldState();

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
    // The idea here is to have an InputDecorat with a prefix where the prefix
    // is the flag + country code which visible (when focussed).
    // Then we stack an InkWell with the country code (invisible) so
    // it is the right width
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: Stack(
        children: [
          MeasureSize(
            onChange: (size) => setState(() => _sizeInput = size),
            child: GestureDetector(
              onTap: () => controller.focusNode.requestFocus(),
              child: _textField(),
            ),
          ),
          if (controller.focusNode.hasFocus || controller.national != null)
            _getInkWellOverlay(),
        ],
      ),
    );
  }

  Widget _textField() {
    return InputDecorator(
      decoration: _getOutterInputDecoration(),
      isFocused: controller.focusNode.hasFocus,
      isEmpty: _isEffectivelyEmpty(),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: controller.focusNode,
              controller: controller.nationalNumberController,
              enabled: widget.enabled,
              decoration: _getInnerInputDecoration(),
              inputFormatters: [
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
              textDirection: widget.textDirection,
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
        ],
      ),
    );
  }

  /// gets the inkwell that is displayed on top of the input
  /// for feedback on country code click
  Widget _getInkWellOverlay() {
    // width and height calculation are a bit hacky but a better way
    // that works when the input is resized was not found
    var height = _sizeInput?.height ?? 0;
    var width = _countryCodeSize?.width ?? 0;
    // when there is an error the widget height contains the error
    // se we need to remove the error height
    if (widget.errorText != null) {
      height -= 20;
    }

    if (_isOutlineBorder) {
      // outline border adds padding to the left
      width += 12;
    }

    if (widget.decoration.prefixIconConstraints != null) {
      width += widget.decoration.prefixIconConstraints!.maxWidth;
    } else if (widget.decoration.prefixIcon != null) {
      // prefix icon default size is 48px
      width += 48;
    }

    return InkWell(
      key: const ValueKey('country-code-overlay'),
      onTap: () {},
      onTapDown: (_) => selectCountry(),
      child: SizedBox(
        height: height,
        width: width,
      ),
    );
  }

  Widget _getCountryCodeChip() {
    return MeasureSize(
      onChange: (size) => setState(() => _countryCodeSize = size),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
    );
  }

  InputDecoration _getInnerInputDecoration() {
    return InputDecoration.collapsed(
      hintText: widget.decoration.hintText,
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
