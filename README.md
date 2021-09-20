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

// works without any param
PhoneFormField();

// all params
PhoneFormField(
  key: inputKey,
  controller: controller,
  autofocus: true,
  autofillHints: [AutofillHints.telephoneNumber],
  selectorNavigator: selectorNavigator,
  defaultCountry: 'FR',
  decoration: InputDecoration(
    labelText: withLabel ? 'Phone' : null,
    border: outlineBorder ? OutlineInputBorder() : UnderlineInputBorder(),
  ),
  enabled: true,
  showFlagInInput: true,
  phoneNumberType: mobileOnly ? PhoneNumberType.mobile : null,
  autovalidateMode: autovalidate
      ? AutovalidateMode.onUserInteraction
      : AutovalidateMode.disabled,
  errorText: 'Invalid phone',
  cursorColor: Theme.of(context).colorScheme.primary,
  onSaved: (p) => print('saved $p'),
  onChanged: (p) => print('saved $p'),
)

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