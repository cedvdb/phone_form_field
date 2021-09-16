import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';

import '../models/country.dart';

class FlagDialCodeChip extends StatelessWidget {
  final Country country;
  final bool showFlag;
  final bool showDialCode;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final double flagSize;

  FlagDialCodeChip({
    Key? key,
    required this.country,
    this.textStyle = const TextStyle(),
    this.showFlag = true,
    this.showDialCode = true,
    this.padding = const EdgeInsets.all(20),
    this.flagSize = 20,
  }) : super(key: key);

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
        if (showDialCode)
          Text(
            country.displayDialCode,
            style: textStyle,
          ),
      ],
    );
  }
}
