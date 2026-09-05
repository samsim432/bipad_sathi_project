import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum HazardSeverity { low, medium, high, critical }
enum HazardSource { official, crowdsourced }

class HazardReportItem {
  final String id;
  final String author;
  final String title;
  final String location;
  final LatLng position;
  final String time;
  final String hazardType; // FLOOD, LANDSLIDE, FIRE, EARTHQUAKE
  final dynamic severity; // Accepts HazardSeverity or String
  final HazardSource source;
  final String? imageUrl;
  final IconData icon;
  final Color color;
  int upvotes;
  int downvotes;
  int userVote;
  final List<Map<String, String>> comments;

  HazardReportItem({
    required this.id,
    required this.author,
    required this.title,
    required this.location,
    LatLng? position,
    required this.time,
    required this.hazardType,
    required this.severity,
    this.source = HazardSource.crowdsourced,
    this.imageUrl,
    required this.icon,
    required this.color,
    required this.upvotes,
    required this.downvotes,
    this.userVote = 0,
    required this.comments,
  }) : position = position ?? const LatLng(27.7172, 85.3240);

  bool get isVerified => source == HazardSource.official || (upvotes - downvotes) >= 5;
  bool get isDisputed => (downvotes - upvotes) >= 3;
}

class ShelterLocation {
  final String id;
  final String name;
  final String address;
  final LatLng position;
  final int capacity;
  final int availableBeds;
  final bool hasWater;
  final bool hasMedical;
  final String contactPhone;

  ShelterLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.position,
    required this.capacity,
    required this.availableBeds,
    required this.hasWater,
    required this.hasMedical,
    required this.contactPhone,
  });
}

class RiverGaugeAlert {
  final String station;
  final String river;
  final double currentLevel;
  final double warningLevel;
  final double dangerLevel;
  final LatLng position;
  final String status;

  RiverGaugeAlert({
    required this.station,
    required this.river,
    required this.currentLevel,
    required this.warningLevel,
    required this.dangerLevel,
    required this.position,
    required this.status,
  });
}

class HazardFeedManager extends ChangeNotifier {
  static final HazardFeedManager instance = HazardFeedManager._();
  HazardFeedManager._();

  final List<HazardReportItem> reports = [
    HazardReportItem(
      id: 'HAZ-101',
      author: 'Nepal Police Dispatch',
      title: 'मुग्लिन नजिकै ठूलो सुख्खा पहिरो खसेर बाटो पूर्ण बन्द',
      location: 'Mugling-Malekhu Highway, Dhading',
      position: const LatLng(27.8573, 84.5843),
      time: '15 mins ago',
      hazardType: 'LANDSLIDE',
      severity: HazardSeverity.high,
      source: HazardSource.official,
      imageUrl: 'https://images.unsplash.com/photo-1547683905-f686c993aae5?w=800&q=80',
      icon: Icons.landslide_rounded,
      color: const Color(0xFFDC2626),
      upvotes: 42,
      downvotes: 0,
      userVote: 1,
      comments: [
        {'author': 'Hari Sharma', 'text': 'डोजर खटिएको छ। खुल्न कम्तीमा २ घण्टा लाग्छ।', 'time': '5m ago'},
      ],
    ),
    HazardReportItem(
      id: 'HAZ-102',
      author: 'Sunita Rai',
      title: 'बागमती नदीको पानी बस्ती पस्न थाल्यो, सतर्क रहनुहोला',
      location: 'Gaur, Rautahat',
      position: const LatLng(26.7644, 85.2783),
      time: '35 mins ago',
      hazardType: 'FLOOD',
      severity: HazardSeverity.critical,
      source: HazardSource.crowdsourced,
      icon: Icons.water_damage_rounded,
      color: const Color(0xFF0284C7),
      upvotes: 24,
      downvotes: 0,
      userVote: 1,
      comments: [
        {'author': 'APF Rescue', 'text': 'स्थानीय उद्धार टोली डुंगासहित खटिएको छ।', 'time': '10m ago'},
      ],
    ),
  ];

  final List<ShelterLocation> shelters = [
    ShelterLocation(
      id: 'SH-01',
      name: 'दशरथ रंगशाला आकस्मिक आश्रय केन्द्र',
      address: 'Tripureshwor, Kathmandu',
      position: const LatLng(27.6953, 85.3149),
      capacity: 500,
      availableBeds: 210,
      hasWater: true,
      hasMedical: true,
      contactPhone: '01-4261234',
    ),
    ShelterLocation(
      id: 'SH-02',
      name: 'भरतपुर सामुदायिक भवन',
      address: 'Chitwan, Bharatpur-10',
      position: const LatLng(27.6833, 84.4333),
      capacity: 250,
      availableBeds: 95,
      hasWater: true,
      hasMedical: true,
      contactPhone: '056-520100',
    ),
  ];

  final List<RiverGaugeAlert> riverGauges = [
    RiverGaugeAlert(
      station: 'Devghat',
      river: 'Narayani River (नारायणी)',
      currentLevel: 9.4,
      warningLevel: 7.3,
      dangerLevel: 9.0,
      position: const LatLng(27.7058, 84.4239),
      status: 'DANGER',
    ),
  ];

  void addReport(HazardReportItem report) {
    reports.insert(0, report);
    notifyListeners();
  }

  void addComment(String id, String text, String author) {
    final idx = reports.indexWhere((r) => r.id == id);
    if (idx == -1) return;
    reports[idx].comments.add({
      'author': author,
      'text': text,
      'time': 'Just now',
    });
    notifyListeners();
  }

  void vote(String id, int direction) {
    final idx = reports.indexWhere((r) => r.id == id);
    if (idx == -1) return;
    final report = reports[idx];

    if (report.userVote == direction) {
      if (direction == 1) report.upvotes--;
      if (direction == -1) report.downvotes--;
      report.userVote = 0;
    } else {
      if (report.userVote == 1) report.upvotes--;
      if (report.userVote == -1) report.downvotes--;
      if (direction == 1) report.upvotes++;
      if (direction == -1) report.downvotes++;
      report.userVote = direction;
    }
    notifyListeners();
  }
}