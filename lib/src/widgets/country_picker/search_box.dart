import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchBox extends StatelessWidget {
  final Function(String) onChanged;

  SearchBox({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextField(
        autofocus: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white54
                : Colors.black38,
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
