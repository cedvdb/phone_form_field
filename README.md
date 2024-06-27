# phone_form_field

Flutter phone input integrated with flutter internationalization

## Features

- Totally cross platform, this is a dart only package / dependencies
- Internationalization: many languages supported
- Semantics
- Phone formatting localized by region
- Phone number validation (built-in validators included for main use cases) 
- Support auto fill and copy paste
- Uses dart phone_numbers_parser for parsing
- Form field

## Demo

Demo available at https://cedvdb.github.io/phone_form_field/

![](https://github.com/cedvdb/phone_form_field/blob/main/demo.gif?raw=true)


## Usage

```dart
PhoneFormField();

/// params
PhoneFormField(
  initialValue: PhoneNumber.parse('+33'), // or use the controller
  validator: PhoneValidator.compose(
      [PhoneValidator.required(), PhoneValidator.validMobile()]),
  countrySelectorNavigator: const CountrySelectorNavigator.page(),
  onChanged: (phoneNumber) => print('changed into $phoneNumber'),
  enabled: true,
  isCountrySelectionEnabled: true,
  isCountryButtonPersistent: true,
  countryButtonStyle: const CountryButtonStyle(
    showDialCode: true,
    showIsoCode: true,
    showFlag: true,
    flagSize: 16
  ),

  // + all parameters of TextField
  // + all parameters of FormField
  // ...
);
```

## Validation

### Built-in validators

* required : `PhoneValidator.required`
* valid : `PhoneValidator.valid` (default value when no validator supplied)
* valid mobile number : `PhoneValidator.validMobile`
* valid fixed line number : `PhoneValidator.validFixedLine`
* valid type : `PhoneValidator.validType`
* valid country : `PhoneValidator.validCountry`
* none : `PhoneValidator.none` (this can be used to disable default valid validator)

### Validators details

* Each validator has an optional `errorText` property to override built-in translated text

### Composing validators

Validator can be a composed set of validators built-in or custom validator using `PhoneValidator.compose`, see example below.

Note that when composing validators, the sorting is important as the error message displayed is the first validator failing.

```dart
PhoneFormField(
  // ...
  validator: PhoneValidator.compose([
    // list of validators to use
    PhoneValidator.required(errorText: "You must enter a value"),
    PhoneValidator.validMobile(),
    // ..
  ]),
)
```

## Country selector

Here are the list of the parameters available for all built-in country selector :

| Name | Default value | Description |
|---|---|---|
| countries | null | Countries available in list view (all countries are listed when omitted) |
| favorites | null | List of country code `['FR','UK']` to display on top of the list |
| addSeparator | true | Whether to add a separator between favorite countries and others one. Useless if `favorites` parameter is null |
| showCountryCode | true | Whether to display the country dial code as listTile item subtitle |
| sortCountries | false | Whether the countries should appear in alphabetic order, if false the countries are displayed in the same order as `countries` property (Note that favorite countries are listed in supplied order whatever the value of this parameter) |
| noResultMessage | null | The message to be displayed in place of the list when search result is empty (a default localised message is used when omitted) |

### Built-in country selector

* **CountrySelectorNavigator.page**
  Open a page to select the country.
  No extra parameters

* **CountrySelectorNavigator.dialog**
  Open a dialog to select the country.
  No extra parameters

* **CountrySelectorNavigator.bottomSheet**
  Open a bottom sheet expanding to all available space in both axis
  No extra parameters

* **CountrySelectorNavigator.modalBottomSheet**
  Open a modal bottom sheet expanded horizontally
  Extra parameters: 
    * `height` (double, default null)
       Allow to determine the height of the bottom sheet, will expand to all available height when omitted

* **CountrySelectorNavigator.draggableBottomSheet**
  Open a modal bottom sheet expanded horizontally which may be dragged from a minimum to a maximum of current available height.
  Uses internally the `DraggableScrollableSheet` flutter widget
  Extra parameters:
     * `initialChildSize` (double, default: `0.5`) factor of current available height used when opening
     * `minChildSize` (double, default: `0.Z5`) : maximum factor of current available height 
     * `minChildSize` (double, default: `0.Z5`) : minimum factor of current available height
     * `borderRadius` (BorderRadiusGeometry, default: 16px circular radius on top left/right)
    

### Custom Country Selector Navigator

You can use your own country selector by creating a class that implements `CountrySelectorNavigator`
It has one required method `show` expected to return the selected country:

```dart
class CustomCountrySelectorNavigator implements CountrySelectorNavigator {
  Future<Country?> show(BuildContext context) {
    // ask user for a country and return related `Country` class
  }
}

// usage
PhoneFormField(
  // ...
  selectorNavigator: CustomCountrySelectorNavigator(),
  // ...
)
```

## Internationalization

### Dynamic localization

This package uses the `flutter_country_selector` package under the hood, which exports a method for dynamic localization `CountrySelectorLocalization.of(context).countryName(isoCode)`.

### Setup

  Include the delegate

  ```dart
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        PhoneFieldLocalization.delegate
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('es', ''),
        const Locale('fr', ''),
        const Locale('ru', ''),
        const Locale('uz', ''),
        const Locale('uk', ''),
        // ...
      ],
  ```

  That's it.

  
### Supported languages

  - ar
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
  - ko
  - nb
  - nl
  - pt
  - ru
  - sv
  - tr
  - uk
  - uz
  - vi
  - zh
  
If one of the language you target is not supported you can submit a pull request in flutter_country_selector and phone_form_field repositories.


# Overwriting or adding custom flags

Some users have expressed their need to change some flags due to political reasons, or stylistic reasons. You might also wish to add your own flags. To do so refer to this issue: https://github.com/cedvdb/phone_form_field/issues/222