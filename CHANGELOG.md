## [10.0.5]

- handle disabled state for `CircleFlag` in `CountryButtonStyle` using gray scale color filter to give more natural handling of disabled state

## [10.0.4]

- added backgroundColor property to BottomSheet, DraggableModalSheet, ModalSheet, Dialog

## [10.0.3]

- added Catalan localization

## [10.0.2]

- Fix fixes issue where area codes wrapped in parentheses cannot be deleted

## [10.0.1]

- Add forgotten deprecation warning

## [10.0.0]

- Add missing countries and favorites params to CountrySelectorNavigator.page factory
- Pass the current theme to navigator page

## [9.2.8]

- Fix phone number format for some countries

## [9.2.8]

- Fix phone number format for some countries

## [9.2.7]

- added Slovak localization
- added Czech localization

## [9.2.6]
- added Vietnamese localization messages
- added localizations for Hebrew
- upgrade phone_numbers_parser to v9.0.0
- phone numbers now format in their national format.

## [9.2.5]
- fix: handle change on country selection. onChanged callback would trigger if country field is updated 
- added Korean localization messages

## [9.2.4]
- upgrade metadata
- Do not preload flags by default anymore. Use [PhoneFormField.preloadFlags()] to preload flags

## [9.2.3]
- upgrade flutter country selector dependency 

## [9.2.2]
- added language selection to demo
- fixed a bug where country selection language

## [9.2.1]
- fix readme

## [9.2.0]
- add missing translation messages
- add Hungarian localization messages
- fix RTL 
- added `showDropdownIndicator`
- [deprecate] country button stylings properties in favor of one `countryButtonStyle` property
- add showDropdownIcon bool

## [9.1.0]

- allow voip numbers
- add some missing localization messages
- upgrade metadata in underlying package

## [9.0.5]
- Fixing using controller's value as initial value #218

## [9.0.4]
- improve semantics after trying talk back

## [9.0.3]
- improve semantics

## [9.0.2]
- reformat national number on country changed

## [9.0.1]
- unexport circle flags

## [9.0.0]

- Various fixes for country selection UX
- Various fixes for input cursor issues
- Improve accessibility touches surfaces
- Improve accessibility labels
- Some visual tweaks
- Added some missing countries
- [Breaking] : no validation done by default
- [Breaking] : provided validators now require a context parameter
- [Breaking] : `LocalizedCountryRegistry` removed. If you were using it to localize a country name, you should use `CountrySelectorLocalization.of(context).countryName(isoCode)`.
- [Deprecated] : `isCountryChipPersistent` in favor of `isCountryButtonPersistent`.
- [Deprecated] : `shouldFormat`, it is now always ON by default
- [Deprecated] : `defaultCountry`, you should now use either `initialValue` or provide a controller with an initial value.
- [Deprecated] : `CountrySelectorNavigator.searchDelegate()` changed into `CountrySelectorNavigator.PageNavigator()`.
- Internal refactor in the hope of making contribution easier


## [8.1.1]
- Upgraded phone_numbers_parser lib to 8.1.0
- Added norwegian language (PR #203) thanks @sidlatau
- Added onTapOutside (PR #195) thanks @andgar2010
- Added Uzbek language (PR #192) thanks @akbarali1
- various fix in languages (thanks @Hpanery, @mohn93, @themmfa, @farzadaqajani)


## [8.1.0]
- flag loaded from assets (revert from previous version) 
- flags in country list should now render instantaneously

## [8.0.0]

- Temporary reduced memory footprint of flags by loading them via network to gauge impact (reverted)
- upgrade to latest phone metadata
- upgrade parser
- [isCountryChipPersistent] now default to true, as setting it to false results in a buggy focus behavior.
  This might be deprecated in the future if no solution is found.
- small file reorganization


## [7.1.0]

- Relax intl version matching
- Fix invalid initial value from controller 

## [7.0.7]

- Solve parameter show dial code not found to show or hide dial code

## [7.0.6]

- upgrade to phone numbers parser 7.0.1
- upgrade circle flags to 1.0.4
- fix flag rendering issues
- fix parsing issue were some phone numbers were incorrectly parsed when the start of the phone number was the same as country code

## [7.0.5]

- Better rendering of flags on the web
- Added lost Netherlands Antilla's flag

## [7.0.4]

- Fixed flag size in draggable bottom sheet
- Fixed initial svg rendering

## [7.0.3] 03/12/2022

- use svg instead of png reducing the memory footprint by about 800kb.
- added titleStyle and subtitleStyle to search delegate
- added flag size

## [7.0.2] 10/08/2022

- updated phone metadata
- updated parser library
- added new customization properties to country selector navigator: `titleStyle` & `subtitleStyle`. For searchbox: `InputDecoration`, `TextStyle`.
- added scroll physics to bottom sheet navigator
- added ukrainian language
- improved russian language
- fix example

## [7.0.1] 27/07/2022

- fix country code not shown when there is an hint
- added `isCountryChipPersistent`
- added `isCountrySelectionEnabled`

## [7.0.0] 25/07/2022

- [Breaking] Update phone_numbers_parser major version

## [6.1.1] 22/07/2022

- Read RTL support
- Removed diacritics from search
- Added height and width to dialog

## [6.1.0] 26/05/2022

- Revert RTL support as it is incomplete. (Feel free to resubmit a PR).
- Fix a country selection search input auto focus issue.
- Removed the inkWell around country code, which now has thinner clicking area.
  This was done to clean the internals.

## [6.0.0] 14/05/2022

- require flutter 3

## [5.0.4] 11/05/2022

- fix empty text direction bug

## [5.0.3] 26/04/2022

- correctly remove listener from controller on dispose.
- fix error that happened when a controller was reused.

## [5.0.2] 24/04/2022

- added el language (@kwstasarva)
- added rtl text direction support (@minusium)

## [5.0.1] 05/04/2022

- fix inkwell overflow on error
- update docs

## [5.0.0] 01/04/2022

- fix bug when copy pasting an incomplete phone number like "+33" the phone number was interpreted as
  `PhoneNumber(isoCode: FR, nsn: '33')`, now is correctly `PhoneNumber(isoCode: FR, nsn: '')`
- updated country flags for better cultural accuracy
- Remove deprecated constructor, use factories instead
- Fix a cursor bug where the cursor would be misplaced
- Added `PageNavigator` for country selection.
- Refactor of internal to accommodate for different UI for country selection
- Slight refactor of search process
- Added possibility of styling hint text (thanks @xvrh)
- [Breaking] use updated version of phone_number_parser which uses `IsoCode` for iso codes instead
  of plain string.
- Added ci tests

## [4.6.0] 01/04/2022

- Added factories for country selector navigator.
  Example `CountrySelectorNavigator.dialog()` instead of `DialogCountrySelectorNavigator` as it's simpler for auto completion.
- renamed param `selectorNavigator` to `countrySelectorNavigator`

## [4.5.3] 23 / 03 / 2022

- Fix inner border when there is a theme with focussed border

## [4.5.2] 23 / 03 / 2022

- Export country translator

## [4.5.1] 25 / 02 / 2022

- Added a property called 'countryCodeStyle' to allow the customization of the TextStyle of country code. Thanks @moazelsawaf
- Considering the size of the prefix icon ( if used ) while calculating the width of the CountryCodeChip InkWell. Thanks @moazelsawaf

## [4.5.0] 18 / 02 / 2022

- Allow country code to be always visible when there is no label + an hint text
- Fix editing issue where the cursor was moving forward

## [4.4.0] 07 / 11 / 2021

- upgraded phone parser dependency which fix some validity issues
- added swedish language
- added turkish language

## [4.3.1] 23 / 10 / 2021

- fix a focus issue when opening country selection
- search bar in country selection is no auto focus false except for the web

## [4.3.0] 18 / 10 / 2021

- Added most of textfield params to the phone input.
- Added method to select the current national number from the controller
- Changed how controllers worked under the hood
- Fix an issue where a phone number could not start with its country code
- uses phone_numbers_parser v4.1.0

## [4.2.0] 16 / 10 / 2021

- [deprecated] PhoneValidator.invalid in favor of PhoneValidator.valid as the naming did not make sens and was backward.

## [4.1.0 ] 15 / 10 / 2021

- expose onEditingComplete and textInputAction
- Update phone_number_parser library to 4.0.1, that library has breaking changes which could be reflected in the usage here

## [4.0.0] 01 / 10 / 2021

### Fixes

- fix phone number type, thanks @emrsi
- fix reset and usage as a FormField in general
- fix onChanged & onSaved
- fix late initialization error when no country was selected in bottom sheet selector

### UI

- added localized phone formatter
- added DraggableModalBottomSheet, thanks @emrsi

# Validation

- Add PhoneValidator class to easily customize validation and defaults localization error messages
- Add PhoneFormField `validator` property
- **[BREAKING CHANGE]** Remove `PhoneFormField` properties `errorText` & `phoneNumberType`. Define `validator` property instead with `PhoneValidator.invalid*`

# Misc

- refactored internals
- [Breaking] light parser was removed.
- [Breaking] exposed `autoFillHints` and removed the `withHint` param
- [Breaking] renamed all instances of `dialCode` to `countryCode` as dial code was semantically incorrect.

### Note

This major version was a big rework of the library and is packed with fixes.
Thus it was decided that it was not worth it to keep backward compatibility and therefor there are multiple breaking changes

## [3.0.0] - 27 / 08 / 2021

- removed deprecated selector config
- added controllers to control the value
- added support for copy pasting

## [2.0.0] - 16 / 08 / 2021

- deprecating SelectorConfig in favor of CountrySelectorNavigator
- added unit tests
- fixes for auto fill and copy paste

## [1.2.0] - 25 / 05 / 2021

- Minor release introducing SelectorConfig.
- Fix problems with input focussing in cover sheet.

```
  // cover sheet
  PhoneFormField(
    // ...
    selectorConfig: SelectorConfigCoverSheet()
  )
  // dialog
  PhoneFormField(
    // ...
    selectorConfig: SelectorConfigBottomSheet()
  )
  // bottom sheet
  PhoneFormField(
    // ...
    selectorConfig: SelectorConfigBottomSheet(null)
  )
```

## [1.1.3] - 25 / 05 / 2021

- fix initial value not setting up correctly
- Added different types of Country selector display: SelectorDisplay.coversBody, SelectorDisplay.coversLower. The old value is coversLower and the new default value is coversBody.

## [1.1.2] - 20 / 05 / 2021

- minor changelog fix.

## [1.1.1] - 20 / 05 / 2021

- Added key to exported widgets.

## [1.1.0] - 19 / 05 / 2021

- [Breaking] : some classes from the package phone_numbers_parser aren't exported anymore. Mostly classes that are not intended to be used with this package.
- Added example for widgets FlagDialCodeChip and CountrySelector
- Added default values for FlagDialCodeChip and removed some unused values.

## [1.0.2] - 23 / 04 / 2021

- Upped dependency phone_numbers_parser to 0.1.3
- Added phoneNumberType input to validate against specific types (mobile, fixed line)

## [1.0.1] - 23 / 04 / 2021

- Fixed validity issue (issue #1)
- Allow country to be searched by dial code (issue #2)
- Sort country search results to have more meaningful results at the top
- Upped dependency phone_numbers_parser to 0.1.0

## [1.0.0] - 21 / 04 / 2021

- Reworked internal so the PhoneFormField behaves exactly like a TextFormField

## [0.0.6] - 15 / 04 / 2021

- InputDecoration renamed to decoration to match formField

## [0.0.5] - 15 / 04 / 2021

- Match cursor color with border color

## [0.0.4] - 13 / 04 / 2021

- Default font size 14

## [0.0.3] - 13 / 04 / 2021

- Breaking: inputBorder parameter replaced by inputDecoration for more manageability

## [0.0.2] - 12 / 04 / 2021

- Fix unresponsive onSave

## [0.0.1] - 12 / 04 / 2021

- initial release
