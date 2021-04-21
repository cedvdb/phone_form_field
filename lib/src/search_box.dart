import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchBox extends StatelessWidget {
  final Function(String) onChanged;

  SearchBox({required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextField(
        // autofocussing the search field here displays the keyboard on phones
        // and it looks ugly. On bigger screen it looks better. We will just
        // test if it's web
        autofocus: kIsWeb,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(
            FontAwesomeIcons.search,
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
