import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectoryScreen extends StatefulWidget {
  final bool isNe;
  const DirectoryScreen({super.key, required this.isNe});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'NATIONAL';

  final List<Map<String, dynamic>> _quickHotlines = [
    {'title': 'नेपाल प्रहरी (Police)', 'titleEn': 'Nepal Police', 'number': '100', 'color': Color(0xFF1E3A8A), 'icon': Icons.local_police_rounded},
    {'title': 'दमकल (Fire Brigade)', 'titleEn': 'Fire Service', 'number': '101', 'color': Color(0xFFDC2626), 'icon': Icons.fire_extinguisher_rounded},
    {'title': 'एम्बुलेन्स (Ambulance)', 'titleEn': 'Ambulance Call', 'number': '102', 'color': Color(0xFF16A34A), 'icon': Icons.medical_services_rounded},
    {'title': 'ट्राफिक कन्ट्रोल (Traffic)', 'titleEn': 'Traffic Police', 'number': '103', 'color': Color(0xFFD97706), 'icon': Icons.traffic_rounded},
    {'title': 'बालबालिका खोजतलास', 'titleEn': 'Child Tracing', 'number': '104', 'color': Color(0xFF7C3AED), 'icon': Icons.escalator_warning_rounded},
    {'title': 'बाढी सूचना (DHM Flood)', 'titleEn': 'DHM Flood Alert', 'number': '1149', 'color': Color(0xFF0284C7), 'icon': Icons.water_damage_rounded},
  ];

  final List<Map<String, dynamic>> _hqAgencies = [
    {
      'name': 'Nepal Army Disaster Management Directorate',
      'nameNe': 'नेपाली सेना विपद् व्यवस्थापन निर्देशनालय',
      'location': 'Bhadrakali, Kathmandu',
      'phone': '01-4244059',
      'type': 'ARMY',
      'badge': '24/7 Deployment',
    },
    {
      'name': 'Armed Police Force (APF) Disaster Response Command',
      'nameNe': 'सशस्त्र प्रहरी बल विपद् व्यवस्थापन महाशाखा',
      'location': 'Kurintar / Halchowk',
      'phone': '01-5249005',
      'type': 'APF',
      'badge': 'Deep Water & Alpine Rescue',
    },
    {
      'name': 'Nepal Red Cross Society (NRCS) Emergency Center',
      'nameNe': 'नेपाल रेडक्रस सोसाइटी केन्द्रीय कार्यालय',
      'location': 'Red Cross Marg, Kalimati',
      'phone': '01-4270650',
      'type': 'REDCROSS',
      'badge': 'Blood & First Aid',
    },
    {
      'name': 'National Emergency Operation Centre (NEOC / MoHA)',
      'nameNe': 'राष्ट्रिय आपत्कालीन कार्यसञ्चालन केन्द्र (गृह मन्त्रालय)',
      'location': 'Singha Durbar, Kathmandu',
      'phone': '01-4200024',
      'type': 'GOV',
      'badge': 'National Command',
    },
  ];

  final List<Map<String, dynamic>> _districtUnits = [
    {
      'district': 'Kathmandu (काठमाडौं)',
      'units': [
        {'title': 'District Emergency Operation Center (DEOC)', 'phone': '01-4241510', 'type': 'DEOC'},
        {'title': 'Bir Hospital Emergency Room', 'phone': '01-4221119', 'type': 'HOSPITAL'},
        {'title': 'TU Teaching Hospital (TUTH)', 'phone': '01-4412303', 'type': 'HOSPITAL'},
      ]
    },
    {
      'district': 'Chitwan (चितवन)',
      'units': [
        {'title': 'District Police Office Chitwan', 'phone': '056-520155', 'type': 'POLICE'},
        {'title': 'Bharatpur Hospital Emergency', 'phone': '056-524101', 'type': 'HOSPITAL'},
        {'title': 'Red Cross Ambulance Service Chitwan', 'phone': '056-520333', 'type': 'AMBULANCE'},
      ]
    },
    {
      'district': 'Dhading (धादिङ)',
      'units': [
        {'title': 'Highway Rescue Unit (Mugling-Gajuri)', 'phone': '010-402199', 'type': 'RESCUE'},
        {'title': 'Dhading District Hospital', 'phone': '010-520111', 'type': 'HOSPITAL'},
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
          isNe ? 'आपत्कालीन सम्पर्क निर्देशिका' : 'Emergency Contacts Directory',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Quick Emergency Dial Grid (100, 101, 102, 103, 104, 1149)
          Text(
            isNe ? 'राष्ट्रिय आकस्मिक हटलाइनहरू' : 'National Emergency Hotlines',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 10),
          _buildQuickHotlinesGrid(isNe),
          const SizedBox(height: 20),

          // 2. Search & Category Filter
          _buildSearchBox(isNe),
          const SizedBox(height: 12),
          _buildCategoryTabs(isNe),
          const SizedBox(height: 16),

          // 3. Render Content Based on Category
          if (_selectedCategory == 'NATIONAL' || _selectedCategory == 'ALL') ...[
            Text(
              isNe ? 'केन्द्रीय सुरक्षा तथा विपद् उद्धार कमान्ड' : 'Headquarters Search & Rescue Commands',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 8),
            ..._hqAgencies.map((agency) => _buildAgencyCard(agency, isNe)),
            const SizedBox(height: 16),
          ],

          if (_selectedCategory == 'DISTRICT' || _selectedCategory == 'ALL') ...[
            Text(
              isNe ? 'जिल्लास्तरीय उद्धार तथा अस्पतालहरू' : 'District Rescue Units & Hospitals',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 8),
            ..._districtUnits.map((dist) => _buildDistrictSection(dist, isNe)),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickHotlinesGrid(bool isNe) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _quickHotlines.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, idx) {
        final item = _quickHotlines[idx];
        final Color color = item['color'];

        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => launchUrl(Uri(scheme: 'tel', path: item['number'])),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: color.withOpacity(0.12),
                    child: Icon(item['icon'], color: color, size: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['number'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
                  ),
                  Text(
                    isNe ? item['title'] : item['titleEn'],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBox(bool isNe) {
    return TextField(
      onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
      decoration: InputDecoration(
        hintText: isNe ? 'जिल्ला, अस्पताल वा निकाय खोज्नुहोस्...' : 'Search by district, hospital, or agency...',
        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
        prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF64748B)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      ),
    );
  }

  Widget _buildCategoryTabs(bool isNe) {
    return Row(
      children: [
        _buildTabPill('NATIONAL', isNe ? 'केन्द्रीय कमान्ड' : 'National HQ'),
        const SizedBox(width: 8),
        _buildTabPill('DISTRICT', isNe ? 'जिल्ला र अस्पताल' : 'Districts'),
        const SizedBox(width: 8),
        _buildTabPill('ALL', isNe ? 'सबै सूची' : 'All Contacts'),
      ],
    );
  }

  Widget _buildTabPill(String id, String label) {
    final sel = _selectedCategory == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategory = id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: sel ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: sel ? Colors.transparent : const Color(0xFFE2E8F0)),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: sel ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgencyCard(Map<String, dynamic> agency, bool isNe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shield_rounded, color: Color(0xFF1E293B), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNe ? agency['nameNe'] : agency['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                ),
                Text('${agency['location']} • ${agency['badge']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.call_rounded, size: 14),
            label: Text(isNe ? 'कल' : 'Call', style: const TextStyle(fontSize: 11)),
            onPressed: () => launchUrl(Uri(scheme: 'tel', path: agency['phone'])),
          ),
        ],
      ),
    );
  }

  Widget _buildDistrictSection(Map<String, dynamic> dist, bool isNe) {
    final units = dist['units'] as List;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(dist['district'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        children: units.map((u) {
          return ListTile(
            dense: true,
            leading: Icon(
              u['type'] == 'HOSPITAL' ? Icons.local_hospital_rounded : Icons.phone_in_talk_rounded,
              size: 18,
              color: const Color(0xFF2563EB),
            ),
            title: Text(u['title'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            subtitle: Text(u['phone'], style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            trailing: IconButton(
              icon: const Icon(Icons.call_rounded, color: Color(0xFF16A34A), size: 18),
              onPressed: () => launchUrl(Uri(scheme: 'tel', path: u['phone'])),
            ),
          );
        }).toList(),
      ),
    );
  }
}