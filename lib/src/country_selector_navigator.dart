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
  final bool useRootNavigator;

  const CountrySelectorNavigator({
    this.countries,
    this.favorites,
    @Deprecated('This is always on by default, this can be safely removed')
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
    this.scrollPhysics,
    this.flagSize = 40,
    this.useRootNavigator = true,
  }) : showDialCode = showDialCode ?? showCountryCode ?? true;

  @Deprecated('Use [show] instead')
  Future<IsoCode?> navigate(BuildContext context) => show(context);

  Future<IsoCode?> show(BuildContext context);

  CountrySelectorSheet _getCountrySelector({
    required ValueChanged<IsoCode> onCountrySelected,
    ScrollController? scrollController,
  }) {
    return CountrySelector.sheet(
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
    );
  }

  const factory CountrySelectorNavigator.dialog({
    double? height,
    double? width,
    List<IsoCode>? countries,
    List<IsoCode>? favorites,
    bool addSeparator,
    bool showCountryCode,
    bool sortCountries,
    String? noResultMessage,
    bool searchAutofocus,
    TextStyle? subtitleStyle,
    TextStyle? titleStyle,
    InputDecoration? searchBoxDecoration,
    TextStyle? searchBoxTextStyle,
    Color? searchBoxIconColor,
    ScrollPhysics? scrollPhysics,
  }) = DialogNavigator._;

  @Deprecated('Use [CountrySelectorNavigator.page] instead')
  const factory CountrySelectorNavigator.searchDelegate() =
      CountrySelectorNavigator.page;

  const factory CountrySelectorNavigator.page({
    bool addSeparator,
    bool showCountryCode,
    bool sortCountries,
    String? noResultMessage,
    TextStyle? subtitleStyle,
    TextStyle? titleStyle,
    InputDecoration? searchBoxDecoration,
    TextStyle? searchBoxTextStyle,
    Color? searchBoxIconColor,
    ScrollPhysics? scrollPhysics,
    ThemeData? appBarTheme,
  }) = PageNavigator._;

  const factory CountrySelectorNavigator.bottomSheet({
    List<IsoCode>? countries,
    List<IsoCode>? favorites,
    bool addSeparator,
    bool showCountryCode,
    bool sortCountries,
    String? noResultMessage,
    bool searchAutofocus,
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
    bool addSeparator,
    bool showCountryCode,
    bool sortCountries,
    String? noResultMessage,
    bool searchAutofocus,
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
    bool addSeparator,
    bool showCountryCode,
    double flagSize,
    bool sortCountries,
    String? noResultMessage,
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
    super.addSeparator,
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
  });

  @override
  Future<IsoCode?> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        child: SizedBox(
          width: width,
          height: height,
          child: _getCountrySelector(
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
    this.appBarTheme,
  });

  final ThemeData? appBarTheme;

  CountrySelectorPage _getCountrySelectorPage({
    required ValueChanged<IsoCode> onCountrySelected,
    ScrollController? scrollController,
  }) {
    return CountrySelector.page(
      onCountrySelected: onCountrySelected,
      scrollController: scrollController,
      countries: countries ?? IsoCode.values,
      favoriteCountries: favorites ?? [],
      noResultMessage: noResultMessage,
      searchAutofocus: searchAutofocus,
      showDialCode: showDialCode,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      searchBoxDecoration: searchBoxDecoration,
      searchBoxTextStyle: searchBoxTextStyle,
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
  });

  @override
  Future<IsoCode?> show(
    BuildContext context,
  ) {
    IsoCode? selected;
    final ctrl = showBottomSheet(
      context: context,
      builder: (_) => MediaQuery(
        data: MediaQueryData.fromView(View.of(context)),
        child: SafeArea(
          child: _getCountrySelector(
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
  });

  @override
  Future<IsoCode?> show(
    BuildContext context,
  ) {
    return showModalBottomSheet<IsoCode>(
      context: context,
      builder: (_) => SizedBox(
        height: height ?? MediaQuery.of(context).size.height - 90,
        child: _getCountrySelector(
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
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (context, scrollController) {
          return _CountrySelectorWidget(
            scrollController: scrollController,
            borderRadius: effectiveBorderRadius,
            child: _getCountrySelector(
              onCountrySelected: (country) => Navigator.pop(context, country),
              scrollController: scrollController,
            ),
          );
        },
      ),
      useRootNavigator: useRootNavigator,
      isScrollControlled: true,
    );
  }
}

class _CountrySelectorWidget extends StatefulWidget {
  final ScrollController scrollController;
  final BorderRadiusGeometry borderRadius;
  final Widget child;

  const _CountrySelectorWidget({
    required this.scrollController,
    required this.child,
    required this.borderRadius,
  });

  @override
  State<_CountrySelectorWidget> createState() => _CountrySelectorWidgetState();
}

class _CountrySelectorWidgetState extends State<_CountrySelectorWidget> {
  @override
  initState() {
    super.initState();
    widget.scrollController.addListener(_onScrollListener);
  }

  @override
  dispose() {
    widget.scrollController.removeListener(_onScrollListener);
    super.dispose();
  }

  _onScrollListener() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: widget.borderRadius,
        ),
      ),
      child: widget.child,
    );
  }
}
