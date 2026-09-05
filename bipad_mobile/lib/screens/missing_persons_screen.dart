import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MissingPersonsScreen extends StatefulWidget {
  final bool isNe;
  const MissingPersonsScreen({super.key, required this.isNe});

  @override
  State<MissingPersonsScreen> createState() => _MissingPersonsScreenState();
}

class _MissingPersonsScreenState extends State<MissingPersonsScreen> {
  String _activeFilter = 'ALL';

  final List<Map<String, dynamic>> _records = [
    {
      'id': 'MIS-801',
      'name': 'Aayush Adhikari',
      'age': 11,
      'gender': 'Male (बालक)',
      'status': 'MISSING',
      'lastSeenLocation': 'Near Malekhu Bridge, Dhading',
      'lastSeenTime': '६ घण्टा अघि (Landslide area)',
      'clothing': 'नीलो हुडी र कालो ट्रयाक (Blue hoodie, black tracks)',
      'contactName': 'Bishnu Adhikari (Father)',
      'contactPhone': '9841123456',
      'imageUrl': 'https://images.unsplash.com/photo-1543610892-0b1f7e6d8ac1?w=400&q=80',
    },
    {
      'id': 'MIS-802',
      'name': 'Devaki Sharma',
      'age': 68,
      'gender': 'Female (ज्येष्ठ नागरिक)',
      'status': 'SIGHTED',
      'lastSeenLocation': 'Bharatpur Community Shelter, Ward 10',
      'lastSeenTime': '२ घण्टा अघि',
      'clothing': 'रातो साडी, कानमा सुनको कुण्डल',
      'contactName': 'Red Cross Camp Coordinator',
      'contactPhone': '056-520100',
      'imageUrl': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&q=80',
    },
    {
      'id': 'MIS-803',
      'name': 'Pasang Dorje Sherpa',
      'age': 34,
      'gender': 'Male (पुरुष)',
      'status': 'REUNITED',
      'lastSeenLocation': 'Melamchi Bazar, Sindhupalchok',
      'lastSeenTime': 'हिजो साँझ',
      'clothing': 'कालो ज्याकेट',
      'contactName': 'Family Reunited (सम्पर्क स्थापित)',
      'contactPhone': '9801000000',
      'imageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'MISSING':
        return const Color(0xFFDC2626);
      case 'SIGHTED':
        return const Color(0xFF2563EB);
      case 'REUNITED':
      default:
        return const Color(0xFF16A34A);
    }
  }

  String _getStatusLabel(String status, bool isNe) {
    switch (status) {
      case 'MISSING':
        return isNe ? 'हराइरहेको (Missing)' : 'MISSING';
      case 'SIGHTED':
        return isNe ? 'आश्रयमा फेला (In Shelter)' : 'SIGHTED';
      case 'REUNITED':
      default:
        return isNe ? 'पुनर्मिलन भएको (Reunited)' : 'REUNITED';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;

    final filtered = _activeFilter == 'ALL'
        ? _records
        : _records.where((r) => r['status'] == _activeFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'खोजतलास तथा पुनर्मिलन' : 'Missing Persons & Family Tracing',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Official Tracing Hotline Card
          _buildPoliceTracingBanner(isNe),
          const SizedBox(height: 16),

          // 2. Filter Matrix
          _buildFilterTabs(isNe),
          const SizedBox(height: 16),

          // 3. Person Cards
          ...filtered.map((item) => _buildPersonCard(item, isNe)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: Text(
          isNe ? 'हराएको व्यक्ति दर्ता' : 'Report Missing',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () => _showReportMissingModal(isNe),
      ),
    );
  }

  Widget _buildPoliceTracingBanner(bool isNe) {
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
              color: const Color(0xFFDC2626),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_search_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNe ? 'बालबालिका तथा व्यक्ति खोजतलास (१०४)' : 'Emergency Missing Hotline (104)',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  isNe ? 'नेपाल प्रहरी तथा रेडक्रस खोजतलास सेवा' : 'Nepal Police & Red Cross Tracing Bureau',
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                ),
              ],
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => launchUrl(Uri(scheme: 'tel', path: '104')),
            child: const Text('१०४ कल', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
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
          _buildFilterChip('ALL', isNe ? 'सबै सूची' : 'All Cases'),
          const SizedBox(width: 8),
          _buildFilterChip('MISSING', isNe ? 'हराइरहेका (Missing)' : 'Missing'),
          const SizedBox(width: 8),
          _buildFilterChip('SIGHTED', isNe ? 'फेला परेका (In Shelter)' : 'Sighted'),
          const SizedBox(width: 8),
          _buildFilterChip('REUNITED', isNe ? 'पुनर्मिलन (Reunited)' : 'Reunited'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String id, String label) {
    final sel = _activeFilter == id;
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: sel ? Colors.white : const Color(0xFF334155), fontSize: 11, fontWeight: FontWeight.bold)),
      selected: sel,
      selectedColor: const Color(0xFF0F172A),
      backgroundColor: Colors.white,
      onSelected: (_) => setState(() => _activeFilter = id),
    );
  }

  Widget _buildPersonCard(Map<String, dynamic> data, bool isNe) {
    final Color statusColor = _getStatusColor(data['status']);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  data['imageUrl'],
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 70,
                    height: 70,
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(Icons.person, color: Color(0xFF94A3B8), size: 36),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _getStatusLabel(data['status'], isNe),
                            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'उमेर: ${data['age']} वर्ष • ${data['gender']}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'स्थान: ${data['lastSeenLocation']}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.checkroom_rounded, size: 14, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'पहिरन: ${data['clothing']}',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'सम्पर्क: ${data['contactName']}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.call_rounded, size: 14),
                label: Text(isNe ? 'सम्पर्क' : 'Call', style: const TextStyle(fontSize: 11)),
                onPressed: () => launchUrl(Uri(scheme: 'tel', path: data['contactPhone'])),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReportMissingModal(bool isNe) {
    final nameCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isNe ? 'हराएको व्यक्ति खोजतलास रिपोर्ट' : 'Report Missing Person',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: isNe ? 'पूरा नाम (Full Name)' : 'Full Name',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isNe ? 'उमेर (Age)' : 'Age',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: locCtrl,
                decoration: InputDecoration(
                  labelText: isNe ? 'अन्तिम पटक देखिएको स्थान (Last Location)' : 'Last Seen Location',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: isNe ? 'सम्पर्क फोन नम्बर (Contact Phone)' : 'Contact Phone Number',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty) {
                    setState(() {
                      _records.insert(0, {
                        'id': 'MIS-${DateTime.now().millisecondsSinceEpoch % 1000}',
                        'name': nameCtrl.text.trim(),
                        'age': int.tryParse(ageCtrl.text.trim()) ?? 0,
                        'gender': 'Unknown',
                        'status': 'MISSING',
                        'lastSeenLocation': locCtrl.text.trim(),
                        'lastSeenTime': 'भर्खरै दर्ता (Just now)',
                        'clothing': 'विवरण उपलब्ध छैन',
                        'contactName': 'Reporter',
                        'contactPhone': phoneCtrl.text.trim(),
                        'imageUrl': '',
                      });
                    });
                  }
                  Navigator.pop(ctx);
                },
                child: Text(isNe ? 'सूचना दर्ता गर्नुहोस्' : 'Submit Search Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}