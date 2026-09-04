import 'package:flutter/material.dart';

class BloodNetworkScreen extends StatefulWidget {
  final bool isNe;
  const BloodNetworkScreen({super.key, required this.isNe});

  @override
  State<BloodNetworkScreen> createState() => _BloodNetworkScreenState();
}

class _BloodNetworkScreenState extends State<BloodNetworkScreen> {
  String _selectedGroup = 'ALL';

  final List<Map<String, dynamic>> _bloodBanks = [
    {
      'name': 'Nepal Red Cross Central Blood Bank',
      'location': 'Soaltee Mode, Kathmandu',
      'phone': '01-4288485',
      'status': 'Open 24/7',
      'stock': {'A+': 'Available', 'O+': 'Low', 'B+': 'Available', 'AB-': 'Critical'}
    },
    {
      'name': 'Bhaktapur Red Cross Blood Bank',
      'location': 'Dudhpati, Bhaktapur',
      'phone': '01-6611661',
      'status': 'Open 24/7',
      'stock': {'O+': 'Available', 'A+': 'Available', 'B-': 'Critical'}
    },
    {
      'name': 'Pokhara Blood Transfusion Centre',
      'location': 'Ramghat, Pokhara',
      'phone': '061-521091',
      'status': 'Open 24/7',
      'stock': {'O+': 'Available', 'A+': 'Available', 'AB+': 'Available'}
    },
    {
      'name': 'Bharatpur Blood Bank (Red Cross)',
      'location': 'Hospital Road, Chitwan',
      'phone': '056-520199',
      'status': 'Open 24/7',
      'stock': {'B+': 'Available', 'O+': 'Critical', 'A+': 'Available'}
    }
  ];

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;
    final groups = ['ALL', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'रक्तदान तथा ब्लड बैंक' : 'Blood Emergency Network',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: groups.map((g) {
                  final isSel = _selectedGroup == g;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(g),
                      selected: isSel,
                      selectedColor: const Color(0xFFDC2626),
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : const Color(0xFF334155),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (_) => setState(() => _selectedGroup = g),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _bloodBanks.length,
              itemBuilder: (ctx, i) {
                final b = _bloodBanks[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.bloodtype_rounded, color: Color(0xFFDC2626), size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  b['name'],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                Text(
                                  b['location'],
                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              b['status'],
                              style: const TextStyle(color: Color(0xFF16A34A), fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Spacer(),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFDC2626),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.phone_rounded, size: 16),
                            label: Text(b['phone'], style: const TextStyle(fontSize: 12)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Dialing ${b['phone']}...')),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
