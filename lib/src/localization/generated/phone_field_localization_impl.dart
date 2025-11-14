import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'phone_field_localization_impl_ar.dart';
import 'phone_field_localization_impl_ca.dart';
import 'phone_field_localization_impl_ckb.dart';
import 'phone_field_localization_impl_cs.dart';
import 'phone_field_localization_impl_de.dart';
import 'phone_field_localization_impl_el.dart';
import 'phone_field_localization_impl_en.dart';
import 'phone_field_localization_impl_es.dart';
import 'phone_field_localization_impl_fa.dart';
import 'phone_field_localization_impl_fr.dart';
import 'phone_field_localization_impl_he.dart';
import 'phone_field_localization_impl_hi.dart';
import 'phone_field_localization_impl_hu.dart';
import 'phone_field_localization_impl_it.dart';
import 'phone_field_localization_impl_ku.dart';
import 'phone_field_localization_impl_nb.dart';
import 'phone_field_localization_impl_nl.dart';
import 'phone_field_localization_impl_pl.dart';
import 'phone_field_localization_impl_pt.dart';
import 'phone_field_localization_impl_ru.dart';
import 'phone_field_localization_impl_sk.dart';
import 'phone_field_localization_impl_sv.dart';
import 'phone_field_localization_impl_tr.dart';
import 'phone_field_localization_impl_uk.dart';
import 'phone_field_localization_impl_uz.dart';
import 'phone_field_localization_impl_vi.dart';
import 'phone_field_localization_impl_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of PhoneFieldLocalizationImpl
/// returned by `PhoneFieldLocalizationImpl.of(context)`.
///
/// Applications need to include `PhoneFieldLocalizationImpl.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/phone_field_localization_impl.dart';
///
/// return MaterialApp(
///   localizationsDelegates: PhoneFieldLocalizationImpl.localizationsDelegates,
///   supportedLocales: PhoneFieldLocalizationImpl.supportedLocales,
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
/// be consistent with the languages listed in the PhoneFieldLocalizationImpl.supportedLocales
/// property.
abstract class PhoneFieldLocalizationImpl {
  PhoneFieldLocalizationImpl(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static PhoneFieldLocalizationImpl? of(BuildContext context) {
    return Localizations.of<PhoneFieldLocalizationImpl>(
        context, PhoneFieldLocalizationImpl);
  }

  static const LocalizationsDelegate<PhoneFieldLocalizationImpl> delegate =
      _PhoneFieldLocalizationImplDelegate();

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
    Locale('ca'),
    Locale('ckb'),
    Locale('cs'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('hu'),
    Locale('it'),
    Locale('ku'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sk'),
    Locale('sv'),
    Locale('tr'),
    Locale('uk'),
    Locale('uz'),
    Locale('vi'),
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

  /// semantic description of the country button
  ///
  /// In en, this message translates to:
  /// **'Select a country. Current selection: {countryName} {dialCode}'**
  String selectACountrySemanticLabel(String countryName, String dialCode);

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// semantic description of the phone input. The label or hint will be dynamically added
  ///
  /// In en, this message translates to:
  /// **'Current value: {currentValue}'**
  String currentValueSemanticLabel(String currentValue);
}

class _PhoneFieldLocalizationImplDelegate
    extends LocalizationsDelegate<PhoneFieldLocalizationImpl> {
  const _PhoneFieldLocalizationImplDelegate();

  @override
  Future<PhoneFieldLocalizationImpl> load(Locale locale) {
    return SynchronousFuture<PhoneFieldLocalizationImpl>(
        lookupPhoneFieldLocalizationImpl(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'ca',
        'ckb',
        'cs',
        'de',
        'el',
        'en',
        'es',
        'fa',
        'fr',
        'he',
        'hi',
        'hu',
        'it',
        'ku',
        'nb',
        'nl',
        'pl',
        'pt',
        'ru',
        'sk',
        'sv',
        'tr',
        'uk',
        'uz',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_PhoneFieldLocalizationImplDelegate old) => false;
}

PhoneFieldLocalizationImpl lookupPhoneFieldLocalizationImpl(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return PhoneFieldLocalizationImplAr();
    case 'ca':
      return PhoneFieldLocalizationImplCa();
    case 'ckb':
      return PhoneFieldLocalizationImplCkb();
    case 'cs':
      return PhoneFieldLocalizationImplCs();
    case 'de':
      return PhoneFieldLocalizationImplDe();
    case 'el':
      return PhoneFieldLocalizationImplEl();
    case 'en':
      return PhoneFieldLocalizationImplEn();
    case 'es':
      return PhoneFieldLocalizationImplEs();
    case 'fa':
      return PhoneFieldLocalizationImplFa();
    case 'fr':
      return PhoneFieldLocalizationImplFr();
    case 'he':
      return PhoneFieldLocalizationImplHe();
    case 'hi':
      return PhoneFieldLocalizationImplHi();
    case 'hu':
      return PhoneFieldLocalizationImplHu();
    case 'it':
      return PhoneFieldLocalizationImplIt();
    case 'ku':
      return PhoneFieldLocalizationImplKu();
    case 'nb':
      return PhoneFieldLocalizationImplNb();
    case 'nl':
      return PhoneFieldLocalizationImplNl();
    case 'pl':
      return PhoneFieldLocalizationImplPl();
    case 'pt':
      return PhoneFieldLocalizationImplPt();
    case 'ru':
      return PhoneFieldLocalizationImplRu();
    case 'sk':
      return PhoneFieldLocalizationImplSk();
    case 'sv':
      return PhoneFieldLocalizationImplSv();
    case 'tr':
      return PhoneFieldLocalizationImplTr();
    case 'uk':
      return PhoneFieldLocalizationImplUk();
    case 'uz':
      return PhoneFieldLocalizationImplUz();
    case 'vi':
      return PhoneFieldLocalizationImplVi();
    case 'zh':
      return PhoneFieldLocalizationImplZh();
  }

  throw FlutterError(
      'PhoneFieldLocalizationImpl.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
