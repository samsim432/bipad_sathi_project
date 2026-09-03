import 'package:flutter/material.dart';

class AlertsFeedScreen extends StatelessWidget {
  final bool isNe;
  const AlertsFeedScreen({super.key, required this.isNe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNe ? 'विपद् पूर्वसूचना' : 'Active Alerts & Bulletins'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAlertCard(
            Icons.water_drop,
            isNe ? 'नारायणी नदी: उच्च खतरा तह पार' : 'Narayani River: Danger Level Exceeded',
            isNe ? 'चितवन, नवलपरासी • १० मिनेट अघि' : 'Chitwan, Nawalparasi • 10m ago',
            isNe
                ? 'बाढी पूर्वानुमान महाशाखा अनुसार जलसतह १०.५ मिटर नाघेको छ। तटीय क्षेत्र तुरुन्त खाली गर्नुहोस्।'
                : 'Department of Hydrology reports water level > 10.5m. Evacuate low-lying riverbanks immediately.',
            Colors.red,
          ),
          _buildAlertCard(
            Icons.landslide,
            isNe ? 'पृथ्वी राजमार्ग: लेदो सहितको पहिरो' : 'Prithvi Highway: Debris Flow',
            isNe ? 'धादिङ, गजुरी • ३५ मिनेट अघि' : 'Dhading, Gajuri • 35m ago',
            isNe
                ? 'पहिरोका कारण दुईतर्फी सवारी आवागमन ठप्प भएको छ। वैकल्पिक मार्ग प्रयोग गर्नुहोस्।'
                : 'Both-way traffic halted due to massive debris flow. Road clearance under progress.',
            Colors.orange,
          ),
          _buildAlertCard(
            Icons.storm,
            isNe ? 'भारी वर्षा तथा हुरीबतास चेतावनी' : 'Heavy Rainfall & Storm Watch',
            isNe ? 'कोशी र मधेश प्रदेश • २ घण्टा अघि' : 'Koshi & Madhesh Province • 2h ago',
            isNe
                ? 'आगामी २४ घण्टामा भारी वर्षाको सम्भावना रहेकोले सतर्क रहन अनुरोध गरिन्छ।'
                : 'High precipitation expected over the next 24 hours. Keep emergency kit ready.',
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(IconData icon, String title, String meta, String desc, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(meta, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(desc, style: const TextStyle(fontSize: 13, height: 1.35)),
          ],
        ),
      ),
    );
  }
}