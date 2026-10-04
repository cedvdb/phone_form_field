# phone_form_field

[![pub package](https://img.shields.io/pub/v/phone_form_field.svg)](https://pub.dev/packages/phone_form_field)
[![pub points](https://img.shields.io/pub/points/phone_form_field.svg)](https://pub.dev/packages/phone_form_field/score)
[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A Flutter phone input integrated with Flutter internationalization. It is a
`FormField` that formats, validates and localizes international phone numbers,
and ships with a built-in country selector.

## Features

- Phone formatting localized by region
- Validation with localized error messages
- Localized country names (32 languages)
- Country selector available as a page, dialog, modal sheet or draggable sheet
- Built-in validators: required, valid, valid mobile, valid fixed line, valid country, ...
- Extensible: custom validators, custom country selector and custom flags
- Works as a `FormField` and supports autofill and copy paste
- Pure Dart/Flutter, no platform code, works on every platform
- Parsing delegated to the
  [phone_numbers_parser](https://pub.dev/packages/phone_numbers_parser) package

## Demo

Demo available at https://cedvdb.github.io/phone_form_field/

![demo](https://github.com/cedvdb/phone_form_field/blob/main/demo.gif?raw=true)

## Contents

- [Installation](#installation)
- [Usage](#usage)
- [Validation](#validation)
- [Country selector](#country-selector)
- [Internationalization](#internationalization)
- [Custom flags](#custom-flags)

## Installation

```sh
flutter pub add phone_form_field
```

## Usage

The simplest usage, without validation and without an initial value:

```dart
import 'package:phone_form_field/phone_form_field.dart';

PhoneFormField();
```

A more complete example:

```dart
final controller = PhoneController(initialValue: PhoneNumber.parse('+33'));

PhoneFormField(
  controller: controller,

  // how the country selector is presented, see "Country selector" below
  countrySelectorNavigator: const CountrySelectorNavigator.page(),

  // validation, see "Validation" below. Omit it for no validation.
  validator: PhoneValidator.required(context),

  // country button
  isCountrySelectionEnabled: true,
  isCountryButtonPersistent: true,
  countryButtonStyle: const CountryButtonStyle(
    showDialCode: true,
    showIsoCode: true,
    showFlag: true,
    flagSize: 16,
  ),

  onChanged: (phoneNumber) => print('changed into $phoneNumber'),

  // + all the parameters of TextField
  // + all the parameters of FormField
);

// do not forget to dispose the controller
controller.dispose();
```

### Main parameters

| Name | Default | Description |
|---|---|---|
| `controller` | `null` | A `PhoneController` used to read and change the value. Mutually exclusive with `initialValue` |
| `initialValue` | `null` | The initial `PhoneNumber`. Mutually exclusive with `controller` |
| `countrySelectorNavigator` | `CountrySelectorNavigator.page()` | How the country selector is presented |
| `isCountrySelectionEnabled` | `true` | Whether the user may select another country |
| `isCountryButtonPersistent` | `true` | Whether the country button stays visible when the national number is empty |
| `countryButtonStyle` | `CountryButtonStyle()` | Appearance of the country button |
| `validator` | `null` | A `PhoneNumberInputValidator`, see [Validation](#validation) |
| `onChanged` | `null` | Called whenever the value changes |
| `decoration` | `InputDecoration()` | The standard `TextField` decoration |
| ... | | All the `TextField` and `FormField` parameters are forwarded |

### Preloading flags

On the web the flags are assets downloaded on demand, which can cause a flash
when the country selector opens. Preload them to avoid it:

```dart
import 'package:phone_form_field/country_selector.dart';

// only the flags you care about
await CountrySelector.preloadFlags(isoCodes: [IsoCode.FR, IsoCode.BE]);

// or every flag
await PhoneFormField.preloadFlags();
```

## Validation

### Built-in validators

Built-in validators produce localized messages, they therefore take the
`BuildContext`:

| Validator | Description |
|---|---|
| `PhoneValidator.required(context)` | the national number must not be empty |
| `PhoneValidator.valid(context)` | the number must be valid |
| `PhoneValidator.validMobile(context)` | the number must be a valid mobile number |
| `PhoneValidator.validFixedLine(context)` | the number must be a valid fixed line number |
| `PhoneValidator.validType(context, type)` | the number must be valid for the given `PhoneNumberType` (`mobile`, `fixedLine`, ...) |
| `PhoneValidator.validCountry(context, countries)` | the number must belong to one of the supplied `List<IsoCode>` |

Each of them accepts an `errorText` parameter to override the built-in
translated message:

```dart
PhoneValidator.required(context, errorText: 'You must enter a value')
```

Note that `PhoneValidator.required` only rejects empty values and that the
`PhoneValidator.valid*` family only rejects invalid non empty values, combine
them to cover both cases.

Omitting `validator` (or passing `null`) disables validation entirely.

### Composing validators

Validators can be composed with `PhoneValidator.compose`, see the example below.
The order is important as the message of the first failing validator is the one
displayed.

```dart
PhoneFormField(
  // ...
  validator: PhoneValidator.compose([
    PhoneValidator.required(context),
    PhoneValidator.validMobile(context),
  ]),
);
```

### Custom validators

A validator is a `PhoneNumberInputValidator`, that is a
`String? Function(PhoneNumber?)` returning `null` when the value is valid and the
error message otherwise:

```dart
String? myValidator(PhoneNumber? number) {
  if (number == null || number.nsn.isEmpty) return 'Required';
  if (number.nsn.length < 4) return 'Too short';
  return null;
}

PhoneFormField(validator: myValidator);
```

## Country selector

The country selector is opened by tapping the country button of the field. Its
presentation is decided by the `countrySelectorNavigator` parameter.

### Presentation

* **`CountrySelectorNavigator.page()`**
  Opens a full screen page.

* **`CountrySelectorNavigator.dialog()`**
  Opens a dialog.
  Extra parameters: `width` and `height`.

* **`CountrySelectorNavigator.bottomSheet()`**
  Opens a bottom sheet expanding to all the available space in both axes.

* **`CountrySelectorNavigator.modalBottomSheet()`**
  Opens a modal bottom sheet expanded horizontally.
  Extra parameters:
  * `height` (double, default `null`): the height of the sheet, defaults to the
    available height minus 90px.

* **`CountrySelectorNavigator.draggableBottomSheet()`**
  Opens a modal bottom sheet expanded horizontally which may be dragged from a
  minimum to a maximum of the current available height. It uses the
  `DraggableScrollableSheet` widget internally.
  Extra parameters:
  * `initialChildSize` (double, default `0.7`): factor of the available height used when opening
  * `minChildSize` (double, default `0.25`): minimum factor of the available height
  * `maxChildSize` (double, default `0.85`): maximum factor of the available height
  * `borderRadius` (`BorderRadiusGeometry`, default to a 16px circular radius on the top corners)

### Shared parameters

All built-in navigators accept the following parameters:

| Name | Default | Description |
|---|---|---|
| `countries` | `null` | Countries available in the list view, all countries are listed when omitted |
| `favorites` | `null` | List of `IsoCode` to display on top of the list, e.g. `[IsoCode.FR, IsoCode.GB]` |
| `showDialCode` | `true` | Whether to display the country dial code as the list tile subtitle |
| `sortCountries` | `false` | Whether the countries are sorted alphabetically. When `false` the countries follow the order of the `countries` parameter (favorite countries are always listed in the supplied order) |
| `noResultMessage` | `null` | Message displayed when the search returns no result, a built-in localized message is used when omitted |
| `searchAutofocus` | `kIsWeb` | Whether the search box is focused when the selector opens |
| `subtitleStyle`, `titleStyle` | `null` | Text styles of the list items |
| `searchBoxDecoration`, `searchBoxTextStyle`, `searchBoxIconColor` | `null` | Styling of the search box |
| `scrollPhysics` | `null` | Scroll physics of the country list |

### Reusing the selector without the field

The list itself is also public, so it can be embedded anywhere:

```dart
import 'package:phone_form_field/country_selector.dart';

final isoCode = await Navigator.of(context).push<IsoCode>(
  MaterialPageRoute(
    builder: (_) => CountrySelector.page(
      onCountrySelected: (isoCode) => Navigator.pop(context, isoCode),
      showDialCode: true,
    ),
  ),
);
```

`CountrySelector.sheet(...)` is the equivalent for a compact, non full screen
presentation.

### Custom country selector

To fully customize how the selector is presented, extend
`CountrySelectorNavigator` and implement `show`, which must return the selected
`IsoCode` (or `null` when the user dismissed it):

```dart
class MyCountrySelectorNavigator extends CountrySelectorNavigator {
  const MyCountrySelectorNavigator() : super(searchAutofocus: true);

  @override
  Future<IsoCode?> show(BuildContext context) async {
    // present your own UI and return the selected country
    return showMyOwnCountryPicker(context);
  }
}

PhoneFormField(
  // ...
  countrySelectorNavigator: const MyCountrySelectorNavigator(),
);
```

You can reuse `CountrySelector.sheet(...)` or `CountrySelector.page(...)` inside
your navigator to keep the built-in list and only change the presentation.

## Internationalization

### Registering the delegates

The package ships its own strings (labels, error messages, country names) and
needs its delegate registered. There is usually no reason to replace your own
`localizationsDelegates`: spread the ones of the package into your list so that
the other localized packages of your application keep working.

```dart
import 'package:phone_form_field/phone_form_field.dart';

MaterialApp(
  localizationsDelegates: const [
    // your application and your other packages
    ...AppLocalizations.localizationsDelegates,
    // required by phone_form_field
    ...PhoneFieldLocalization.delegates,
  ],
  supportedLocales: const [
    ...AppLocalizations.supportedLocales,
    ...PhoneFieldLocalization.supportedLocales,
  ],
  // ...
);
```

`AppLocalizations` stands for whatever your application uses, for example the
classes generated by `flutter gen-l10n`, `intl` or `easy_localization`.

`PhoneFieldLocalization.delegates` also contains the global `material_ui`
delegates that the widgets read. If you already provide those yourself, add only
the strings of this package:

```dart
localizationsDelegates: const [
  ...myDelegates,
  PhoneFieldLocalization.delegate,
];
```

### Reading the strings

```dart
final strings = PhoneFieldLocalization.of(context);

Text(strings.phoneNumber);
```

### Localized country names

Country names are localized as well and fall back to english when the country is
not translated for the current locale:

```dart
final countryName = PhoneFieldLocalization.of(context).countryName(IsoCode.FR);
```

### Supported languages

- ar
- ca
- ckb
- cs
- de
- el
- en
- es
- fa
- fr
- he
- hi
- hu
- it
- ja
- ko
- ku
- nb
- nl
- pl
- pt
- ro
- ru
- sk
- sv
- th
- tr
- uk
- ur
- uz
- vi
- zh

If one of the languages you target is not supported, you can submit a pull
request in the phone_form_field repository.

## Custom flags

Some users have expressed their need to change some flags due to political or
stylistic reasons, or to add their own flags. To do so refer to this issue:
https://github.com/cedvdb/phone_form_field/issues/222

## License

MIT, see [LICENSE](LICENSE).
```
