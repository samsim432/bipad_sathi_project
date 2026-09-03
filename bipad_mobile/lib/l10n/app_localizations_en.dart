// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bipad Sathi';

  @override
  String get highRiskAlert => 'HIGH RISK WARNING!';

  @override
  String get highRiskSub =>
      'High flood risk detected in your area. Move to safe high ground.';

  @override
  String get viewDetails => 'View Details';

  @override
  String get sosButton => 'SOS';

  @override
  String get sosNeedRescue => 'I Need Rescue';

  @override
  String get sosSubtitle =>
      'Your precise details will be sent to nearby rescue teams.';

  @override
  String get peopleCount => 'Number of People';

  @override
  String get children => 'Children';

  @override
  String get elderly => 'Elderly';

  @override
  String get specialNeeds => 'Special Needs / Injured';

  @override
  String get sendSOS => 'Send SOS Emergency Alert';

  @override
  String get iAmSafe => 'I Am Safe';

  @override
  String get safeNotificationSent => 'Safe status sent to your family!';

  @override
  String get map => 'Disaster Map';

  @override
  String get reportHazard => 'Report Hazard';

  @override
  String get roadStatus => 'Road Status';

  @override
  String get safeShelters => 'Safe Shelters';

  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get missingFound => 'Missing / Found';
}
