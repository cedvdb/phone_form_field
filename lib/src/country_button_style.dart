import 'package:material_ui/material_ui.dart';

class CountryButtonStyle {
  /// Text style of the country dial code inside the country button
  final TextStyle? textStyle;

  /// padding inside country button,
  /// this can be used to align the country button with the phone number
  /// and is mostly useful when using [isCountryButtonPersistent] as true.
  final EdgeInsets? padding;

  /// The radius of the flag in the country button
  final double flagSize;

  /// Whether to show the country flag in the country button
  final bool showFlag;

  /// Whether to show Dial Code in the country button
  /// setting this to false will hide, for example, (+1)
  final bool showDialCode;

  /// Wether to show the country iso code in the country button
  final bool showIsoCode;

  /// Wether to show the dropdown icon in the country button
  final bool showDropdownIcon;

  /// Color for the dropdown icon. Only used while [showDropdownIcon] is true.
  final Color? dropdownIconColor;

  final BorderRadius? borderRadius;

  /// {@template phone_form_field.CountryButtonStyle.suffix}
  /// A widget displayed at the end of the country button, after the dropdown
  /// icon.
  ///
  /// Typically a [VerticalDivider] separating the country button from the
  /// phone number:
  ///
  /// ```dart
  /// PhoneFormField(
  ///   countryButtonStyle: const CountryButtonStyle(
  ///     suffix: VerticalDivider(),
  ///   ),
  /// )
  /// ```
  ///
  /// The suffix is as tall as the rest of the button content (flag, dial code
  /// and dropdown icon), not as tall as the whole input, so the divider can be
  /// customized with its own parameters (`width`, `thickness`, `indent`,
  /// `endIndent`, `color`). When everything else is hidden, give the suffix an
  /// explicit height, for example with a [SizedBox]. Because its intrinsic
  /// height is measured, the suffix must not contain a [LayoutBuilder].
  ///
  /// In a `PhoneFormField` the suffix is always placed between the country
  /// button and the phone number, whatever the text direction.
  ///
  /// The suffix is part of the button: tapping it opens the country selector.
  /// Wrap text content, such as `Text('|')`, in an [ExcludeSemantics] so that
  /// it is not announced by screen readers.
  ///
  /// With [showDropdownIcon] set to false, it can also be used to display a
  /// custom dropdown icon.
  /// {@endtemplate}
  final Widget? suffix;

  const CountryButtonStyle({
    this.textStyle,
    this.padding,
    this.flagSize = 20,
    this.showFlag = true,
    this.showDialCode = true,
    this.showIsoCode = false,
    this.showDropdownIcon = true,
    this.dropdownIconColor,
    this.borderRadius,
    this.suffix,
  });

  CountryButtonStyle copyWith({
    TextStyle? textStyle,
    EdgeInsets? padding,
    double? flagSize,
    bool? showFlag,
    bool? showDialCode,
    bool? showIsoCode,
    bool? showDropdownIcon,
    Color? dropdownIconColor,
    BorderRadius? borderRadius,
    Widget? suffix,
  }) {
    return CountryButtonStyle(
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      flagSize: flagSize ?? this.flagSize,
      showFlag: showFlag ?? this.showFlag,
      showDialCode: showDialCode ?? this.showDialCode,
      showIsoCode: showIsoCode ?? this.showIsoCode,
      showDropdownIcon: showDropdownIcon ?? this.showDropdownIcon,
      dropdownIconColor: dropdownIconColor ?? this.dropdownIconColor,
      borderRadius: borderRadius ?? this.borderRadius,
      suffix: suffix ?? this.suffix,
    );
  }
}
