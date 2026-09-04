import 'package:flutter/material.dart';

class EmergencyKitScreen extends StatefulWidget {
  final bool isNe;
  const EmergencyKitScreen({super.key, required this.isNe});

  @override
  State<EmergencyKitScreen> createState() => _EmergencyKitScreenState();
}

class _EmergencyKitScreenState extends State<EmergencyKitScreen> {
  final List<Map<String, dynamic>> _checklist = [
    {
      'title_en': 'Drinking Water (3-5 Liters)',
      'title_ne': 'पिउने पानी (३-५ लिटर)',
      'desc_en': 'Sealed bottled water or chlorine purification tablets.',
      'desc_ne': 'सिलबन्दी बोतल वा पानी शुद्धीकरण गर्ने क्लोरिन चक्की।',
      'checked': false,
    },
    {
      'title_en': 'Dry Foods & Energy Bars',
      'title_ne': 'सुख्खा खानेकुरा (चिउरा, दालमोठ, बिस्कुट)',
      'desc_en': 'Non-perishable food that requires no cooking.',
      'desc_ne': 'नबिग्रिने र पकाउनु नपर्ने पौष्टिक खानेकुरा।',
      'checked': false,
    },
    {
      'title_en': 'Flashlight & Extra Batteries',
      'title_ne': 'टर्चलाइट र थप ब्याट्रीहरू',
      'desc_en': 'High-lumen LED flashlight or solar torch.',
      'desc_ne': 'उज्यालो दिने टर्च वा सौर्य ऊर्जाबाट चल्ने बत्ती।',
      'checked': false,
    },
    {
      'title_en': 'First Aid Kit & Essential Medicines',
      'title_ne': 'प्राथमिक उपचार बक्स र नियमित औषधि',
      'desc_en': 'Bandages, antiseptic liquid, paracetamol, chronic meds.',
      'desc_ne': 'ब्यान्डेज, डेटोल, सिटामोल र नियमित सेवन गर्ने औषधि।',
      'checked': false,
    },
    {
      'title_en': 'Power Bank & Charging Cables',
      'title_ne': 'पावर बैंक र चार्जिङ केबल',
      'desc_en': 'Fully charged 10,000mAh+ emergency power bank.',
      'desc_ne': 'पूर्ण चार्ज गरिएको आपत्कालीन पावर बैंक।',
      'checked': false,
    },
    {
      'title_en': 'Important Documents in Waterproof Pouch',
      'title_ne': 'महत्वपूर्ण कागजात (नागरिकता, जग्गाधनी पुर्जा)',
      'desc_en': 'Citizenship, passport, land ownership, insurance papers.',
      'desc_ne': 'नागरिकता, राहदानी, बिमा तथा बैंकिङ कागजपत्रहरू।',
      'checked': false,
    },
    {
      'title_en': 'Whistle (Emergency Acoustic Signal)',
      'title_ne': 'ह्विसल (सिठी - उद्धार संकेतको लागि)',
      'desc_en': 'Helps rescuers locate you under debris without shouting.',
      'desc_ne': 'भग्नावशेषमा थुनिएमा उद्धारकर्तालाई संकेत पठाउन।',
      'checked': false,
    },
    {
      'title_en': 'Warm Blanket & Rain Poncho',
      'title_ne': 'न्यानो कपडा, कम्बल र रेनकोट',
      'desc_en': 'Protection against cold, hypothermia, and heavy rains.',
      'desc_ne': 'चिसो, हावाहुरी र पानीबाट बच्न आवश्यक कपडा।',
      'checked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;
    final completedCount = _checklist.where((i) => i['checked'] == true).length;
    final double progress = _checklist.isEmpty ? 0 : completedCount / _checklist.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'आपत्कालीन झोला (Go-Bag)' : 'Emergency Go-Bag',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Progress Overview Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 6, offset: Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isNe ? 'तपाईंको तयारी प्रगति' : 'Readiness Progress',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      '$completedCount / ${_checklist.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Checklist Items
          ..._checklist.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final title = isNe ? item['title_ne'] : item['title_en'];
            final desc = isNe ? item['desc_ne'] : item['desc_en'];

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: item['checked'] ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
                ),
              ),
              child: CheckboxListTile(
                value: item['checked'],
                activeColor: const Color(0xFF059669),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    decoration: item['checked'] ? TextDecoration.lineThrough : null,
                    color: item['checked'] ? const Color(0xFF64748B) : const Color(0xFF0F172A),
                  ),
                ),
                subtitle: Text(
                  desc,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                ),
                onChanged: (val) {
                  setState(() => _checklist[idx]['checked'] = val ?? false);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
