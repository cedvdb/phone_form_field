import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_selector/flutter_country_selector.dart';
import 'package:phone_form_field/src/country_button_style.dart';

@Deprecated('Use [CountryButton] instead')
typedef CountryChip = CountryButton;

class CountryButton extends StatelessWidget {
  final Function()? onTap;
  final IsoCode isoCode;
  final bool enabled;
  final CountryButtonStyle style;

  CountryButton({
    super.key,
    required this.isoCode,
    required this.onTap,
    this.enabled = true,
    @Deprecated('Use [CountryButtonStyle] instead') TextStyle? textStyle,
    @Deprecated('Use [CountryButtonStyle] instead') EdgeInsets? padding,
    @Deprecated('Use [CountryButtonStyle] instead') double? flagSize,
    @Deprecated('Use [CountryButtonStyle] instead') bool? showFlag,
    @Deprecated('Use [CountryButtonStyle] instead') bool? showDialCode = true,
    @Deprecated('Use [CountryButtonStyle] instead') bool? showIsoCode = false,
    CountryButtonStyle style = const CountryButtonStyle(),
  }) : style = style.copyWith(
          showFlag: showFlag,
          showDialCode: showDialCode,
          showIsoCode: showIsoCode,
          padding: padding,
          flagSize: flagSize,
          textStyle: textStyle,
        );

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle ??
        Theme.of(context).textTheme.labelMedium ??
        const TextStyle();
    final countryLocalization = CountrySelectorLocalization.of(context) ??
        CountrySelectorLocalizationEn();
    final countryDialCode = '+ ${countryLocalization.countryDialCode(isoCode)}';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (showIsoCode) ...[
              Text(
                isoCode.name,
                style: textStyle.copyWith(
                  color: enabled ? null : Theme.of(context).disabledColor,
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (showFlag) ...[
              ExcludeSemantics(
                child: CircleFlag(
                  isoCode.name,
                  size: flagSize,
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (showDialCode) ...[
              Text(
                countryDialCode,
                style: textStyle.copyWith(
                  color: enabled ? null : Theme.of(context).disabledColor,
                ),
              ),
            ],
            if (showDropdownIndicator)
              const ExcludeSemantics(child: Icon(Icons.arrow_drop_down)),
          ],
        ),
      ),
    );
  }
}
