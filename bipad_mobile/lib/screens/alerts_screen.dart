import 'package:flutter/material.dart';

// Alias so both AlertsScreen and AlertsFeedScreen work seamlessly
typedef AlertsFeedScreen = AlertsScreen;

class AlertsScreen extends StatelessWidget {
  final bool isNe;
  const AlertsScreen({super.key, this.isNe = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'आपत्कालीन पूर्वसूचना तथा अलर्ट' : 'Early Warning Alerts',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAlertCard(
            title: isNe ? 'उच्च बाढी चेतावनी (Devghat Gauge)' : 'Severe Flood Warning (Devghat)',
            desc: isNe
                ? 'नारायणी नदीमा जलसतह खतराको रेखा पार गरेको छ। सुरक्षित स्थानमा रहनुहोला।'
                : 'Narayani river level has crossed danger thresholds. Move to safe high ground.',
            severity: 'CRITICAL',
            time: '१० मिनेट अघि',
            color: const Color(0xFFDC2626),
            icon: Icons.water_damage_rounded,
          ),
          const SizedBox(height: 12),
          _buildAlertCard(
            title: isNe ? 'पहिरो जोखिम (Prithvi Highway)' : 'Landslide Alert (Prithvi Highway)',
            desc: isNe
                ? 'मुग्लिन-मलेखु खण्डमा ठूलो पहिरोका कारण बाटो अवरुद्ध छ।'
                : 'Mugling-Malekhu highway section blocked due to massive landslide.',
            severity: 'HIGH',
            time: '२५ मिनेट अघि',
            color: const Color(0xFFEA580C),
            icon: Icons.landslide_rounded,
          ),
          const SizedBox(height: 12),
          _buildAlertCard(
            title: isNe ? 'मौसम पूर्वानुमान (Heavy Rainfall)' : 'Heavy Rainfall Advisory',
            desc: isNe
                ? 'बागमती र गण्डकी प्रदेशमा आगामी २४ घण्टा भारी वर्षाको सम्भावना।'
                : 'Heavy to very heavy rainfall expected across Bagmati & Gandaki provinces.',
            severity: 'ADVISORY',
            time: '१ घण्टा अघि',
            color: const Color(0xFF0284C7),
            icon: Icons.thunderstorm_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard({
    required String title,
    required String desc,
    required String severity,
    required String time,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                      child: Text(severity, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                    Text(time, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                  ],
                ),
                const SizedBox(height: 6),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}