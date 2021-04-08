import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class CountryButton extends StatelessWidget {
  final Country country;
  final bool showFlag;
  final Function() onPressed;
  final TextStyle textStyle;

  CountryButton({
    required this.country,
    required this.onPressed,
    required this.showFlag,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
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
            country.dialCode,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
