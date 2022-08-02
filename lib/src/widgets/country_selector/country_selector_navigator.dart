import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/widgets/country_selector/country_selector_page.dart';

abstract class CountrySelectorNavigator {
  final List<IsoCode>? countries;
  final List<IsoCode>? favorites;
  final bool addSeparator;
  final bool showCountryCode;
  final bool sortCountries;
  final String? noResultMessage;
  final bool searchAutofocus;
  final TextStyle? subtitleStyle;
  final TextStyle? titleStyle;
  final InputDecoration? searchBoxDecoration;
  final TextStyle? searchBoxTextStyle;
  final Color? searchBoxIconColor;
  final ScrollPhysics? scrollPhysics;

  const CountrySelectorNavigator({
    this.countries,
    this.favorites,
    this.addSeparator = true,
    this.showCountryCode = true,
    this.sortCountries = false,
    this.noResultMessage,
    required this.searchAutofocus,
    this.subtitleStyle,
    this.titleStyle,
    this.searchBoxDecoration,
    this.searchBoxTextStyle,
    this.searchBoxIconColor,
    this.scrollPhysics,
  });

  Future<Country?> navigate(BuildContext context);

  dynamic _getCountrySelector({
    required ValueChanged<Country> onCountrySelected,
    ScrollController? scrollController,
  }) {
    return CountrySelector(
      countries: countries,
      onCountrySelected: onCountrySelected,
      favoriteCountries: favorites ?? [],
      addFavoritesSeparator: addSeparator,
      showCountryCode: showCountryCode,
      noResultMessage: noResultMessage,
      scrollController: scrollController,
      searchAutofocus: searchAutofocus,
      subtitleStyle: subtitleStyle,
      titleStyle: titleStyle,
      searchBoxDecoration: searchBoxDecoration,
      searchBoxTextStyle: searchBoxTextStyle,
      searchBoxIconColor: searchBoxIconColor,
      scrollPhysics: scrollPhysics,
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

  const factory CountrySelectorNavigator.searchDelegate({
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
  }) = SearchDelegateNavigator._;

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
    List<IsoCode>? countries,
    List<IsoCode>? favorites,
    bool addSeparator = true,
    bool showCountryCode = true,
    bool sortCountries = false,
    String? noResultMessage,
    bool searchAutofocus = kIsWeb,
    TextStyle? subtitleStyle,
    TextStyle? titleStyle,
    InputDecoration? searchBoxDecoration,
    TextStyle? searchBoxTextStyle,
    Color? searchBoxIconColor,
    ScrollPhysics? scrollPhysics,
  }) : super(
          countries: countries,
          favorites: favorites,
          addSeparator: addSeparator,
          showCountryCode: showCountryCode,
          sortCountries: sortCountries,
          noResultMessage: noResultMessage,
          searchAutofocus: searchAutofocus,
          subtitleStyle: subtitleStyle,
          titleStyle: titleStyle,
          searchBoxDecoration: searchBoxDecoration,
          searchBoxTextStyle: searchBoxTextStyle,
          searchBoxIconColor: searchBoxIconColor,
          scrollPhysics: scrollPhysics,
        );

  @override
  Future<Country?> navigate(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        child: SizedBox(
          width: width,
          height: height,
          child: _getCountrySelector(
            onCountrySelected: (country) => Navigator.pop(context, country),
          ),
        ),
      ),
    );
  }
}

class SearchDelegateNavigator extends CountrySelectorNavigator {
  const SearchDelegateNavigator._({
    List<IsoCode>? countries,
    List<IsoCode>? favorites,
    bool addSeparator = true,
    bool showCountryCode = true,
    bool sortCountries = false,
    String? noResultMessage,
    bool searchAutofocus = kIsWeb,
    TextStyle? subtitleStyle,
    TextStyle? titleStyle,
    InputDecoration? searchBoxDecoration,
    TextStyle? searchBoxTextStyle,
    Color? searchBoxIconColor,
    ScrollPhysics? scrollPhysics,
  }) : super(
          countries: countries,
          favorites: favorites,
          addSeparator: addSeparator,
          showCountryCode: showCountryCode,
          sortCountries: sortCountries,
          noResultMessage: noResultMessage,
          searchAutofocus: searchAutofocus,
          subtitleStyle: subtitleStyle,
          titleStyle: titleStyle,
          searchBoxDecoration: searchBoxDecoration,
          searchBoxTextStyle: searchBoxTextStyle,
          searchBoxIconColor: searchBoxIconColor,
          scrollPhysics: scrollPhysics,
        );

  @override
  dynamic _getCountrySelector({
    required ValueChanged<Country> onCountrySelected,
    ScrollController? scrollController,
  }) {
    return CountrySelectorSearchDelegate(
      onCountrySelected: onCountrySelected,
      scrollController: scrollController,
      addFavoritesSeparator: addSeparator,
      countries: countries,
      favoriteCountries: favorites ?? [],
      noResultMessage: noResultMessage,
      searchAutofocus: searchAutofocus,
      showCountryCode: showCountryCode,
    );
  }

  @override
  Future<Country?> navigate(BuildContext context) {
    return showSearch(
      context: context,
      delegate: _getCountrySelector(
        onCountrySelected: (country) => Navigator.pop(context, country),
      ),
    );
  }
}

class BottomSheetNavigator extends CountrySelectorNavigator {
  const BottomSheetNavigator._({
    List<IsoCode>? countries,
    List<IsoCode>? favorites,
    bool addSeparator = true,
    bool showCountryCode = true,
    bool sortCountries = false,
    String? noResultMessage,
    bool searchAutofocus = kIsWeb,
    TextStyle? subtitleStyle,
    TextStyle? titleStyle,
    InputDecoration? searchBoxDecoration,
    TextStyle? searchBoxTextStyle,
    Color? searchBoxIconColor,
    ScrollPhysics? scrollPhysics,
  }) : super(
          countries: countries,
          favorites: favorites,
          addSeparator: addSeparator,
          showCountryCode: showCountryCode,
          sortCountries: sortCountries,
          noResultMessage: noResultMessage,
          searchAutofocus: searchAutofocus,
          subtitleStyle: subtitleStyle,
          titleStyle: titleStyle,
          searchBoxDecoration: searchBoxDecoration,
          searchBoxTextStyle: searchBoxTextStyle,
          searchBoxIconColor: searchBoxIconColor,
          scrollPhysics: scrollPhysics,
        );

  @override
  Future<Country?> navigate(BuildContext context) {
    Country? selected;
    final ctrl = showBottomSheet(
      context: context,
      builder: (_) => _getCountrySelector(
        onCountrySelected: (country) {
          selected = country;
          Navigator.pop(context, country);
        },
      ),
    );
    return ctrl.closed.then((_) => selected);
  }
}

class ModalBottomSheetNavigator extends CountrySelectorNavigator {
  final double? height;

  const ModalBottomSheetNavigator._({
    this.height,
    List<IsoCode>? countries,
    List<IsoCode>? favorites,
    bool addSeparator = true,
    bool showCountryCode = true,
    bool sortCountries = false,
    String? noResultMessage,
    bool searchAutofocus = kIsWeb,
    TextStyle? subtitleStyle,
    TextStyle? titleStyle,
    InputDecoration? searchBoxDecoration,
    TextStyle? searchBoxTextStyle,
    Color? searchBoxIconColor,
    ScrollPhysics? scrollPhysics,
  }) : super(
          countries: countries,
          favorites: favorites,
          addSeparator: addSeparator,
          showCountryCode: showCountryCode,
          sortCountries: sortCountries,
          noResultMessage: noResultMessage,
          searchAutofocus: searchAutofocus,
          subtitleStyle: subtitleStyle,
          titleStyle: titleStyle,
          searchBoxDecoration: searchBoxDecoration,
          searchBoxTextStyle: searchBoxTextStyle,
          searchBoxIconColor: searchBoxIconColor,
          scrollPhysics: scrollPhysics,
        );

  @override
  Future<Country?> navigate(BuildContext context) {
    return showModalBottomSheet<Country>(
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
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.85,
    this.borderRadius,
    List<IsoCode>? countries,
    List<IsoCode>? favorites,
    bool addSeparator = true,
    bool showCountryCode = true,
    bool sortCountries = false,
    String? noResultMessage,
    bool searchAutofocus = kIsWeb,
    TextStyle? subtitleStyle,
    TextStyle? titleStyle,
    InputDecoration? searchBoxDecoration,
    TextStyle? searchBoxTextStyle,
    Color? searchBoxIconColor,
    ScrollPhysics? scrollPhysics,
  }) : super(
          countries: countries,
          favorites: favorites,
          addSeparator: addSeparator,
          showCountryCode: showCountryCode,
          sortCountries: sortCountries,
          noResultMessage: noResultMessage,
          searchAutofocus: searchAutofocus,
          subtitleStyle: subtitleStyle,
          titleStyle: titleStyle,
          searchBoxDecoration: searchBoxDecoration,
          searchBoxTextStyle: searchBoxTextStyle,
          searchBoxIconColor: searchBoxIconColor,
          scrollPhysics: scrollPhysics,
        );

  @override
  Future<Country?> navigate(BuildContext context) {
    final effectiveBorderRadius = borderRadius ??
        const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        );
    return showModalBottomSheet<Country>(
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
          return Container(
            decoration: ShapeDecoration(
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: effectiveBorderRadius,
              ),
            ),
            child: _getCountrySelector(
              onCountrySelected: (country) => Navigator.pop(context, country),
              scrollController: scrollController,
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
