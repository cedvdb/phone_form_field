library base_form_field;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// This class is used to create a TextFormField, with a child instead
/// of a EditableText
class BaseFormField<T> extends FormField<T> {
  final InputDecoration decoration;
  final ValueChanged<T?>? onChanged;

  BaseFormField({
    Key? key,
    void Function(T?)? onSaved,
    T? initialValue,
    bool enabled = true,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    String? Function(T?)? validator,
    this.decoration = const InputDecoration(),
    this.onChanged,
    required FormFieldBuilder<T> builder,
  }) : super(
          key: key,
          onSaved: onSaved,
          initialValue: initialValue,
          enabled: enabled,
          autovalidateMode: autovalidateMode,
          validator: validator,
          builder: builder,
        );
}

class BaseFormFieldState<T> extends FormFieldState<T> {
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  bool get hasError => (widget as dynamic).decoration?.errorText != null;
  bool _isHovering = false;

  @override
  BaseFormField<T> get widget => super.widget as BaseFormField<T>;

  /// descendants can override this move the label
  bool get isEmpty => value == null;

  /// descendants can override this to show another text
  getErrorText() => errorText;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChange(dynamic value) {
    super.didChange(value);
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void _handleHover(bool hovering) {
    if (hovering != _isHovering) {
      setState(() => _isHovering = hovering);
    }
  }

  Widget wrapper(Widget child) {
    return MouseRegion(
      cursor: _getMouseCursor(),
      onEnter: (PointerEnterEvent event) => _handleHover(true),
      onExit: (PointerExitEvent event) => _handleHover(false),
      child: GestureDetector(
        onTap: () => focusNode.requestFocus(),
        child: IgnorePointer(
          ignoring: !widget.enabled,
          child: InputDecorator(
            isFocused: focusNode.hasFocus,
            isEmpty: isEmpty,
            isHovering: _isHovering,
            decoration: _getInputDecoration(),
            child: child,
          ),
        ),
      ),
    );
  }

  MouseCursor _getMouseCursor() {
    return MaterialStateProperty.resolveAs<MouseCursor>(
      MaterialStateMouseCursor.textable,
      <MaterialState>{
        if (!widget.enabled) MaterialState.disabled,
        if (_isHovering) MaterialState.hovered,
        if (focusNode.hasFocus) MaterialState.focused,
        if (hasError) MaterialState.error,
      },
    );
  }

  InputDecoration _getInputDecoration() {
    return widget.decoration.copyWith(
      errorText: getErrorText(),
    );
  }
}
