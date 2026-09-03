import 'package:flutter/material.dart';

class RoadStatusScreen extends StatelessWidget {
  final bool isNe;
  const RoadStatusScreen({super.key, required this.isNe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNe ? 'सडक तथा राजमार्ग अवस्था' : 'Road & Highway Status'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildRoadTile(
            'Prithvi Highway (Mugling - Malekhu)',
            isNe ? 'पहिरोले पूर्ण अवरुद्ध' : 'BLOCKED (Landslide)',
            Colors.red,
            isNe ? 'डोजर परिचालन गरिएको छ, दिउँसो ४ बजेसम्म खुल्ने अनुमान' : 'Excavator operating, estimated open by 4:00 PM',
          ),
          _buildRoadTile(
            'B.P. Highway (Kavre - Sindhuli)',
            isNe ? 'एकतर्फी सञ्चालन' : 'ONE-WAY TRAFFIC',
            Colors.orange,
            isNe ? 'बाढीले सडक कटान गरेकाले साना सवारी मात्र' : 'Light vehicles only due to river cut',
          ),
          _buildRoadTile(
            'Tribhuvan Highway (Naubise - Hetauda)',
            isNe ? 'सुचारु' : 'OPEN / CLEAR',
            Colors.green,
            isNe ? 'सडक पूर्ण रूपमा खुला रहेको छ' : 'Clear for all heavy & passenger vehicles',
          ),
        ],
      ),
    );
  }

  Widget _buildRoadTile(String highway, String status, Color color, String notes) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(highway, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
                )
              ],
            ),
            const SizedBox(height: 6),
            Text(notes, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}