import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RoadStatusScreen extends StatefulWidget {
  final bool isNe;
  const RoadStatusScreen({super.key, required this.isNe});

  @override
  State<RoadStatusScreen> createState() => _RoadStatusScreenState();
}

class _RoadStatusScreenState extends State<RoadStatusScreen> {
  String _statusFilter = 'ALL';

  final List<Map<String, dynamic>> _corridors = [
    {
      'id': 'RD-01',
      'name': 'Prithvi Highway (पृथ्वी राजमार्ग)',
      'section': 'Mugling – Malekhu Section (Ward 4)',
      'status': 'BLOCKED',
      'cause': 'ठूलो सुख्खा पहिरो (Massive Dry Landslide)',
      'clearanceEta': '२ घण्टा बाँकी (Est. 2 Hours)',
      'machinery': '२ वटा डोजर तथा प्रहरी टोली खटिएको',
      'trafficQueue': '३.५ कि.मि. जाम',
      'detour': 'हेटौंडा – कान्ति लोकपथ मार्ग प्रयोग गर्नुहोस्',
      'lastUpdated': '१० मिनेट अघि',
    },
    {
      'id': 'RD-02',
      'name': 'Narayanghat – Mugling Road (नारायणगढ–मुग्लिन)',
      'section': 'Seti Dobhan (सेती दोभान)',
      'status': 'ONE_WAY',
      'cause': 'लेदो र ढुङ्गा खसेको (Debris & Rockfall)',
      'clearanceEta': 'एकतर्फी सुचारु (One-way Active)',
      'machinery': '१ डोजर सफाइमा संलग्न',
      'trafficQueue': 'सामान्य सुस्त गति',
      'detour': 'अति आवश्यक भए मात्र यात्रा गर्नुहोला',
      'lastUpdated': '२५ मिनेट अघि',
    },
    {
      'id': 'RD-03',
      'name': 'B.P. Highway (बी.पी. राजमार्ग)',
      'section': 'Nepalthok – Dhulikhel (नेपालथोक)',
      'status': 'OPEN',
      'cause': 'कुनै अवरोध छैन (Clear Road)',
      'clearanceEta': 'पूर्ण सुचारु (Fully Operational)',
      'machinery': 'गस्ती टोली तैनाथ',
      'trafficQueue': 'सुचारु (Free Flow)',
      'detour': 'कुनै डाइभर्सन आवश्यक छैन',
      'lastUpdated': '१ घण्टा अघि',
    },
    {
      'id': 'RD-04',
      'name': 'Karnali Highway (कर्णाली राजमार्ग)',
      'section': 'Gaganekhola, Dailekh (गगनेखोला)',
      'status': 'BLOCKED',
      'cause': 'सडक भासिएको (Road Subsidence/Collapse)',
      'clearanceEta': 'कम्तीमा ६ घण्टा (Est. 6+ Hours)',
      'machinery': 'सडक डिभिजन इन्जिनियरिङ टोली खटिँदै',
      'trafficQueue': 'सवारी आवागमन पूर्ण ठप्प',
      'detour': 'बैकल्पिक पैदल/स्थानीय कच्ची बाटो',
      'lastUpdated': '४० मिनेट अघि',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'BLOCKED':
        return const Color(0xFFDC2626);
      case 'ONE_WAY':
        return const Color(0xFFD97706);
      case 'OPEN':
      default:
        return const Color(0xFF16A34A);
    }
  }

  String _getStatusText(String status, bool isNe) {
    switch (status) {
      case 'BLOCKED':
        return isNe ? 'पूर्ण अवरुद्ध (Blocked)' : 'BLOCKED';
      case 'ONE_WAY':
        return isNe ? 'एकतर्फी (One-Way)' : 'ONE-WAY';
      case 'OPEN':
      default:
        return isNe ? 'सुचारु (Open)' : 'OPERATIONAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;

    final filtered = _statusFilter == 'ALL'
        ? _corridors
        : _corridors.where((c) => c['status'] == _statusFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'राजमार्ग तथा सडक अवस्था' : 'Highway & Landslide Radar',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Traffic Police Hotline Banner
          _buildTrafficBanner(isNe),
          const SizedBox(height: 16),

          // 2. Filter Ribbon
          _buildFilterChips(isNe),
          const SizedBox(height: 16),

          // 3. Corridor Status Cards
          ...filtered.map((item) => _buildHighwayCard(item, isNe)),
        ],
      ),
    );
  }

  Widget _buildTrafficBanner(bool isNe) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.traffic_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNe ? 'नेपाल ट्राफिक प्रहरी कन्ट्रोल रुम' : 'Nepal Traffic Police Control',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  isNe ? 'सडक अवस्थाबारे जानकारी लिन १०३ मा कल गर्नुहोस्' : 'Dial 103 for live national highway inquiries',
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                ),
              ],
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => launchUrl(Uri(scheme: 'tel', path: '103')),
            child: const Text('१०३ कल', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isNe) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('ALL', isNe ? 'सबै सडकहरू' : 'All Highways'),
          const SizedBox(width: 8),
          _buildFilterChip('BLOCKED', isNe ? 'अवरुद्ध (Blocked)' : 'Blocked'),
          const SizedBox(width: 8),
          _buildFilterChip('ONE_WAY', isNe ? 'एकतर्फी (One-way)' : 'One-Way'),
          const SizedBox(width: 8),
          _buildFilterChip('OPEN', isNe ? 'खुला (Open)' : 'Clear'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String id, String label) {
    final sel = _statusFilter == id;
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: sel ? Colors.white : const Color(0xFF334155), fontSize: 11, fontWeight: FontWeight.bold)),
      selected: sel,
      selectedColor: const Color(0xFF0F172A),
      backgroundColor: Colors.white,
      onSelected: (_) => setState(() => _statusFilter = id),
    );
  }

  Widget _buildHighwayCard(Map<String, dynamic> data, bool isNe) {
    final Color statusColor = _getStatusColor(data['status']);
    final bool isBlocked = data['status'] == 'BLOCKED';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                    Text('${data['section']} • ${data['lastUpdated']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getStatusText(data['status'], isNe),
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Cause & Machinery Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isBlocked ? const Color(0xFFFEF2F2) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isBlocked ? const Color(0xFFFECACA) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.landslide_rounded, size: 16, color: statusColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'कारण: ${data['cause']}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 8),
                    Text(
                      'अनुमानित समय: ${data['clearanceEta']}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF334155), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.construction_rounded, size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data['machinery'],
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Detour Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.alt_route_rounded, size: 16, color: Color(0xFF2563EB)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'डाइभर्सन: ${data['detour']}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}