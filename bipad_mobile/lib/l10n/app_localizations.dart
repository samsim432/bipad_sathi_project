import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ne.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('en'),
    Locale('ne')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Bipad Sathi'**
  String get appTitle;

  /// No description provided for @highRiskAlert.
  ///
  /// In en, this message translates to:
  /// **'HIGH RISK WARNING!'**
  String get highRiskAlert;

  /// No description provided for @highRiskSub.
  ///
  /// In en, this message translates to:
  /// **'High flood risk detected in your area. Move to safe high ground.'**
  String get highRiskSub;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @sosButton.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sosButton;

  /// No description provided for @sosNeedRescue.
  ///
  /// In en, this message translates to:
  /// **'I Need Rescue'**
  String get sosNeedRescue;

  /// No description provided for @sosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your precise details will be sent to nearby rescue teams.'**
  String get sosSubtitle;

  /// No description provided for @peopleCount.
  ///
  /// In en, this message translates to:
  /// **'Number of People'**
  String get peopleCount;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @elderly.
  ///
  /// In en, this message translates to:
  /// **'Elderly'**
  String get elderly;

  /// No description provided for @specialNeeds.
  ///
  /// In en, this message translates to:
  /// **'Special Needs / Injured'**
  String get specialNeeds;

  /// No description provided for @sendSOS.
  ///
  /// In en, this message translates to:
  /// **'Send SOS Emergency Alert'**
  String get sendSOS;

  /// No description provided for @iAmSafe.
  ///
  /// In en, this message translates to:
  /// **'I Am Safe'**
  String get iAmSafe;

  /// No description provided for @safeNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Safe status sent to your family!'**
  String get safeNotificationSent;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Disaster Map'**
  String get map;

  /// No description provided for @reportHazard.
  ///
  /// In en, this message translates to:
  /// **'Report Hazard'**
  String get reportHazard;

  /// No description provided for @roadStatus.
  ///
  /// In en, this message translates to:
  /// **'Road Status'**
  String get roadStatus;

  /// No description provided for @safeShelters.
  ///
  /// In en, this message translates to:
  /// **'Safe Shelters'**
  String get safeShelters;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @missingFound.
  ///
  /// In en, this message translates to:
  /// **'Missing / Found'**
  String get missingFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ne'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ne':
      return AppLocalizationsNe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
