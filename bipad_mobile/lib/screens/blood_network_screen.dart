import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodNetworkScreen extends StatefulWidget {
  final bool isNe;
  const BloodNetworkScreen({super.key, required this.isNe});

  @override
  State<BloodNetworkScreen> createState() => _BloodNetworkScreenState();
}

class _BloodNetworkScreenState extends State<BloodNetworkScreen> {
  String _selectedGroup = 'ALL';
  String _activeTab = 'BANKS'; // 'BANKS' or 'DONORS'

  final List<String> _bloodGroups = ['ALL', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  final List<Map<String, dynamic>> _bloodBanks = [
    {
      'name': 'Nepal Red Cross Central Blood Transfusion Service',
      'nameNe': 'केन्द्रीय रक्तसञ्चार सेवा (नेपाल रेडक्रस)',
      'location': 'Soaltee Mode, Kalimati, Kathmandu',
      'phone': '01-4288485',
      'isOpen247': true,
      'stock': {'A+': 14, 'A-': 2, 'B+': 18, 'B-': 3, 'O+': 22, 'O-': 1, 'AB+': 8, 'AB-': 0},
      'verified': true,
    },
    {
      'name': 'Tribhuvan University Teaching Hospital (TUTH) Blood Bank',
      'nameNe': 'त्रिवि शिक्षण अस्पताल रक्त बैंक',
      'location': 'Maharajgunj, Kathmandu',
      'phone': '01-4412303',
      'isOpen247': true,
      'stock': {'A+': 9, 'A-': 1, 'B+': 12, 'B-': 0, 'O+': 15, 'O-': 2, 'AB+': 4, 'AB-': 1},
      'verified': true,
    },
    {
      'name': 'Nepal Red Cross Society Blood Bank, Chitwan',
      'nameNe': 'रेडक्रस रक्त बैंक, चितवन',
      'location': 'Bharatpur, Chitwan',
      'phone': '056-520333',
      'isOpen247': true,
      'stock': {'A+': 6, 'A-': 0, 'B+': 10, 'B-': 1, 'O+': 8, 'O-': 0, 'AB+': 3, 'AB-': 0},
      'verified': true,
    },
  ];

  final List<Map<String, dynamic>> _volunteerDonors = [
    {
      'name': 'Sunil Shrestha',
      'bloodGroup': 'O-',
      'location': 'Koteshwor, Kathmandu',
      'phone': '9841000000',
      'lastDonated': '4 months ago',
      'status': 'AVAILABLE',
    },
    {
      'name': 'Pooja Thapa',
      'bloodGroup': 'A+',
      'location': 'Patan, Lalitpur',
      'phone': '9851000000',
      'lastDonated': '6 months ago',
      'status': 'AVAILABLE',
    },
    {
      'name': 'Bikram Gurung',
      'bloodGroup': 'B-',
      'location': 'Pokhara-8, Kaski',
      'phone': '9803000000',
      'lastDonated': '2 months ago',
      'status': 'AVAILABLE',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'रक्तदान तथा ब्लड बैंक' : 'Blood Bank & Donor Network',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Emergency Blood Request Alert Card
          _buildEmergencyRequestCard(isNe),
          const SizedBox(height: 16),

          // 2. Blood Group Pills
          _buildBloodGroupFilter(),
          const SizedBox(height: 16),

          // 3. Tab Bar (Blood Banks vs Volunteer Donors)
          _buildTabs(isNe),
          const SizedBox(height: 16),

          // 4. Content List
          if (_activeTab == 'BANKS')
            ..._bloodBanks.map((b) => _buildBankCard(b, isNe))
          else
            ..._volunteerDonors
                .where((d) => _selectedGroup == 'ALL' || d['bloodGroup'] == _selectedGroup)
                .map((d) => _buildDonorCard(d, isNe)),
        ],
      ),
    );
  }

  Widget _buildEmergencyRequestCard(bool isNe) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFDC2626),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.bloodtype_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNe ? 'आकस्मिक रगत माग (Broadcast Need)' : 'Broadcast Emergency Blood Need',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  isNe ? 'नजिकका स्वयंसेवक रक्तदाताहरूलाई सूचना पठाउनुहोस्' : 'Send urgent notification to local donors',
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
            onPressed: () => _showRequestDialog(isNe),
            child: Text(isNe ? 'माग पठाउनुहोस्' : 'Post Need', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodGroupFilter() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _bloodGroups.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final grp = _bloodGroups[index];
          final sel = _selectedGroup == grp;
          return ChoiceChip(
            label: Text(grp, style: TextStyle(color: sel ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 12)),
            selected: sel,
            selectedColor: const Color(0xFFDC2626),
            backgroundColor: Colors.white,
            onSelected: (_) => setState(() => _selectedGroup = grp),
          );
        },
      ),
    );
  }

  Widget _buildTabs(bool isNe) {
    return Row(
      children: [
        _buildTabBtn('BANKS', isNe ? 'ब्लड बैंक स्टक (Inventories)' : 'Blood Banks'),
        const SizedBox(width: 8),
        _buildTabBtn('DONORS', isNe ? 'स्वयंसेवक रक्तदाता (Donors)' : 'Donors List'),
      ],
    );
  }

  Widget _buildTabBtn(String id, String label) {
    final sel = _activeTab == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: sel ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: sel ? Colors.transparent : const Color(0xFFE2E8F0)),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: sel ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankCard(Map<String, dynamic> bank, bool isNe) {
    final stock = bank['stock'] as Map<String, int>;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isNe ? bank['nameNe'] : bank['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                    ),
                    Text(bank['location'], style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              IconButton.filledTonal(
                style: IconButton.styleFrom(backgroundColor: const Color(0xFFDCFCE7)),
                icon: const Icon(Icons.call_rounded, color: Color(0xFF16A34A), size: 18),
                onPressed: () => launchUrl(Uri(scheme: 'tel', path: bank['phone'])),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          // Inventory Badges
          Text(isNe ? 'उपलब्ध स्टक (Bags Available):' : 'Available Blood Stock:', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: stock.entries.map((e) {
              final isHighlighted = _selectedGroup == e.key;
              final isZero = e.value == 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? const Color(0xFFDC2626)
                      : (isZero ? const Color(0xFFF1F5F9) : const Color(0xFFEFF6FF)),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isHighlighted ? const Color(0xFFDC2626) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  '${e.key}: ${e.value} bags',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isHighlighted
                        ? Colors.white
                        : (isZero ? const Color(0xFF94A3B8) : const Color(0xFF1E40AF)),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDonorCard(Map<String, dynamic> donor, bool isNe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              donor['bloodGroup'],
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFDC2626), fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(donor['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                Text('${donor['location']} • दान: ${donor['lastDonated']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.call_rounded, size: 14),
            label: Text(isNe ? 'सम्पर्क' : 'Call', style: const TextStyle(fontSize: 11)),
            onPressed: () => launchUrl(Uri(scheme: 'tel', path: donor['phone'])),
          ),
        ],
      ),
    );
  }

  void _showRequestDialog(bool isNe) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isNe ? 'रगत माग दर्ता गर्नुहोस्' : 'Emergency Blood Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: isNe ? 'बिरामीको नाम' : 'Patient Name',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: isNe ? 'अस्पताल / ठेगाना' : 'Hospital Name & Location',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(isNe ? 'रद्द' : 'Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isNe ? 'रक्तदान माग प्रसारण गरियो!' : 'Blood request broadcasted!'),
                  backgroundColor: const Color(0xFF16A34A),
                ),
              );
            },
            child: Text(isNe ? 'प्रसारण गर्नुहोस्' : 'Broadcast'),
          ),
        ],
      ),
    );
  }
}