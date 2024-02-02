import 'package:flutter/material.dart';
import 'package:phone_form_field/l10n/generated/phone_field_localization.dart';

class SearchBox extends StatefulWidget {
  final Function(String) onChanged;
  final Function() onSubmitted;
  final bool autofocus;
  final InputDecoration? decoration;
  final TextStyle? style;
  final Color? searchIconColor;

  const SearchBox({
    super.key,
    required this.onChanged,
    required this.onSubmitted,
    required this.autofocus,
    this.decoration,
    this.style,
    this.searchIconColor,
  });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  String _previousValue = '';

  @override
  void initState() {
    super.initState();
  }

  void handleChange(text) {
    widget.onChanged(text);

    final isAutofill = text.length > 3 && _previousValue == '';
    if (isAutofill) {
      widget.onSubmitted();
    }
    _previousValue = text;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: widget.autofocus,
      onChanged: handleChange,
      onSubmitted: (_) => widget.onSubmitted(),
      cursorColor: widget.style?.color,
      style: widget.style ?? Theme.of(context).textTheme.titleLarge,
      autofillHints: const [AutofillHints.countryName],
      decoration: widget.decoration ??
          InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              size: 24,
            ),
            filled: true,
            isDense: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
            hintText: PhoneFieldLocalization.of(context)?.search,
          ),
    );
  }
}
