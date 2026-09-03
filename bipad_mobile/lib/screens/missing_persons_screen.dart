import 'package:flutter/material.dart';

class MissingPersonsScreen extends StatefulWidget {
  final bool isNe;
  const MissingPersonsScreen({super.key, required this.isNe});

  @override
  State<MissingPersonsScreen> createState() => _MissingPersonsScreenState();
}

class _MissingPersonsScreenState extends State<MissingPersonsScreen> {
  final List<Map<String, String>> _mockList = [
    {
      'name': 'Ramesh Thapa (रमेश थापा)',
      'age': '28',
      'lastSeen': 'Sindhupalchok, Melamchi (बाढी क्षेत्र)',
      'status': 'MISSING',
      'contact': '9841000000',
    },
    {
      'name': 'Sunita Shrestha (सुनिता श्रेष्ठ)',
      'age': '14',
      'lastSeen': 'Chitwan, Narayangarh',
      'status': 'REUNITED',
      'contact': '9851000000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;

    return Scaffold(
      appBar: AppBar(
        title: Text(isNe ? 'हराएको / भेटिएको' : 'Missing Persons Registry'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockList.length,
        itemBuilder: (ctx, i) {
          final item = _mockList[i];
          final isMissing = item['status'] == 'MISSING';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: isMissing ? Colors.red.shade100 : Colors.green.shade100,
                child: Icon(Icons.person, color: isMissing ? Colors.red : Colors.green),
              ),
              title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text(
                '${isNe ? 'उमेर' : 'Age'}: ${item['age']} • ${item['lastSeen']}\n${isNe ? 'सम्पर्क' : 'Phone'}: ${item['contact']}',
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isMissing ? Colors.red.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isMissing ? (isNe ? 'खोजतलास जारी' : 'MISSING') : (isNe ? 'भेटियो' : 'FOUND'),
                  style: TextStyle(
                    color: isMissing ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: Text(isNe ? 'हराएको सूचना थप्नुहोस्' : 'Report Person', style: const TextStyle(color: Colors.white)),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isNe ? 'नयाँ रिपोर्टिङ फारम खुल्दैछ...' : 'Opening missing report form...'),
            ),
          );
        },
      ),
    );
  }
}