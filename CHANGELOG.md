## [4.0.1] - 
- added DraggableModalBottomSheet
- fix phone number type
- fix reset and usage as a FormField in general
- fix onChanged & onSaved
- fix late initialization error when no country was selected in bottom sheet selector
- refactored internals

## [3.0.0] - 27 / 08 / 2021
- removed deprecated selector config
- added controllers to control the value
- added support for copy pasting

## [2.0.0] - 16 / 08 / 2021

- deprecating SelectorConfig in favor of CountrySelectorNavigator
- added unit tests
- fixes for auto fill and copy paste

## [1.2.0] - 25 / 05 / 2021
* Minor release introducing SelectorConfig.
* Fix problems with input focussing in cover sheet. 

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
* fix initial value not setting up correctly
* Added different types of Country selector display: SelectorDisplay.coversBody, SelectorDisplay.coversLower. The old value is coversLower and the new default value is coversBody. 

## [1.1.2] - 20 / 05 / 2021
* minor changelog fix.

## [1.1.1] - 20 / 05 / 2021
* Added key to exported widgets.

## [1.1.0] - 19 / 05 / 2021
* [Breaking] : some classes from the package phone_numbers_parser aren't exported anymore. Mostly classes that are not intended to be used with this package.
* Added example for widgets FlagDialCodeChip and CountrySelector
* Added default values for FlagDialCodeChip and removed some unused values.

## [1.0.2] - 23 / 04 / 2021
* Upped dependency phone_numbers_parser to 0.1.3
* Added phoneNumberType input to validate against specific types (mobile, fixed line)

## [1.0.1] - 23 / 04 / 2021
* Fixed validity issue (issue #1)
* Allow country to be searched by dial code (issue #2)
* Sort country search results to have more meaningful results at the top
* Upped dependency phone_numbers_parser to 0.1.0

## [1.0.0] - 21 / 04 / 2021

* Reworked internal so the PhoneFormField behaves exactly like a TextFormField

## [0.0.6] - 15 / 04 / 2021

* InputDecoration renamed to decoration to match formField

## [0.0.5] - 15 / 04 / 2021

* Match cursor color with border color

## [0.0.4] - 13 / 04 / 2021

* Default font size 14

## [0.0.3] - 13 / 04 / 2021

* Breaking: inputBorder parameter replaced by inputDecoration for more maneability

## [0.0.2] - 12 / 04 / 2021

* Fix unresponsive onSave


## [0.0.1] - 12 / 04 / 2021

* initial release
