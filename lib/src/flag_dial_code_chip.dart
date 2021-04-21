import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class FlagDialCodeChip extends StatelessWidget {
  final Country country;
  final bool showFlag;
  final bool enabled;
  final Function() onPressed;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final double flagSize;

  FlagDialCodeChip({
    required this.country,
    required this.enabled,
    required this.onPressed,
    required this.showFlag,
    required this.textStyle,
    this.padding = const EdgeInsets.all(20),
    this.flagSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showFlag) ...[
          CircleFlag(
            country.isoCode,
            size: this.flagSize,
          ),
          SizedBox(
            width: 8,
          ),
        ],
        Text(
          country.getDialCodeForDisplay(),
          style: textStyle,
        ),
      ],
    );
  }
}