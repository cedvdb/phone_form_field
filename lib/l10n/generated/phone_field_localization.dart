import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'phone_field_localization_ar.dart';
import 'phone_field_localization_de.dart';
import 'phone_field_localization_el.dart';
import 'phone_field_localization_en.dart';
import 'phone_field_localization_es.dart';
import 'phone_field_localization_fa.dart';
import 'phone_field_localization_fr.dart';
import 'phone_field_localization_hi.dart';
import 'phone_field_localization_it.dart';
import 'phone_field_localization_nl.dart';
import 'phone_field_localization_pt.dart';
import 'phone_field_localization_ru.dart';
import 'phone_field_localization_sv.dart';
import 'phone_field_localization_tr.dart';
import 'phone_field_localization_uz.dart';
import 'phone_field_localization_uk.dart';
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
  PhoneFieldLocalization(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static PhoneFieldLocalization? of(BuildContext context) {
    return Localizations.of<PhoneFieldLocalization>(context, PhoneFieldLocalization);
  }

  static const LocalizationsDelegate<PhoneFieldLocalization> delegate = _PhoneFieldLocalizationDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('nl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sv'),
    Locale('tr'),
    Locale('uz'),
    Locale('uk'),
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

  /// No description provided for @noResultMessage.
  ///
  /// In en, this message translates to:
  /// **'No result'**
  String get noResultMessage;

  /// No description provided for @ac_.
  ///
  /// In en, this message translates to:
  /// **'Ascension Island'**
  String get ac_;

  /// No description provided for @ad_.
  ///
  /// In en, this message translates to:
  /// **'Andorra'**
  String get ad_;

  /// No description provided for @ae_.
  ///
  /// In en, this message translates to:
  /// **'United Arab Emirates'**
  String get ae_;

  /// No description provided for @af_.
  ///
  /// In en, this message translates to:
  /// **'Afghanistan'**
  String get af_;

  /// No description provided for @ag_.
  ///
  /// In en, this message translates to:
  /// **'Antigua and Barbuda'**
  String get ag_;

  /// No description provided for @ai_.
  ///
  /// In en, this message translates to:
  /// **'Anguilla'**
  String get ai_;

  /// No description provided for @al_.
  ///
  /// In en, this message translates to:
  /// **'Albania'**
  String get al_;

  /// No description provided for @am_.
  ///
  /// In en, this message translates to:
  /// **'Armenia'**
  String get am_;

  /// No description provided for @an_.
  ///
  /// In en, this message translates to:
  /// **'Netherlands Antilles'**
  String get an_;

  /// No description provided for @ao_.
  ///
  /// In en, this message translates to:
  /// **'Angola'**
  String get ao_;

  /// No description provided for @aq_.
  ///
  /// In en, this message translates to:
  /// **'Antarctica'**
  String get aq_;

  /// No description provided for @ar_.
  ///
  /// In en, this message translates to:
  /// **'Argentina'**
  String get ar_;

  /// No description provided for @as_.
  ///
  /// In en, this message translates to:
  /// **'American Samoa'**
  String get as_;

  /// No description provided for @at_.
  ///
  /// In en, this message translates to:
  /// **'Austria'**
  String get at_;

  /// No description provided for @au_.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get au_;

  /// No description provided for @aw_.
  ///
  /// In en, this message translates to:
  /// **'Aruba'**
  String get aw_;

  /// No description provided for @ax_.
  ///
  /// In en, this message translates to:
  /// **'Aland Islands'**
  String get ax_;

  /// No description provided for @az_.
  ///
  /// In en, this message translates to:
  /// **'Azerbaijan'**
  String get az_;

  /// No description provided for @ba_.
  ///
  /// In en, this message translates to:
  /// **'Bosnia and Herzegovina'**
  String get ba_;

  /// No description provided for @bb_.
  ///
  /// In en, this message translates to:
  /// **'Barbados'**
  String get bb_;

  /// No description provided for @bd_.
  ///
  /// In en, this message translates to:
  /// **'Bangladesh'**
  String get bd_;

  /// No description provided for @be_.
  ///
  /// In en, this message translates to:
  /// **'Belgium'**
  String get be_;

  /// No description provided for @bf_.
  ///
  /// In en, this message translates to:
  /// **'Burkina Faso'**
  String get bf_;

  /// No description provided for @bg_.
  ///
  /// In en, this message translates to:
  /// **'Bulgaria'**
  String get bg_;

  /// No description provided for @bh_.
  ///
  /// In en, this message translates to:
  /// **'Bahrain'**
  String get bh_;

  /// No description provided for @bi_.
  ///
  /// In en, this message translates to:
  /// **'Burundi'**
  String get bi_;

  /// No description provided for @bj_.
  ///
  /// In en, this message translates to:
  /// **'Benin'**
  String get bj_;

  /// No description provided for @bl_.
  ///
  /// In en, this message translates to:
  /// **'Saint Barthelemy'**
  String get bl_;

  /// No description provided for @bm_.
  ///
  /// In en, this message translates to:
  /// **'Bermuda'**
  String get bm_;

  /// No description provided for @bn_.
  ///
  /// In en, this message translates to:
  /// **'Brunei Darussalam'**
  String get bn_;

  /// No description provided for @bo_.
  ///
  /// In en, this message translates to:
  /// **'Bolivia, Plurinational State of'**
  String get bo_;

  /// No description provided for @bq_.
  ///
  /// In en, this message translates to:
  /// **'Bonaire'**
  String get bq_;

  /// No description provided for @br_.
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get br_;

  /// No description provided for @bs_.
  ///
  /// In en, this message translates to:
  /// **'Bahamas'**
  String get bs_;

  /// No description provided for @bt_.
  ///
  /// In en, this message translates to:
  /// **'Bhutan'**
  String get bt_;

  /// No description provided for @bw_.
  ///
  /// In en, this message translates to:
  /// **'Botswana'**
  String get bw_;

  /// No description provided for @by_.
  ///
  /// In en, this message translates to:
  /// **'Belarus'**
  String get by_;

  /// No description provided for @bz_.
  ///
  /// In en, this message translates to:
  /// **'Belize'**
  String get bz_;

  /// No description provided for @ca_.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get ca_;

  /// No description provided for @cc_.
  ///
  /// In en, this message translates to:
  /// **'Cocos (Keeling) Islands'**
  String get cc_;

  /// No description provided for @cd_.
  ///
  /// In en, this message translates to:
  /// **'Congo, The Democratic Republic of the Congo'**
  String get cd_;

  /// No description provided for @cf_.
  ///
  /// In en, this message translates to:
  /// **'Central African Republic'**
  String get cf_;

  /// No description provided for @cg_.
  ///
  /// In en, this message translates to:
  /// **'Congo'**
  String get cg_;

  /// No description provided for @ch_.
  ///
  /// In en, this message translates to:
  /// **'Switzerland'**
  String get ch_;

  /// No description provided for @ci_.
  ///
  /// In en, this message translates to:
  /// **'Cote d\'Ivoire'**
  String get ci_;

  /// No description provided for @ck_.
  ///
  /// In en, this message translates to:
  /// **'Cook Islands'**
  String get ck_;

  /// No description provided for @cl_.
  ///
  /// In en, this message translates to:
  /// **'Chile'**
  String get cl_;

  /// No description provided for @cm_.
  ///
  /// In en, this message translates to:
  /// **'Cameroon'**
  String get cm_;

  /// No description provided for @cn_.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get cn_;

  /// No description provided for @co_.
  ///
  /// In en, this message translates to:
  /// **'Colombia'**
  String get co_;

  /// No description provided for @cr_.
  ///
  /// In en, this message translates to:
  /// **'Costa Rica'**
  String get cr_;

  /// No description provided for @cu_.
  ///
  /// In en, this message translates to:
  /// **'Cuba'**
  String get cu_;

  /// No description provided for @cv_.
  ///
  /// In en, this message translates to:
  /// **'Cape Verde'**
  String get cv_;

  /// No description provided for @cx_.
  ///
  /// In en, this message translates to:
  /// **'Christmas Island'**
  String get cx_;

  /// No description provided for @cy_.
  ///
  /// In en, this message translates to:
  /// **'Cyprus'**
  String get cy_;

  /// No description provided for @cz_.
  ///
  /// In en, this message translates to:
  /// **'Czech Republic'**
  String get cz_;

  /// No description provided for @de_.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get de_;

  /// No description provided for @dj_.
  ///
  /// In en, this message translates to:
  /// **'Djibouti'**
  String get dj_;

  /// No description provided for @dk_.
  ///
  /// In en, this message translates to:
  /// **'Denmark'**
  String get dk_;

  /// No description provided for @dm_.
  ///
  /// In en, this message translates to:
  /// **'Dominica'**
  String get dm_;

  /// No description provided for @do_.
  ///
  /// In en, this message translates to:
  /// **'Dominican Republic'**
  String get do_;

  /// No description provided for @dz_.
  ///
  /// In en, this message translates to:
  /// **'Algeria'**
  String get dz_;

  /// No description provided for @ec_.
  ///
  /// In en, this message translates to:
  /// **'Ecuador'**
  String get ec_;

  /// No description provided for @ee_.
  ///
  /// In en, this message translates to:
  /// **'Estonia'**
  String get ee_;

  /// No description provided for @eg_.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get eg_;

  /// No description provided for @er_.
  ///
  /// In en, this message translates to:
  /// **'Eritrea'**
  String get er_;

  /// No description provided for @es_.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get es_;

  /// No description provided for @et_.
  ///
  /// In en, this message translates to:
  /// **'Ethiopia'**
  String get et_;

  /// No description provided for @fi_.
  ///
  /// In en, this message translates to:
  /// **'Finland'**
  String get fi_;

  /// No description provided for @fj_.
  ///
  /// In en, this message translates to:
  /// **'Fiji'**
  String get fj_;

  /// No description provided for @fk_.
  ///
  /// In en, this message translates to:
  /// **'Falkland Islands (Malvinas)'**
  String get fk_;

  /// No description provided for @fm_.
  ///
  /// In en, this message translates to:
  /// **'Micronesia, Federated States of Micronesia'**
  String get fm_;

  /// No description provided for @fo_.
  ///
  /// In en, this message translates to:
  /// **'Faroe Islands'**
  String get fo_;

  /// No description provided for @fr_.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get fr_;

  /// No description provided for @ga_.
  ///
  /// In en, this message translates to:
  /// **'Gabon'**
  String get ga_;

  /// No description provided for @gb_.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get gb_;

  /// No description provided for @gd_.
  ///
  /// In en, this message translates to:
  /// **'Grenada'**
  String get gd_;

  /// No description provided for @ge_.
  ///
  /// In en, this message translates to:
  /// **'Georgia'**
  String get ge_;

  /// No description provided for @gf_.
  ///
  /// In en, this message translates to:
  /// **'French Guiana'**
  String get gf_;

  /// No description provided for @gg_.
  ///
  /// In en, this message translates to:
  /// **'Guernsey'**
  String get gg_;

  /// No description provided for @gh_.
  ///
  /// In en, this message translates to:
  /// **'Ghana'**
  String get gh_;

  /// No description provided for @gi_.
  ///
  /// In en, this message translates to:
  /// **'Gibraltar'**
  String get gi_;

  /// No description provided for @gl_.
  ///
  /// In en, this message translates to:
  /// **'Greenland'**
  String get gl_;

  /// No description provided for @gm_.
  ///
  /// In en, this message translates to:
  /// **'Gambia'**
  String get gm_;

  /// No description provided for @gn_.
  ///
  /// In en, this message translates to:
  /// **'Guinea'**
  String get gn_;

  /// No description provided for @gp_.
  ///
  /// In en, this message translates to:
  /// **'Guadeloupe'**
  String get gp_;

  /// No description provided for @gq_.
  ///
  /// In en, this message translates to:
  /// **'Equatorial Guinea'**
  String get gq_;

  /// No description provided for @gr_.
  ///
  /// In en, this message translates to:
  /// **'Greece'**
  String get gr_;

  /// No description provided for @gs_.
  ///
  /// In en, this message translates to:
  /// **'South Georgia and the South Sandwich Islands'**
  String get gs_;

  /// No description provided for @gt_.
  ///
  /// In en, this message translates to:
  /// **'Guatemala'**
  String get gt_;

  /// No description provided for @gu_.
  ///
  /// In en, this message translates to:
  /// **'Guam'**
  String get gu_;

  /// No description provided for @gw_.
  ///
  /// In en, this message translates to:
  /// **'Guinea-Bissau'**
  String get gw_;

  /// No description provided for @gy_.
  ///
  /// In en, this message translates to:
  /// **'Guyana'**
  String get gy_;

  /// No description provided for @hk_.
  ///
  /// In en, this message translates to:
  /// **'Hong Kong'**
  String get hk_;

  /// No description provided for @hn_.
  ///
  /// In en, this message translates to:
  /// **'Honduras'**
  String get hn_;

  /// No description provided for @hr_.
  ///
  /// In en, this message translates to:
  /// **'Croatia'**
  String get hr_;

  /// No description provided for @ht_.
  ///
  /// In en, this message translates to:
  /// **'Haiti'**
  String get ht_;

  /// No description provided for @hu_.
  ///
  /// In en, this message translates to:
  /// **'Hungary'**
  String get hu_;

  /// No description provided for @id_.
  ///
  /// In en, this message translates to:
  /// **'Indonesia'**
  String get id_;

  /// No description provided for @ie_.
  ///
  /// In en, this message translates to:
  /// **'Ireland'**
  String get ie_;

  /// No description provided for @il_.
  ///
  /// In en, this message translates to:
  /// **'Israel'**
  String get il_;

  /// No description provided for @im_.
  ///
  /// In en, this message translates to:
  /// **'Isle of Man'**
  String get im_;

  /// No description provided for @in_.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get in_;

  /// No description provided for @io_.
  ///
  /// In en, this message translates to:
  /// **'British Indian Ocean Territory'**
  String get io_;

  /// No description provided for @iq_.
  ///
  /// In en, this message translates to:
  /// **'Iraq'**
  String get iq_;

  /// No description provided for @ir_.
  ///
  /// In en, this message translates to:
  /// **'Iran, Islamic Republic of'**
  String get ir_;

  /// No description provided for @is_.
  ///
  /// In en, this message translates to:
  /// **'Iceland'**
  String get is_;

  /// No description provided for @it_.
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get it_;

  /// No description provided for @je_.
  ///
  /// In en, this message translates to:
  /// **'Jersey'**
  String get je_;

  /// No description provided for @jm_.
  ///
  /// In en, this message translates to:
  /// **'Jamaica'**
  String get jm_;

  /// No description provided for @jo_.
  ///
  /// In en, this message translates to:
  /// **'Jordan'**
  String get jo_;

  /// No description provided for @jp_.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get jp_;

  /// No description provided for @ke_.
  ///
  /// In en, this message translates to:
  /// **'Kenya'**
  String get ke_;

  /// No description provided for @kg_.
  ///
  /// In en, this message translates to:
  /// **'Kyrgyzstan'**
  String get kg_;

  /// No description provided for @kh_.
  ///
  /// In en, this message translates to:
  /// **'Cambodia'**
  String get kh_;

  /// No description provided for @ki_.
  ///
  /// In en, this message translates to:
  /// **'Kiribati'**
  String get ki_;

  /// No description provided for @km_.
  ///
  /// In en, this message translates to:
  /// **'Comoros'**
  String get km_;

  /// No description provided for @kn_.
  ///
  /// In en, this message translates to:
  /// **'Saint Kitts and Nevis'**
  String get kn_;

  /// No description provided for @kp_.
  ///
  /// In en, this message translates to:
  /// **'Korea, Democratic People\'s Republic of Korea'**
  String get kp_;

  /// No description provided for @kr_.
  ///
  /// In en, this message translates to:
  /// **'Korea, Republic of South Korea'**
  String get kr_;

  /// No description provided for @kw_.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get kw_;

  /// No description provided for @ky_.
  ///
  /// In en, this message translates to:
  /// **'Cayman Islands'**
  String get ky_;

  /// No description provided for @kz_.
  ///
  /// In en, this message translates to:
  /// **'Kazakhstan'**
  String get kz_;

  /// No description provided for @la_.
  ///
  /// In en, this message translates to:
  /// **'Laos'**
  String get la_;

  /// No description provided for @lb_.
  ///
  /// In en, this message translates to:
  /// **'Lebanon'**
  String get lb_;

  /// No description provided for @lc_.
  ///
  /// In en, this message translates to:
  /// **'Saint Lucia'**
  String get lc_;

  /// No description provided for @li_.
  ///
  /// In en, this message translates to:
  /// **'Liechtenstein'**
  String get li_;

  /// No description provided for @lk_.
  ///
  /// In en, this message translates to:
  /// **'Sri Lanka'**
  String get lk_;

  /// No description provided for @lr_.
  ///
  /// In en, this message translates to:
  /// **'Liberia'**
  String get lr_;

  /// No description provided for @ls_.
  ///
  /// In en, this message translates to:
  /// **'Lesotho'**
  String get ls_;

  /// No description provided for @lt_.
  ///
  /// In en, this message translates to:
  /// **'Lithuania'**
  String get lt_;

  /// No description provided for @lu_.
  ///
  /// In en, this message translates to:
  /// **'Luxembourg'**
  String get lu_;

  /// No description provided for @lv_.
  ///
  /// In en, this message translates to:
  /// **'Latvia'**
  String get lv_;

  /// No description provided for @ly_.
  ///
  /// In en, this message translates to:
  /// **'Libya'**
  String get ly_;

  /// No description provided for @ma_.
  ///
  /// In en, this message translates to:
  /// **'Morocco'**
  String get ma_;

  /// No description provided for @mc_.
  ///
  /// In en, this message translates to:
  /// **'Monaco'**
  String get mc_;

  /// No description provided for @md_.
  ///
  /// In en, this message translates to:
  /// **'Moldova'**
  String get md_;

  /// No description provided for @me_.
  ///
  /// In en, this message translates to:
  /// **'Montenegro'**
  String get me_;

  /// No description provided for @mf_.
  ///
  /// In en, this message translates to:
  /// **'Saint Martin'**
  String get mf_;

  /// No description provided for @mg_.
  ///
  /// In en, this message translates to:
  /// **'Madagascar'**
  String get mg_;

  /// No description provided for @mh_.
  ///
  /// In en, this message translates to:
  /// **'Marshall Islands'**
  String get mh_;

  /// No description provided for @mk_.
  ///
  /// In en, this message translates to:
  /// **'Macedonia'**
  String get mk_;

  /// No description provided for @ml_.
  ///
  /// In en, this message translates to:
  /// **'Mali'**
  String get ml_;

  /// No description provided for @mm_.
  ///
  /// In en, this message translates to:
  /// **'Myanmar'**
  String get mm_;

  /// No description provided for @mn_.
  ///
  /// In en, this message translates to:
  /// **'Mongolia'**
  String get mn_;

  /// No description provided for @mo_.
  ///
  /// In en, this message translates to:
  /// **'Macao'**
  String get mo_;

  /// No description provided for @mp_.
  ///
  /// In en, this message translates to:
  /// **'Northern Mariana Islands'**
  String get mp_;

  /// No description provided for @mq_.
  ///
  /// In en, this message translates to:
  /// **'Martinique'**
  String get mq_;

  /// No description provided for @mr_.
  ///
  /// In en, this message translates to:
  /// **'Mauritania'**
  String get mr_;

  /// No description provided for @ms_.
  ///
  /// In en, this message translates to:
  /// **'Montserrat'**
  String get ms_;

  /// No description provided for @mt_.
  ///
  /// In en, this message translates to:
  /// **'Malta'**
  String get mt_;

  /// No description provided for @mu_.
  ///
  /// In en, this message translates to:
  /// **'Mauritius'**
  String get mu_;

  /// No description provided for @mv_.
  ///
  /// In en, this message translates to:
  /// **'Maldives'**
  String get mv_;

  /// No description provided for @mw_.
  ///
  /// In en, this message translates to:
  /// **'Malawi'**
  String get mw_;

  /// No description provided for @mx_.
  ///
  /// In en, this message translates to:
  /// **'Mexico'**
  String get mx_;

  /// No description provided for @my_.
  ///
  /// In en, this message translates to:
  /// **'Malaysia'**
  String get my_;

  /// No description provided for @mz_.
  ///
  /// In en, this message translates to:
  /// **'Mozambique'**
  String get mz_;

  /// No description provided for @na_.
  ///
  /// In en, this message translates to:
  /// **'Namibia'**
  String get na_;

  /// No description provided for @nc_.
  ///
  /// In en, this message translates to:
  /// **'New Caledonia'**
  String get nc_;

  /// No description provided for @ne_.
  ///
  /// In en, this message translates to:
  /// **'Niger'**
  String get ne_;

  /// No description provided for @nf_.
  ///
  /// In en, this message translates to:
  /// **'Norfolk Island'**
  String get nf_;

  /// No description provided for @ng_.
  ///
  /// In en, this message translates to:
  /// **'Nigeria'**
  String get ng_;

  /// No description provided for @ni_.
  ///
  /// In en, this message translates to:
  /// **'Nicaragua'**
  String get ni_;

  /// No description provided for @nl_.
  ///
  /// In en, this message translates to:
  /// **'Netherlands'**
  String get nl_;

  /// No description provided for @no_.
  ///
  /// In en, this message translates to:
  /// **'Norway'**
  String get no_;

  /// No description provided for @np_.
  ///
  /// In en, this message translates to:
  /// **'Nepal'**
  String get np_;

  /// No description provided for @nr_.
  ///
  /// In en, this message translates to:
  /// **'Nauru'**
  String get nr_;

  /// No description provided for @nu_.
  ///
  /// In en, this message translates to:
  /// **'Niue'**
  String get nu_;

  /// No description provided for @nz_.
  ///
  /// In en, this message translates to:
  /// **'New Zealand'**
  String get nz_;

  /// No description provided for @om_.
  ///
  /// In en, this message translates to:
  /// **'Oman'**
  String get om_;

  /// No description provided for @pa_.
  ///
  /// In en, this message translates to:
  /// **'Panama'**
  String get pa_;

  /// No description provided for @pe_.
  ///
  /// In en, this message translates to:
  /// **'Peru'**
  String get pe_;

  /// No description provided for @pf_.
  ///
  /// In en, this message translates to:
  /// **'French Polynesia'**
  String get pf_;

  /// No description provided for @pg_.
  ///
  /// In en, this message translates to:
  /// **'Papua New Guinea'**
  String get pg_;

  /// No description provided for @ph_.
  ///
  /// In en, this message translates to:
  /// **'Philippines'**
  String get ph_;

  /// No description provided for @pk_.
  ///
  /// In en, this message translates to:
  /// **'Pakistan'**
  String get pk_;

  /// No description provided for @pl_.
  ///
  /// In en, this message translates to:
  /// **'Poland'**
  String get pl_;

  /// No description provided for @pm_.
  ///
  /// In en, this message translates to:
  /// **'Saint Pierre and Miquelon'**
  String get pm_;

  /// No description provided for @pn_.
  ///
  /// In en, this message translates to:
  /// **'Pitcairn'**
  String get pn_;

  /// No description provided for @pr_.
  ///
  /// In en, this message translates to:
  /// **'Puerto Rico'**
  String get pr_;

  /// No description provided for @ps_.
  ///
  /// In en, this message translates to:
  /// **'Palestinian Territory, Occupied'**
  String get ps_;

  /// No description provided for @pt_.
  ///
  /// In en, this message translates to:
  /// **'Portugal'**
  String get pt_;

  /// No description provided for @pw_.
  ///
  /// In en, this message translates to:
  /// **'Palau'**
  String get pw_;

  /// No description provided for @py_.
  ///
  /// In en, this message translates to:
  /// **'Paraguay'**
  String get py_;

  /// No description provided for @qa_.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get qa_;

  /// No description provided for @re_.
  ///
  /// In en, this message translates to:
  /// **'Reunion'**
  String get re_;

  /// No description provided for @ro_.
  ///
  /// In en, this message translates to:
  /// **'Romania'**
  String get ro_;

  /// No description provided for @rs_.
  ///
  /// In en, this message translates to:
  /// **'Serbia'**
  String get rs_;

  /// No description provided for @ru_.
  ///
  /// In en, this message translates to:
  /// **'Russia'**
  String get ru_;

  /// No description provided for @rw_.
  ///
  /// In en, this message translates to:
  /// **'Rwanda'**
  String get rw_;

  /// No description provided for @sa_.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get sa_;

  /// No description provided for @sb_.
  ///
  /// In en, this message translates to:
  /// **'Solomon Islands'**
  String get sb_;

  /// No description provided for @sc_.
  ///
  /// In en, this message translates to:
  /// **'Seychelles'**
  String get sc_;

  /// No description provided for @sd_.
  ///
  /// In en, this message translates to:
  /// **'Sudan'**
  String get sd_;

  /// No description provided for @se_.
  ///
  /// In en, this message translates to:
  /// **'Sweden'**
  String get se_;

  /// No description provided for @sg_.
  ///
  /// In en, this message translates to:
  /// **'Singapore'**
  String get sg_;

  /// No description provided for @si_.
  ///
  /// In en, this message translates to:
  /// **'Slovenia'**
  String get si_;

  /// No description provided for @sk_.
  ///
  /// In en, this message translates to:
  /// **'Slovakia'**
  String get sk_;

  /// No description provided for @sl_.
  ///
  /// In en, this message translates to:
  /// **'Sierra Leone'**
  String get sl_;

  /// No description provided for @sm_.
  ///
  /// In en, this message translates to:
  /// **'San Marino'**
  String get sm_;

  /// No description provided for @sn_.
  ///
  /// In en, this message translates to:
  /// **'Senegal'**
  String get sn_;

  /// No description provided for @so_.
  ///
  /// In en, this message translates to:
  /// **'Somalia'**
  String get so_;

  /// No description provided for @sr_.
  ///
  /// In en, this message translates to:
  /// **'Suriname'**
  String get sr_;

  /// No description provided for @ss_.
  ///
  /// In en, this message translates to:
  /// **'South Sudan'**
  String get ss_;

  /// No description provided for @st_.
  ///
  /// In en, this message translates to:
  /// **'Sao Tome and Principe'**
  String get st_;

  /// No description provided for @sv_.
  ///
  /// In en, this message translates to:
  /// **'El Salvador'**
  String get sv_;

  /// No description provided for @sy_.
  ///
  /// In en, this message translates to:
  /// **'Syrian Arab Republic'**
  String get sy_;

  /// No description provided for @sz_.
  ///
  /// In en, this message translates to:
  /// **'Swaziland'**
  String get sz_;

  /// No description provided for @ta_.
  ///
  /// In en, this message translates to:
  /// **'Tristan da Cunha'**
  String get ta_;

  /// No description provided for @tc_.
  ///
  /// In en, this message translates to:
  /// **'Turks and Caicos Islands'**
  String get tc_;

  /// No description provided for @td_.
  ///
  /// In en, this message translates to:
  /// **'Chad'**
  String get td_;

  /// No description provided for @tg_.
  ///
  /// In en, this message translates to:
  /// **'Togo'**
  String get tg_;

  /// No description provided for @th_.
  ///
  /// In en, this message translates to:
  /// **'Thailand'**
  String get th_;

  /// No description provided for @tj_.
  ///
  /// In en, this message translates to:
  /// **'Tajikistan'**
  String get tj_;

  /// No description provided for @tk_.
  ///
  /// In en, this message translates to:
  /// **'Tokelau'**
  String get tk_;

  /// No description provided for @tl_.
  ///
  /// In en, this message translates to:
  /// **'Timor-Leste'**
  String get tl_;

  /// No description provided for @tm_.
  ///
  /// In en, this message translates to:
  /// **'Turkmenistan'**
  String get tm_;

  /// No description provided for @tn_.
  ///
  /// In en, this message translates to:
  /// **'Tunisia'**
  String get tn_;

  /// No description provided for @to_.
  ///
  /// In en, this message translates to:
  /// **'Tonga'**
  String get to_;

  /// No description provided for @tr_.
  ///
  /// In en, this message translates to:
  /// **'Turkey'**
  String get tr_;

  /// No description provided for @tt_.
  ///
  /// In en, this message translates to:
  /// **'Trinidad and Tobago'**
  String get tt_;

  /// No description provided for @tv_.
  ///
  /// In en, this message translates to:
  /// **'Tuvalu'**
  String get tv_;

  /// No description provided for @tw_.
  ///
  /// In en, this message translates to:
  /// **'Taiwan'**
  String get tw_;

  /// No description provided for @tz_.
  ///
  /// In en, this message translates to:
  /// **'Tanzania, United Republic of Tanzania'**
  String get tz_;

  /// No description provided for @ua_.
  ///
  /// In en, this message translates to:
  /// **'Ukraine'**
  String get ua_;

  /// No description provided for @ug_.
  ///
  /// In en, this message translates to:
  /// **'Uganda'**
  String get ug_;

  /// No description provided for @us_.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get us_;

  /// No description provided for @uy_.
  ///
  /// In en, this message translates to:
  /// **'Uruguay'**
  String get uy_;

  /// No description provided for @uz_.
  ///
  /// In en, this message translates to:
  /// **'Uzbekistan'**
  String get uz_;

  /// No description provided for @va_.
  ///
  /// In en, this message translates to:
  /// **'Holy See (Vatican City State)'**
  String get va_;

  /// No description provided for @vc_.
  ///
  /// In en, this message translates to:
  /// **'Saint Vincent and the Grenadines'**
  String get vc_;

  /// No description provided for @ve_.
  ///
  /// In en, this message translates to:
  /// **'Venezuela'**
  String get ve_;

  /// No description provided for @vg_.
  ///
  /// In en, this message translates to:
  /// **'Virgin Islands, British'**
  String get vg_;

  /// No description provided for @vi_.
  ///
  /// In en, this message translates to:
  /// **'Virgin Islands, U.S.'**
  String get vi_;

  /// No description provided for @vn_.
  ///
  /// In en, this message translates to:
  /// **'Vietnam'**
  String get vn_;

  /// No description provided for @vu_.
  ///
  /// In en, this message translates to:
  /// **'Vanuatu'**
  String get vu_;

  /// No description provided for @wf_.
  ///
  /// In en, this message translates to:
  /// **'Wallis and Futuna'**
  String get wf_;

  /// No description provided for @ws_.
  ///
  /// In en, this message translates to:
  /// **'Samoa'**
  String get ws_;

  /// No description provided for @ye_.
  ///
  /// In en, this message translates to:
  /// **'Yemen'**
  String get ye_;

  /// No description provided for @yt_.
  ///
  /// In en, this message translates to:
  /// **'Mayotte'**
  String get yt_;

  /// No description provided for @za_.
  ///
  /// In en, this message translates to:
  /// **'South Africa'**
  String get za_;

  /// No description provided for @zm_.
  ///
  /// In en, this message translates to:
  /// **'Zambia'**
  String get zm_;

  /// No description provided for @zw_.
  ///
  /// In en, this message translates to:
  /// **'Zimbabwe'**
  String get zw_;
}

class _PhoneFieldLocalizationDelegate extends LocalizationsDelegate<PhoneFieldLocalization> {
  const _PhoneFieldLocalizationDelegate();

  @override
  Future<PhoneFieldLocalization> load(Locale locale) {
    return SynchronousFuture<PhoneFieldLocalization>(lookupPhoneFieldLocalization(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'de', 'el', 'en', 'es', 'fa', 'fr', 'hi', 'it', 'nl', 'pt', 'ru', 'sv', 'tr', 'uz', 'uk', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_PhoneFieldLocalizationDelegate old) => false;
}

PhoneFieldLocalization lookupPhoneFieldLocalization(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return PhoneFieldLocalizationAr();
    case 'de': return PhoneFieldLocalizationDe();
    case 'el': return PhoneFieldLocalizationEl();
    case 'en': return PhoneFieldLocalizationEn();
    case 'es': return PhoneFieldLocalizationEs();
    case 'fa': return PhoneFieldLocalizationFa();
    case 'fr': return PhoneFieldLocalizationFr();
    case 'hi': return PhoneFieldLocalizationHi();
    case 'it': return PhoneFieldLocalizationIt();
    case 'nl': return PhoneFieldLocalizationNl();
    case 'pt': return PhoneFieldLocalizationPt();
    case 'ru': return PhoneFieldLocalizationRu();
    case 'sv': return PhoneFieldLocalizationSv();
    case 'tr': return PhoneFieldLocalizationTr();
    case 'uz': return PhoneFieldLocalizationUz();
    case 'uk': return PhoneFieldLocalizationUk();
    case 'zh': return PhoneFieldLocalizationZh();
  }

  throw FlutterError(
    'PhoneFieldLocalization.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
