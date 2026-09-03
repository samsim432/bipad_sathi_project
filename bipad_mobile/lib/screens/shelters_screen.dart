import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SheltersScreen extends StatelessWidget {
  final bool isNe;
  const SheltersScreen({super.key, required this.isNe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNe ? 'सुरक्षित आश्रय स्थलहरू' : 'Evacuation Shelters'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildShelterCard('Dasharath Stadium Camp', 'Tripureshwor, Kathmandu', 1200, 320, '9841123456'),
          _buildShelterCard('Narayangarh Community Hall', 'Bharatpur-1, Chitwan', 500, 480, '9855123456'),
          _buildShelterCard('Janakpur Higher Secondary', 'Janakpurdham-4', 800, 150, '9845123456'),
        ],
      ),
    );
  }

  Widget _buildShelterCard(String name, String loc, int capacity, int occupied, String phone) {
    final available = capacity - occupied;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text(loc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: occupied / capacity,
                    backgroundColor: Colors.grey.shade200,
                    color: available < 50 ? Colors.red : Colors.green,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                Text('$available Free', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => launchUrl(Uri(scheme: 'tel', path: phone)),
                  icon: const Icon(Icons.call, size: 16),
                  label: Text('Call $phone'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}