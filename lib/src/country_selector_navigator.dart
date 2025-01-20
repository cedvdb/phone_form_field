import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_selector/flutter_country_selector.dart';

abstract class CountrySelectorNavigator {
  final List<IsoCode>? countries;
  final List<IsoCode>? favorites;
  final bool showDialCode;
  final bool sortCountries;
  final String? noResultMessage;
  final bool searchAutofocus;
  final TextStyle? subtitleStyle;
  final TextStyle? titleStyle;
  final InputDecoration? searchBoxDecoration;
  final TextStyle? searchBoxTextStyle;
  final Color? searchBoxIconColor;
  final ScrollPhysics? scrollPhysics;
  final double flagSize;
  final Color? backgroundColor;
  final bool useRootNavigator;

  const CountrySelectorNavigator({
    this.countries,
    this.favorites,
    @Deprecated('This is always on, this can be safely removed')
    bool addSeparator = true,
    @Deprecated('Use [showDialCode] instead') bool? showCountryCode,
    bool? showDialCode,
    this.sortCountries = false,
    this.noResultMessage,
    required this.searchAutofocus,
    this.subtitleStyle,
    this.titleStyle,
    this.searchBoxDecoration,
    this.searchBoxTextStyle,
    this.searchBoxIconColor,
    this.backgroundColor,
    this.scrollPhysics,
    this.flagSize = 40,
    this.useRootNavigator = true,
  }) : showDialCode = showDialCode ?? showCountryCode ?? true;

  @Deprecated('Use [show] instead')
  Future<IsoCode?> navigate(BuildContext context) => show(context);

  Future<IsoCode?> show(BuildContext context);

  Localizations _getCountrySelectorSheet({
    /// the context of the input
    /// used to have the country selection sheet
    /// in the same language as the input if the language
    /// was overriden locally with Localizations.override
    /// see: https://github.com/flutter/flutter/issues/145824
    required BuildContext inputContext,
    required ValueChanged<IsoCode> onCountrySelected,
    ScrollController? scrollController,
  }) {
    return Localizations.override(
      context: inputContext,
      locale: Localizations.localeOf(inputContext),
      child: CountrySelector.sheet(
        countries: countries ?? IsoCode.values,
        favoriteCountries: favorites ?? [],
        onCountrySelected: onCountrySelected,
        showDialCode: showDialCode,
        noResultMessage: noResultMessage,
        scrollController: scrollController,
        searchAutofocus: searchAutofocus,
        subtitleStyle: subtitleStyle,
        titleStyle: titleStyle,
        searchBoxDecoration: searchBoxDecoration,
        searchBoxTextStyle: searchBoxTextStyle,
        searchBoxIconColor: searchBoxIconColor,
        scrollPhysics: scrollPhysics,
        flagSize: flagSize,
      ),
    );
  }

  const factory CountrySelectorNavigator.dialog({
    double? height,
    double? width,
    List<IsoCode>? countries,
    List<IsoCode>? favorites,
    @Deprecated('This is always on, this can be safely removed')
    bool addSeparator,
    @Deprecated('Use [showDialCode] instead') bool? showCountryCode,
    bool? showDialCode,
    bool sortCountries,
    String? noResultMessage,
    Color? backgroundColor,
    bool searchAutofocus,
    TextStyle? subtitleStyle,
    TextStyle? titleStyle,
    InputDecoration? searchBoxDecoration,
    TextStyle? searchBoxTextStyle,
    Color? searchBoxIconColor,
    ScrollPhysics? scrollPhysics,
  }) = DialogNavigator._;

  const factory CountrySelectorNavigator.page({
    List<IsoCode>? countries,
    List<IsoCode>? favorites,
    @Deprecated('This is always on, this can be safely removed')
    bool addSeparator,
    @Deprecated('Use [showDialCode] instead') bool? showCountryCode,
    bool? showDialCode,
    bool sortCountries,
    String? noResultMessage,
    TextStyle? subtitleStyle,
    TextStyle? titleStyle,
    InputDecoration? searchBoxDecoration,
    TextStyle? searchBoxTextStyle,
    Color? searchBoxIconColor,
    ScrollPhysics? scrollPhysics,
    @Deprecated('Use [Theme] instead to wrap the input, this has no effetct')
    ThemeData? appBarTheme,
  }) = PageNavigator._;

  const factory CountrySelectorNavigator.bottomSheet({
    List<IsoCode>? countries,
    List<IsoCode>? favorites,
    @Deprecated('This is always on, this can be safely removed')
    bool addSeparator,
    @Deprecated('Use [showDialCode] instead') bool? showCountryCode,
    bool? showDialCode,
    bool sortCountries,
    String? noResultMessage,
    bool searchAutofocus,
    Color? backgroundColor,
    TextStyle? subtitleStyle,
    TextStyle? titleStyle,
    InputDecoration? searchBoxDecoration,
    TextStyle? searchBoxTextStyle,
    Color? searchBoxIconColor,
    ScrollPhysics? scrollPhysics,
  }) = BottomSheetNavigator._;

  const factory CountrySelectorNavigator.modalBottomSheet({
    double? height,
    List<IsoCode>? countries,
    List<IsoCode>? favorites,
    @Deprecated('This is always on, this can be safely removed')
    bool addSeparator,
    @Deprecated('Use [showDialCode] instead') bool? showCountryCode,
    bool? showDialCode,
    bool sortCountries,
    String? noResultMessage,
    bool searchAutofocus,
    Color? backgroundColor,
    TextStyle? subtitleStyle,
    TextStyle? titleStyle,
    InputDecoration? searchBoxDecoration,
    TextStyle? searchBoxTextStyle,
    Color? searchBoxIconColor,
    ScrollPhysics? scrollPhysics,
  }) = ModalBottomSheetNavigator._;

  const factory CountrySelectorNavigator.draggableBottomSheet({
    double initialChildSize,
    double minChildSize,
    double maxChildSize,
    BorderRadiusGeometry? borderRadius,
    List<IsoCode>? countries,
    List<IsoCode>? favorites,
    @Deprecated('This is always on, this can be safely removed')
    bool addSeparator,
    @Deprecated('Use [showDialCode] instead') bool? showCountryCode,
    bool? showDialCode,
    double flagSize,
    bool sortCountries,
    String? noResultMessage,
    Color? backgroundColor,
    bool searchAutofocus,
    TextStyle? subtitleStyle,
    TextStyle? titleStyle,
    InputDecoration? searchBoxDecoration,
    TextStyle? searchBoxTextStyle,
    Color? searchBoxIconColor,
    ScrollPhysics? scrollPhysics,
  }) = DraggableModalBottomSheetNavigator._;
}

class DialogNavigator extends CountrySelectorNavigator {
  final double? height;
  final double? width;

  const DialogNavigator._({
    this.width,
    this.height,
    super.countries,
    super.favorites,
    @Deprecated('This is always on, this can be safely removed')
    super.addSeparator,
    @Deprecated('Use [showDialCode] instead') bool? showCountryCode,
    bool? showDialCode,
    super.sortCountries,
    super.noResultMessage,
    super.searchAutofocus = kIsWeb,
    super.subtitleStyle,
    super.titleStyle,
    super.searchBoxDecoration,
    super.searchBoxTextStyle,
    super.searchBoxIconColor,
    super.scrollPhysics,
    super.backgroundColor,
  });

  @override
  Future<IsoCode?> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: backgroundColor,
        child: SizedBox(
          width: width,
          height: height,
          child: _getCountrySelectorSheet(
            inputContext: context,
            onCountrySelected: (country) =>
                Navigator.of(context, rootNavigator: true).pop(country),
          ),
        ),
      ),
    );
  }
}

class PageNavigator extends CountrySelectorNavigator {
  const PageNavigator._({
    super.countries,
    super.favorites,
    super.addSeparator,
    super.showDialCode,
    super.showCountryCode,
    super.sortCountries,
    super.noResultMessage,
    super.searchAutofocus = kIsWeb,
    super.subtitleStyle,
    super.titleStyle,
    super.searchBoxDecoration,
    super.searchBoxTextStyle,
    super.searchBoxIconColor,
    super.scrollPhysics,
    @Deprecated('Use [Theme] instead to wrap the input, this has no effetct')
    this.appBarTheme,
  });

  final ThemeData? appBarTheme;

  Localizations _getCountrySelectorPage({
    required ValueChanged<IsoCode> onCountrySelected,
    required BuildContext inputContext,
    ScrollController? scrollController,
  }) {
    return Localizations.override(
      context: inputContext,
      locale: Localizations.localeOf(inputContext),
      child: Theme(
        data: Theme.of(inputContext),
        child: CountrySelector.page(
          onCountrySelected: onCountrySelected,
          scrollController: scrollController,
          countries: countries ?? IsoCode.values,
          favoriteCountries: favorites ?? [],
          noResultMessage: noResultMessage,
          searchAutofocus: searchAutofocus,
          showDialCode: showDialCode,
          titleStyle: titleStyle,
          subtitleStyle: subtitleStyle,
        ),
      ),
    );
  }

  @override
  Future<IsoCode?> show(
    BuildContext context,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => _getCountrySelectorPage(
          onCountrySelected: (country) => Navigator.pop(context, country),
          inputContext: context,
        ),
      ),
    );
  }
}

class BottomSheetNavigator extends CountrySelectorNavigator {
  const BottomSheetNavigator._({
    super.countries,
    super.favorites,
    super.addSeparator,
    super.showDialCode,
    super.showCountryCode,
    super.sortCountries,
    super.noResultMessage,
    super.searchAutofocus = kIsWeb,
    super.subtitleStyle,
    super.titleStyle,
    super.searchBoxDecoration,
    super.searchBoxTextStyle,
    super.searchBoxIconColor,
    super.scrollPhysics,
    super.backgroundColor,
  });

  @override
  Future<IsoCode?> show(
    BuildContext context,
  ) {
    IsoCode? selected;
    final ctrl = showBottomSheet(
      backgroundColor: backgroundColor,
      context: context,
      builder: (_) => MediaQuery(
        data: MediaQueryData.fromView(View.of(context)),
        child: SafeArea(
          child: _getCountrySelectorSheet(
            inputContext: context,
            onCountrySelected: (country) {
              selected = country;
              Navigator.pop(context, country);
            },
          ),
        ),
      ),
    );
    return ctrl.closed.then((_) => selected);
  }
}

class ModalBottomSheetNavigator extends CountrySelectorNavigator {
  final double? height;

  const ModalBottomSheetNavigator._({
    this.height,
    super.countries,
    super.favorites,
    super.addSeparator,
    super.showDialCode,
    super.showCountryCode,
    super.sortCountries,
    super.noResultMessage,
    super.searchAutofocus = kIsWeb,
    super.subtitleStyle,
    super.titleStyle,
    super.searchBoxDecoration,
    super.searchBoxTextStyle,
    super.searchBoxIconColor,
    super.scrollPhysics,
    super.backgroundColor,
  });

  @override
  Future<IsoCode?> show(
    BuildContext context,
  ) {
    return showModalBottomSheet<IsoCode>(
      backgroundColor: backgroundColor,
      context: context,
      builder: (_) => SizedBox(
        height: height ?? MediaQuery.of(context).size.height - 90,
        child: _getCountrySelectorSheet(
          inputContext: context,
          onCountrySelected: (country) => Navigator.pop(context, country),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class DraggableModalBottomSheetNavigator extends CountrySelectorNavigator {
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final BorderRadiusGeometry? borderRadius;

  const DraggableModalBottomSheetNavigator._({
    this.initialChildSize = 0.7,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.85,
    this.borderRadius,
    super.countries,
    super.favorites,
    super.addSeparator,
    super.showDialCode,
    super.showCountryCode,
    super.sortCountries,
    super.flagSize,
    super.noResultMessage,
    super.searchAutofocus = kIsWeb,
    super.subtitleStyle,
    super.titleStyle,
    super.searchBoxDecoration,
    super.searchBoxTextStyle,
    super.searchBoxIconColor,
    super.scrollPhysics,
    super.backgroundColor,
    bool useRootNavigator = true,
  });

  @override
  Future<IsoCode?> show(BuildContext context) {
    final effectiveBorderRadius = borderRadius ??
        const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        );

    return showModalBottomSheet<IsoCode>(
      backgroundColor: backgroundColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (context, scrollController) => _getCountrySelectorSheet(
          inputContext: context,
          onCountrySelected: (country) => Navigator.pop(context, country),
          scrollController: scrollController,
        ),
      ),
      useRootNavigator: useRootNavigator,
      isScrollControlled: true,
    );
  }
}
