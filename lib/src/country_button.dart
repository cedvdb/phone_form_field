import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class CountryButton extends StatelessWidget {
  final Country country;
  final bool showFlag;
  final Function() onPressed;
  final TextStyle textStyle;
  final bool displayLeadingDigitsInDialCode;

  CountryButton({
    required this.country,
    required this.onPressed,
    required this.showFlag,
    required this.textStyle,
    required this.displayLeadingDigitsInDialCode,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 50,
      onPressed: onPressed,
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
            country.getDialCodeForDisplay(
              withLeadingDigits: displayLeadingDigitsInDialCode,
            ),
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
