# phone_form_field

Flutter phone input integrated with flutter internationalization

## Features

- Totally cross platform, this is a dart only package / dependencies
- Internationalization
- Phone number validation
- Support autofill and copy paste
- Extends Flutter's FormField
- Uses dart phone_numbers_parser for parsing


## Demo

Demo available at https://cedvdb.github.io/phone_form_field/

![demo img](https://raw.githubusercontent.com/cedvdb/phone_number_input/main/demo_image.png)

## Usage

```dart
PhoneFormField(
  autofocus: true,
  decoration: InputDecoration(
    labelText: 'Phone',
    border: OutlineInputBorder(),
    // ...
  ),
  phoneNumberType: null, // can be PhoneNumberType.mobile or phoneNumberType.fixed or null for both validation
  selectorNavigator: const BottomSheetNavigator(), // default to bottom sheet but you can customize how the selector is shown by extending CountrySelectorNavigator
  lightParser: false, // using true here reduce memory foot print but only use length to validate
),

```

## Internationalization

  Include the delegate

  ```dart
    return MaterialApp(
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        PhoneFieldLocalization.delegate
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('es', ''),
        const Locale('fr', ''),
        const Locale('ru', ''),
        // ...
      ],
  ```

  Tnat's it.

  
  A bunch of languages are built-in:

    - 'ar',
    - 'de',
    - 'en',
    - 'es',
    - 'fr',
    - 'hin',
    - 'it',
    - 'nl',
    - 'pt',
    - 'ru',
    - 'zh',
  
  
   If one of the language you target is not supported you can submit a
  pull request with the translated file in assets/translation