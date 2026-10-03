import 'package:material_ui/material_ui.dart';
import 'package:phone_form_field/src/country_selector/country_selector_base.dart';

import 'widgets/_country_list_view.dart';
import 'widgets/_search_box.dart';

/// Displays a country selector with a search box at the top
/// and a list of countries underneath.
class CountrySelectorSheet extends CountrySelectorBase {
  const CountrySelectorSheet({
    super.key,
    required super.onCountrySelected,
    super.scrollController,
    super.scrollPhysics,
    super.showDialCode,
    super.noResultMessage,
    super.favoriteCountries,
    super.countries,
    super.searchAutofocus,
    super.subtitleStyle,
    super.titleStyle,
    super.searchBoxDecoration,
    super.searchBoxTextStyle,
    super.searchBoxIconColor,
    super.flagSize,
  });

  @override
  CountrySelectorSheetState createState() => CountrySelectorSheetState();
}

class CountrySelectorSheetState
    extends CountrySelectorBaseState<CountrySelectorSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(
          height: 64,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
            child: SearchBox(
              autofocus: widget.searchAutofocus,
              onChanged: onSearch,
              onSubmitted: onSubmitted,
              decoration: widget.searchBoxDecoration,
              style: widget.searchBoxTextStyle,
              searchIconColor: widget.searchBoxIconColor,
            ),
          ),
        ),
        const Divider(height: 0, thickness: 1.2),
        Flexible(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return CountryListView(
                countries: controller.filteredCountries,
                favorites: controller.filteredFavorites,
                showDialCode: widget.showDialCode,
                onTap: (country) => widget.onCountrySelected(country.isoCode),
                flagSize: widget.flagSize,
                scrollController: widget.scrollController,
                scrollPhysics: widget.scrollPhysics,
                noResultMessage: widget.noResultMessage,
                titleStyle: widget.titleStyle,
                subtitleStyle: widget.subtitleStyle,
              );
            },
          ),
        ),
      ],
    );
  }
}
