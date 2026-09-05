import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../hazard_feed_manager.dart';

class RiverAlertsScreen extends StatefulWidget {
  final bool isNe;
  const RiverAlertsScreen({super.key, required this.isNe});

  @override
  State<RiverAlertsScreen> createState() => _RiverAlertsScreenState();
}

class _RiverAlertsScreenState extends State<RiverAlertsScreen> {
  String _selectedBasin = 'ALL';

  final List<Map<String, dynamic>> _basins = [
    {
      'name': 'Narayani Basin (नारायणी)',
      'station': 'Devghat, Chitwan',
      'river': 'Narayani River',
      'currentLevel': 9.42,
      'warningLevel': 7.30,
      'dangerLevel': 9.00,
      'trend': 'RISING',
      'rainfall24h': 142.5,
      'status': 'DANGER',
      'lastUpdated': '5 mins ago',
      'lat': 27.7058,
      'lng': 84.4239,
    },
    {
      'name': 'Bagmati Basin (बागमती)',
      'station': 'Karmaiya, Sarlahi/Rautahat',
      'river': 'Bagmati River',
      'currentLevel': 6.85,
      'warningLevel': 6.00,
      'dangerLevel': 7.00,
      'trend': 'STEADY',
      'rainfall24h': 88.0,
      'status': 'WARNING',
      'lastUpdated': '12 mins ago',
      'lat': 27.1432,
      'lng': 85.4984,
    },
    {
      'name': 'Koshi Basin (कोशी)',
      'station': 'Chatara, Sunsari',
      'river': 'Sapta Koshi River',
      'currentLevel': 4.60,
      'warningLevel': 6.00,
      'dangerLevel': 7.50,
      'trend': 'RECEDING',
      'rainfall24h': 32.0,
      'status': 'NORMAL',
      'lastUpdated': '20 mins ago',
      'lat': 26.8667,
      'lng': 87.1500,
    },
    {
      'name': 'Karnali Basin (कर्णाली)',
      'station': 'Chisapani, Kailali',
      'river': 'Karnali River',
      'currentLevel': 8.10,
      'warningLevel': 10.00,
      'dangerLevel': 11.00,
      'trend': 'NORMAL',
      'rainfall24h': 15.0,
      'status': 'NORMAL',
      'lastUpdated': '30 mins ago',
      'lat': 28.6439,
      'lng': 81.2828,
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'DANGER':
        return const Color(0xFFDC2626);
      case 'WARNING':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF16A34A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;

    final filteredBasins = _selectedBasin == 'ALL'
        ? _basins
        : _basins.where((b) => b['status'] == _selectedBasin).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'नदी जलसतह तथा बाढी पूर्वानुमान' : 'River Water Level & Flood Radar',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. National Flood Summary Banner
          _buildSummaryBanner(isNe),
          const SizedBox(height: 16),

          // 2. Filter Tabs
          _buildFilterTabs(isNe),
          const SizedBox(height: 16),

          // 3. Station River Gauges
          ...filteredBasins.map((b) => _buildGaugeCard(b, isNe)),
        ],
      ),
    );
  }

  Widget _buildSummaryBanner(bool isNe) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFDC2626),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNe ? 'जल तथा मौसम विज्ञान विभाग (DHM) प्रत्यक्ष सूचना' : 'DHM Live Flood Telemetry',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF991B1B)),
                ),
                const SizedBox(height: 4),
                Text(
                  isNe
                      ? 'नारायणी नदी देवघाट मापन केन्द्रमा जलसतह खतराको तह (९.० मिटर) भन्दा माथि पुगेको छ। तल्लो तटीय क्षेत्रमा तुरुन्त सतर्कता अपनाउनुहोला।'
                      : 'Narayani River at Devghat has breached the danger threshold (9.0m). Low-lying downstream settlements must remain on high alert.',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF7F1D1D), height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(bool isNe) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('ALL', isNe ? 'सबै नदीहरू' : 'All Basins'),
          const SizedBox(width: 8),
          _buildChip('DANGER', isNe ? 'खतरा तह पार (Danger)' : 'Danger'),
          const SizedBox(width: 8),
          _buildChip('WARNING', isNe ? 'सतर्कता तह (Warning)' : 'Warning'),
          const SizedBox(width: 8),
          _buildChip('NORMAL', isNe ? 'सामान्य (Normal)' : 'Normal'),
        ],
      ),
    );
  }

  Widget _buildChip(String id, String label) {
    final sel = _selectedBasin == id;
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: sel ? Colors.white : const Color(0xFF334155), fontSize: 11, fontWeight: FontWeight.bold)),
      selected: sel,
      selectedColor: const Color(0xFF0F172A),
      backgroundColor: Colors.white,
      onSelected: (_) => setState(() => _selectedBasin = id),
    );
  }

  Widget _buildGaugeCard(Map<String, dynamic> data, bool isNe) {
    final Color statusColor = _getStatusColor(data['status']);
    final double cur = data['currentLevel'];
    final double warn = data['warningLevel'];
    final double dang = data['dangerLevel'];
    final double progress = (cur / (dang * 1.2)).clamp(0.0, 1.0);

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                  Text('${data['station']} • ${data['lastUpdated']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  data['status'],
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Gauge Level Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${cur.toStringAsFixed(2)} m',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                    Text(
                      isNe ? 'वर्तमान जलसतह (Current Level)' : 'Current Gauge Height',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      data['trend'] == 'RISING' ? Icons.trending_up_rounded : Icons.trending_flat_rounded,
                      color: data['trend'] == 'RISING' ? Colors.red : Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '२४ घण्टा वर्षा: ${data['rainfall24h']} mm',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Visual Progress Level Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          const SizedBox(height: 8),

          // Level Threshold Markers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('सामान्य (<${warn}m)', style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w600)),
              Text('सतर्कता (${warn}m)', style: const TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w600)),
              Text('खतरा (${dang}m+)', style: const TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.w600)),
            ],
          ),
          const Divider(height: 20),

          // Emergency Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isNe ? 'आपत्कालीन हटलाइन: ११४९' : 'Flood Toll Free: 1149',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.phone_in_talk_rounded, size: 14),
                label: Text(isNe ? 'कल गर्नुहोस्' : 'Call 1149', style: const TextStyle(fontSize: 11)),
                onPressed: () => launchUrl(Uri(scheme: 'tel', path: '1149')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}