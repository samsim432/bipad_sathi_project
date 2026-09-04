import 'package:flutter/material.dart';

class FirstAidScreen extends StatefulWidget {
  final bool isNe;
  const FirstAidScreen({super.key, required this.isNe});

  @override
  State<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> {
  String _selectedCategory = 'ALL';

  final List<Map<String, dynamic>> _guides = [
    {
      'id': 'cpr',
      'title_en': 'CPR (Cardiopulmonary Resuscitation)',
      'title_ne': 'सीपीआर (हृदय गति पुनः सुचारु)',
      'category': 'LIFE_SAVING',
      'icon': Icons.favorite_rounded,
      'color': Color(0xFFDC2626),
      'steps_en': [
        '1. Check responsiveness & pulse.',
        '2. Place hands centered on chest.',
        '3. Push hard & fast (100–120 beats per minute, 2 inches deep).',
        '4. Deliver 2 rescue breaths after every 30 compressions if trained.'
      ],
      'steps_ne': [
        '१. बिरामीको होस र नाडी जाँच गर्नुहोस्।',
        '२. छातीको बीच भागमा दुवै हात राख्नुहोस्।',
        '३. प्रति मिनेट १००–१२० पटक २ इन्च गहिरो थिच्नुहोस्।',
        '४. तालिम प्राप्त भए ३० पटक थिचेपछि २ पटक कृत्रिम सास दिनुहोस्।'
      ]
    },
    {
      'id': 'bleeding',
      'title_en': 'Severe Bleeding Control',
      'title_ne': 'अत्यधिक रक्तस्राव नियन्त्रण',
      'category': 'TRAUMA',
      'icon': Icons.water_drop_rounded,
      'color': Color(0xFFB91C1C),
      'steps_en': [
        '1. Apply firm, continuous direct pressure with a clean cloth.',
        '2. Do NOT remove soaked cloth; add more layers on top.',
        '3. Elevate the injured limb above heart level if no fracture.',
        '4. Apply a tourniquet 2-3 inches above wound only if bleeding is life-threatening.'
      ],
      'steps_ne': [
        '१. सफा कपडाले घाउमा लगातार बलियो दबाब दिनुहोस्।',
        '२. भिजेको कपडा नहटाउनुहोस्, माथिबाट थप कपडा थप्नुहोस्।',
        '३. हड्डी नभाँचिएको भए चोट लागेको अंग मुटुको सतहभन्दा माथि उठाउनुहोस्।',
        '४. अत्यधिक रगत बगेमा घाउभन्दा २–३ इन्च माथि कस्नुहोस् (Tourniquet)।'
      ]
    },
    {
      'id': 'snakebite',
      'title_en': 'Snakebite Emergency (सर्पदंश)',
      'title_ne': 'सर्पदंश (सर्पले टोकेमा)',
      'category': 'ENVIRONMENTAL',
      'icon': Icons.healing_rounded,
      'color': Color(0xFF047857),
      'steps_en': [
        '1. Keep victim completely calm and still to slow venom spread.',
        '2. Immobilize the bitten limb with a splint.',
        '3. DO NOT cut the wound, suck venom, or use tight tourniquets.',
        '4. Transport immediately to the nearest Anti-Snake Venom (ASV) hospital.'
      ],
      'steps_ne': [
        '१. बिरामीलाई नचलाई शान्त राख्नुहोस् ता कि विष छिटो नफैलिओस्।',
        '२. टोकेको भागलाई काठ वा कपडाले बाँधेर स्थिर राख्नुहोस्।',
        '३. घाउ चिर्ने, विष चुस्ने वा कडा बाँध्ने काम नगर्नुहोस्।',
        '४. तुरुन्तै एन्टिस्नेक भेनम (ASV) उपलब्ध अस्पताल लैजानुहोस्।'
      ]
    },
    {
      'id': 'fracture',
      'title_en': 'Bone Fracture & Sprain',
      'title_ne': 'हड्डी भाँच्चिएमा वा मर्किएमा',
      'category': 'TRAUMA',
      'icon': Icons.accessibility_new_rounded,
      'color': Color(0xFFD97706),
      'steps_en': [
        '1. Do not attempt to realign or push protruding bones back.',
        '2. Immobilize the limb using a splint or rolled cardboard.',
        '3. Apply cold packs wrapped in cloth (avoid direct ice on skin).',
        '4. Check pulse and skin temperature below the fracture.'
      ],
      'steps_ne': [
        '१. भाँचिएको हड्डी सोझ्याउने वा भित्र छिराउने प्रयास नगर्नुहोस्।',
        '२. काठ, बाँस वा गत्ताको सहाराले अङ्गलाई स्थिर पार्नुहोस्।',
        '३. कपडामा बेरेर बरफले सेक्नुहोस् (सिधै छालामा बरफ नराख्नुहोस्)।',
        '४. तुरुन्तै नजिकैको स्वास्थ्य चौकी लैजानुहोस्।'
      ]
    },
    {
      'id': 'burns',
      'title_en': 'Thermal Burns & Scalds',
      'title_ne': 'आगोले वा तातोले पोलेमा',
      'category': 'TRAUMA',
      'icon': Icons.local_fire_department_rounded,
      'color': Color(0xFFC2410C),
      'steps_en': [
        '1. Cool the burn under gentle running tap water for 15–20 minutes.',
        '2. Do NOT apply ice, toothpaste, butter, or oil.',
        '3. Cover loosely with sterile plastic cling wrap or a clean damp cloth.',
        '4. Do NOT burst any blisters.'
      ],
      'steps_ne': [
        '१. १५ देखि २० मिनेटसम्म धाराको चिसो पानीले पोलेको भाग पखाल्नुहोस्।',
        '२. मन्जन, घ्यू, तेल वा बरफ नलगाउनुहोस्।',
        '३. सफा कपडा वा पातलो प्लास्टिकले हल्का छोप्नुहोस्।',
        '४. उठेको फोका नफुटाउनुहोस्।'
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'अग्रिम प्राथमिक उपचार' : 'Offline First Aid Guide',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.offline_pin_rounded, color: Color(0xFF059669), size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isNe
                        ? 'यो निर्देशिका इन्टरनेट नभएको अवस्थामा पनि १००% काम गर्छ।'
                        : 'Works 100% offline without cellular or Wi-Fi connectivity.',
                    style: const TextStyle(color: Color(0xFF065F46), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._guides.map((g) => _buildGuideCard(g, isNe)),
        ],
      ),
    );
  }

  Widget _buildGuideCard(Map<String, dynamic> item, bool isNe) {
    final steps = isNe ? (item['steps_ne'] as List<String>) : (item['steps_en'] as List<String>);
    final title = isNe ? item['title_ne'] : item['title_en'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (item['color'] as Color).withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item['icon'], color: item['color'], size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: steps.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.arrow_right_rounded, color: Color(0xFF2563EB), size: 20),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  s,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.35),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
}
