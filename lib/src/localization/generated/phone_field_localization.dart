import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'phone_field_localization_ar.dart';
import 'phone_field_localization_ckb.dart';
import 'phone_field_localization_de.dart';
import 'phone_field_localization_el.dart';
import 'phone_field_localization_en.dart';
import 'phone_field_localization_es.dart';
import 'phone_field_localization_fa.dart';
import 'phone_field_localization_fr.dart';
import 'phone_field_localization_hi.dart';
import 'phone_field_localization_it.dart';
import 'phone_field_localization_ku.dart';
import 'phone_field_localization_nb.dart';
import 'phone_field_localization_nl.dart';
import 'phone_field_localization_pt.dart';
import 'phone_field_localization_ru.dart';
import 'phone_field_localization_sv.dart';
import 'phone_field_localization_tr.dart';
import 'phone_field_localization_uk.dart';
import 'phone_field_localization_uz.dart';
import 'phone_field_localization_zh.dart';

/// Callers can lookup localized strings with an instance of PhoneFieldLocalization
/// returned by `PhoneFieldLocalization.of(context)`.
///
/// Applications need to include `PhoneFieldLocalization.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/phone_field_localization.dart';
///
/// return MaterialApp(
///   localizationsDelegates: PhoneFieldLocalization.localizationsDelegates,
///   supportedLocales: PhoneFieldLocalization.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the PhoneFieldLocalization.supportedLocales
/// property.
abstract class PhoneFieldLocalization {
  PhoneFieldLocalization(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static PhoneFieldLocalization? of(BuildContext context) {
    return Localizations.of<PhoneFieldLocalization>(
        context, PhoneFieldLocalization);
  }

  static const LocalizationsDelegate<PhoneFieldLocalization> delegate =
      _PhoneFieldLocalizationDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('ckb'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ku'),
    Locale('nb'),
    Locale('nl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sv'),
    Locale('tr'),
    Locale('uk'),
    Locale('uz'),
    Locale('zh')
  ];

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @invalidCountry.
  ///
  /// In en, this message translates to:
  /// **'Invalid country'**
  String get invalidCountry;

  /// No description provided for @invalidMobilePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid mobile phone number'**
  String get invalidMobilePhoneNumber;

  /// No description provided for @invalidFixedLinePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid fixed line phone number'**
  String get invalidFixedLinePhoneNumber;

  /// No description provided for @requiredPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Required phone number'**
  String get requiredPhoneNumber;
}

class _PhoneFieldLocalizationDelegate
    extends LocalizationsDelegate<PhoneFieldLocalization> {
  const _PhoneFieldLocalizationDelegate();

  @override
  Future<PhoneFieldLocalization> load(Locale locale) {
    return SynchronousFuture<PhoneFieldLocalization>(
        lookupPhoneFieldLocalization(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'ckb',
        'de',
        'el',
        'en',
        'es',
        'fa',
        'fr',
        'hi',
        'it',
        'ku',
        'nb',
        'nl',
        'pt',
        'ru',
        'sv',
        'tr',
        'uk',
        'uz',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_PhoneFieldLocalizationDelegate old) => false;
}

PhoneFieldLocalization lookupPhoneFieldLocalization(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return PhoneFieldLocalizationAr();
    case 'ckb':
      return PhoneFieldLocalizationCkb();
    case 'de':
      return PhoneFieldLocalizationDe();
    case 'el':
      return PhoneFieldLocalizationEl();
    case 'en':
      return PhoneFieldLocalizationEn();
    case 'es':
      return PhoneFieldLocalizationEs();
    case 'fa':
      return PhoneFieldLocalizationFa();
    case 'fr':
      return PhoneFieldLocalizationFr();
    case 'hi':
      return PhoneFieldLocalizationHi();
    case 'it':
      return PhoneFieldLocalizationIt();
    case 'ku':
      return PhoneFieldLocalizationKu();
    case 'nb':
      return PhoneFieldLocalizationNb();
    case 'nl':
      return PhoneFieldLocalizationNl();
    case 'pt':
      return PhoneFieldLocalizationPt();
    case 'ru':
      return PhoneFieldLocalizationRu();
    case 'sv':
      return PhoneFieldLocalizationSv();
    case 'tr':
      return PhoneFieldLocalizationTr();
    case 'uk':
      return PhoneFieldLocalizationUk();
    case 'uz':
      return PhoneFieldLocalizationUz();
    case 'zh':
      return PhoneFieldLocalizationZh();
  }

  throw FlutterError(
      'PhoneFieldLocalization.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
