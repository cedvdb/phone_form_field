import 'package:flutter/material.dart';

class SwitchEl extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const SwitchEl({
    required this.value,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
        ),
        Text(title),
      ],
    );
  }
}
