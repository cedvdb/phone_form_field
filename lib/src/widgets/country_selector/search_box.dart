import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final Function(String) onChanged;
  final bool autofocus;
  final InputDecoration? decoration;
  final TextStyle? style;
  final Color? searchIconColor;

  const SearchBox({
    Key? key,
    required this.onChanged,
    required this.autofocus,
    this.decoration,
    this.style,
    this.searchIconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextField(
        autofocus: autofocus,
        onChanged: onChanged,
        style: style,
        decoration: decoration ??
            InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color:
                    searchIconColor ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black38),
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
