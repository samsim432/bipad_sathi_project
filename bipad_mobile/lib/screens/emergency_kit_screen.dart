import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyKitScreen extends StatefulWidget {
  final bool isNe;
  const EmergencyKitScreen({super.key, required this.isNe});

  @override
  State<EmergencyKitScreen> createState() => _EmergencyKitScreenState();
}

class _EmergencyKitScreenState extends State<EmergencyKitScreen> {
  final Map<String, bool> _items = {};
  bool _isLoading = true;

  final List<Map<String, dynamic>> _kitCategories = [
    {
      'category': 'Water & Nutrition (पानी र खाना)',
      'icon': Icons.water_drop_rounded,
      'color': Color(0xFF0284C7),
      'items': [
        {'id': 'water', 'titleNe': 'प्रति व्यक्ति ३ लिटर पानी (Water 3L/person)', 'desc': 'कमसेकम ३ दिनको लागि पिउने पानी'},
        {'id': 'purification', 'titleNe': 'पानी शुद्धीकरण ट्याबलेट वा पियुष (Purification)', 'desc': 'बाढी वा फोहोर पानी शुद्ध बनाउन'},
        {'id': 'dry_food', 'titleNe': 'सुख्खा खानेकुरा (Dry Rations)', 'desc': 'चिउरा, बिस्कुट, दालमोट, चना, इनर्जी बार'},
      ],
    },
    {
      'category': 'Medical & First Aid (औषधि र प्राथमिक उपचार)',
      'icon': Icons.medical_services_rounded,
      'color': Color(0xFFDC2626),
      'items': [
        {'id': 'first_aid', 'titleNe': 'प्राथमिक उपचार किट (First Aid Box)', 'desc': 'ब्यान्डेज, डिटोल, कटन, सिटामोल, ओआरएस (जीवनजल)'},
        {'id': 'personal_meds', 'titleNe': 'नियमित खाने औषधि (Prescription Meds)', 'desc': 'सुगर, प्रेसर वा दमका बिरामीका लागि कम्तीमा ७ दिनको औषधि'},
        {'id': 'sanitary', 'titleNe': 'सरसफाइ सामग्री (Sanitary Kit)', 'desc': 'प्याड, साबुन, स्यानिटाइजर र मास्क'},
      ],
    },
    {
      'category': 'Tools, Light & Power (उपकरण तथा बत्ती)',
      'icon': Icons.flashlight_on_rounded,
      'color': Color(0xFFD97706),
      'items': [
        {'id': 'torch', 'titleNe': 'टर्चलाइट र थप ब्याट्री (Flashlight)', 'desc': 'राति हिँड्न तथा उद्धार संकेत गर्न'},
        {'id': 'powerbank', 'titleNe': 'फुल चार्ज भएको पावर बैंक (Power Bank)', 'desc': 'मोबाइल चार्ज गर्न र सम्पर्कमा रहन'},
        {'id': 'whistle', 'titleNe': 'सिठ्ठी (Rescue Whistle)', 'desc': 'पहिरो वा भग्नावशेषमा थुनिएमा आवाज निकाल्न'},
        {'id': 'lighter', 'titleNe': 'सलाई वा लाइटर (Lighter/Matches)', 'desc': 'पानी नपस्ने प्लाष्टिकमा सुरक्षित राखिएको'},
      ],
    },
    {
      'category': 'Documents & Cash (कागजात र नगद)',
      'icon': Icons.folder_shared_rounded,
      'color': Color(0xFF16A34A),
      'items': [
        {'id': 'docs', 'titleNe': 'महत्वपूर्ण कागजातको प्रतिलिपि (Documents)', 'desc': 'नागरिकता, लालपुर्जा, पासपोर्ट, जन्मदर्ता प्लाष्टिक झोलामा'},
        {'id': 'cash', 'titleNe': 'केही आकस्मिक नगद रुपैयाँ (Cash in Small Notes)', 'desc': 'एटीएम/अनलाइन नचल्दा आवश्यक पर्ने खुद्रा पैसा'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadChecklistState();
  }

  Future<void> _loadChecklistState() async {
    final prefs = await SharedPreferences.getInstance();
    for (var cat in _kitCategories) {
      for (var item in cat['items']) {
        final id = item['id'] as String;
        _items[id] = prefs.getBool('gobag_$id') ?? false;
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _toggleItem(String id, bool value) async {
    setState(() => _items[id] = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('gobag_$id', value);
  }

  double get _readinessScore {
    if (_items.isEmpty) return 0.0;
    int checked = _items.values.where((v) => v).length;
    return checked / _items.length;
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;
    final progress = _readinessScore;
    final percentage = (progress * 100).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'आकस्मिक झोला (७२ घण्टा तयारी)' : '72-Hour Emergency Go-Bag',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Readiness Score Card
                _buildScoreCard(percentage, progress, isNe),
                const SizedBox(height: 18),

                // 2. Category Blocks
                ..._kitCategories.map((cat) => _buildCategorySection(cat, isNe)),
              ],
            ),
    );
  }

  Widget _buildScoreCard(int percentage, double progress, bool isNe) {
    Color scoreColor = percentage >= 80
        ? const Color(0xFF16A34A)
        : (percentage >= 40 ? const Color(0xFFD97706) : const Color(0xFFDC2626));

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          // Circular Progress Chart
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 7,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNe ? 'विपद् पूर्वतयारी स्कोर' : 'Disaster Readiness Level',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  percentage >= 80
                      ? (isNe ? 'उत्कृष्ट! तपाईंको ७२ घण्टे झोला तयार छ।' : 'Ready for immediate evacuation.')
                      : (isNe ? 'बाँकी आवश्यक सामग्रीहरू थप गरी सुरक्षित रहनुहोस्।' : 'Add missing essentials to reach 100%.'),
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(Map<String, dynamic> cat, bool isNe) {
    final List items = cat['items'];
    final Color catColor = cat['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: catColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(cat['icon'], color: catColor, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cat['category'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          ...items.map((item) {
            final id = item['id'] as String;
            final isChecked = _items[id] ?? false;

            return CheckboxListTile(
              dense: true,
              activeColor: const Color(0xFF0F172A),
              value: isChecked,
              onChanged: (val) => _toggleItem(id, val ?? false),
              title: Text(
                item['titleNe'],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                  color: isChecked ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
                ),
              ),
              subtitle: Text(
                item['desc'],
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            );
          }),
        ],
      ),
    );
  }
}