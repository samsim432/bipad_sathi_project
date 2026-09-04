import 'package:flutter/material.dart';

class RiverAlertsScreen extends StatelessWidget {
  final bool isNe;
  const RiverAlertsScreen({super.key, required this.isNe});

  final List<Map<String, dynamic>> _basins = const [
    {
      'river': 'Narayani River (नारायणी नदी)',
      'station': 'Devghat Gauge Station',
      'level': '8.4m',
      'danger_level': '7.3m',
      'status': 'DANGER',
      'trend': 'Rising (बढ्दो)',
      'color': Color(0xFFDC2626)
    },
    {
      'river': 'Bagmati River (बागमती नदी)',
      'station': 'Karmaiya Station, Sarlahi',
      'level': '6.1m',
      'danger_level': '5.8m',
      'status': 'WARNING',
      'trend': 'Rising (बढ्दो)',
      'color': Color(0xFFEA580C)
    },
    {
      'river': 'Koshi River (सप्तकोशी नदी)',
      'station': 'Chatara Gauge Station',
      'level': '5.2m',
      'danger_level': '6.0m',
      'status': 'SAFE',
      'trend': 'Stable (स्थिर)',
      'color': Color(0xFF16A34A)
    },
    {
      'river': 'Karnali River (कर्णाली नदी)',
      'station': 'Chisapani Station',
      'level': '8.8m',
      'danger_level': '10.0m',
      'status': 'SAFE',
      'trend': 'Falling (घट्दो)',
      'color': Color(0xFF16A34A)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'नदी जलसतह तथा बाढी चेतावनी' : 'River Basin Flood Radar',
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
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.water_rounded, color: Color(0xFF2563EB), size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isNe
                        ? 'जल तथा मौसम विज्ञान विभाग (DHM) को प्रत्यक्ष जलमापन प्रणालीबाट प्राप्त तथ्यांक।'
                        : 'Live telemetry sourced from Dept. of Hydrology & Meteorology (DHM Nepal).',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1E40AF), height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._basins.map((b) => _buildBasinCard(b, isNe)),
        ],
      ),
    );
  }

  Widget _buildBasinCard(Map<String, dynamic> b, bool isNe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Expanded(
                child: Text(
                  b['river'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (b['color'] as Color).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  b['status'],
                  style: TextStyle(color: b['color'], fontSize: 11, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(height: 4),
          Text(b['station'], style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Level', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  Text(
                    b['level'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: b['color']),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Danger Threshold', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  Text(
                    b['danger_level'],
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Trend', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  Text(
                    b['trend'],
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
