import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectoryScreen extends StatelessWidget {
  final bool isNe;
  const DirectoryScreen({super.key, required this.isNe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNe ? 'आपत्कालीन सम्पर्क निर्देशिका' : 'Emergency Contacts (Nepal)'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildContact('Nepal Police (नेपाल प्रहरी)', '100', Colors.blue),
          _buildContact('Fire Brigade (दमकल)', '101', Colors.red),
          _buildContact('Ambulance (एम्बुलेन्स सेवा)', '102', Colors.green),
          _buildContact('Armed Police Force (सशस्त्र प्रहरी बल)', '1114', Colors.deepOrange),
          _buildContact('Disaster Information (विपद् सूचना केन्द्र)', '1155', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildContact(String title, String num, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(Icons.phone, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(num, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color),
          onPressed: () => launchUrl(Uri(scheme: 'tel', path: num)),
          child: const Text('CALL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}