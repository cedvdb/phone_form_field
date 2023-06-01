import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final Function(String) onChanged;
  final Function() onSubmitted;
  final bool autofocus;
  final InputDecoration? decoration;
  final TextStyle? style;
  final Color? searchIconColor;

  const SearchBox({
    Key? key,
    required this.onChanged,
    required this.onSubmitted,
    required this.autofocus,
    this.decoration,
    this.style,
    this.searchIconColor,
  }) : super(key: key);

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  String _previousValue = '';

  @override
  void initState() {
    super.initState();
  }

  void handleChange(e) {
    widget.onChanged(e);

    // detect length difference
    final diff = e.length - _previousValue.length;
    if (diff > 3) {
      // more than 3 characters added, probably a paste / autofill of country name
      widget.onSubmitted();
    }

    setState(() {
      _previousValue = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextField(
        autofocus: widget.autofocus,
        onChanged: handleChange,
        onSubmitted: (_) => widget.onSubmitted(),
        cursorColor: widget.style?.color,
        style: widget.style,
        autofillHints: const [AutofillHints.countryName],
        decoration: widget.decoration ??
            InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: widget.searchIconColor ??
                    (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white54
                        : Colors.black38),
              ),
              filled: true,
              isDense: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
      ),
    );
  }
}
