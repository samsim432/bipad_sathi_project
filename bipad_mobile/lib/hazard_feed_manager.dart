import 'package:flutter/material.dart';

class HazardReportItem {
  final String id;
  final String author;
  final String title;
  final String location;
  final String time;
  final String hazardType;
  final String severity;
  final String? imageUrl;
  final IconData icon;
  final Color color;
  int upvotes;
  int downvotes;
  int userVote; // 1 for upvoted, -1 for downvoted, 0 for none
  final List<Map<String, String>> comments;

  HazardReportItem({
    required this.id,
    required this.author,
    required this.title,
    required this.location,
    required this.time,
    required this.hazardType,
    required this.severity,
    this.imageUrl,
    required this.icon,
    required this.color,
    required this.upvotes,
    required this.downvotes,
    this.userVote = 0,
    required this.comments,
  });

  bool get isVerified => (upvotes - downvotes) >= 5;
  bool get isDisputed => (downvotes - upvotes) >= 3;
}

class HazardFeedManager extends ChangeNotifier {
  static final HazardFeedManager instance = HazardFeedManager._();
  HazardFeedManager._();

  final List<HazardReportItem> reports = [
    HazardReportItem(
      id: 'HAZ-101',
      author: 'Ramesh Karki',
      title: 'मुग्लिन नजिकै ठूलो सुख्खा पहिरो खसेर बाटो पूर्ण बन्द',
      location: 'Mugling-Malekhu Highway, Dhading (Ward 4)',
      time: '15 mins ago',
      hazardType: 'LANDSLIDE',
      severity: 'HIGH',
      imageUrl: 'https://images.unsplash.com/photo-1547683905-f686c993aae5?w=800&q=80',
      icon: Icons.landslide_rounded,
      color: const Color(0xFFDC2626),
      upvotes: 18,
      downvotes: 1,
      userVote: 0,
      comments: [
        {'author': 'Hari Sharma', 'text': 'प्रहरी टोली डोजर लिएर पुगिसकेको छ। खुल्न कम्तीमा २ घण्टा लाग्छ।', 'time': '5m ago'},
        {'author': 'Bikash Tamang', 'text': 'गाडीहरू ३ कि.मि जाममा छन्। बैकल्पिक बाटो प्रयोग गर्नुहोस्।', 'time': '2m ago'},
      ],
    ),
    HazardReportItem(
      id: 'HAZ-102',
      author: 'Sunita Rai',
      title: 'बागमती नदीको पानी बस्ती पस्न थाल्यो, सतर्क रहनुहोला',
      location: 'Gaur, Rautahat (Bypass Road)',
      time: '35 mins ago',
      hazardType: 'FLOOD',
      severity: 'CRITICAL',
      imageUrl: null,
      icon: Icons.water_damage_rounded,
      color: const Color(0xFF0284C7),
      upvotes: 24,
      downvotes: 0,
      userVote: 1,
      comments: [
        {'author': 'Nepal Police', 'text': 'स्थानीय उद्धार टोली डुंगासहित खटिएको छ।', 'time': '10m ago'},
      ],
    ),
  ];

  void addReport(HazardReportItem report) {
    reports.insert(0, report);
    notifyListeners();
  }

  void vote(String id, int direction) {
    final idx = reports.indexWhere((r) => r.id == id);
    if (idx == -1) return;

    final report = reports[idx];
    if (report.userVote == direction) {
      // Undo vote
      if (direction == 1) report.upvotes--;
      if (direction == -1) report.downvotes--;
      report.userVote = 0;
    } else {
      // Switch or apply vote
      if (report.userVote == 1) report.upvotes--;
      if (report.userVote == -1) report.downvotes--;

      if (direction == 1) report.upvotes++;
      if (direction == -1) report.downvotes++;
      report.userVote = direction;
    }
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
}