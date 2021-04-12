import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class CountryButton extends StatelessWidget {
  final Country country;
  final bool showFlag;
  final bool enabled;
  final Function() onPressed;
  final TextStyle textStyle;

  CountryButton({
    required this.country,
    required this.enabled,
    required this.onPressed,
    required this.showFlag,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 50,
      onPressed: enabled ? onPressed : null,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showFlag) ...[
            CircleFlag(
              country.isoCode,
              size: 20,
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
      ),
    );
  }
}
