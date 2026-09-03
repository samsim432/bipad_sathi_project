import 'package:flutter/material.dart';
import 'report_hazard_screen.dart';
import 'road_status_screen.dart';
import 'shelters_screen.dart';
import 'directory_screen.dart';
import 'sos_modal_sheet.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool isNe;
  final Function(String) onLanguageChange;
  final Function(int) onNavigate;

  const HomeScreen({
    super.key,
    required this.isNe,
    required this.onLanguageChange,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield, color: Colors.red, size: 22),
            ),
            const SizedBox(width: 8),
            Text(
              isNe ? 'विपद् साथी' : 'Bipad Sathi',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Color(0xFFD32F2F), size: 26),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => ProfileScreen(isNe: isNe)),
            ),
          ),
          TextButton.icon(
            onPressed: () => onLanguageChange(isNe ? 'en' : 'ne'),
            icon: const Icon(Icons.translate, size: 16, color: Colors.blue),
            label: Text(
              isNe ? 'English' : 'नेपाली',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
        ],

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Danger Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD32F2F), Color(0xFFC2185B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        isNe ? 'उच्च जोखिम चेतावनी !' : 'HIGH RISK ALERT!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isNe ? 'प्रत्यक्ष' : 'LIVE',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isNe
                        ? 'तपाईंको क्षेत्र (नारायणी जलाधार) मा जलसतह चेतावनी रेखा पार गरेको छ। सुरक्षित उच्च स्थानमा जानुहोस्।'
                        : 'Critical flood level crossed in Narayani River Basin. Relocate to assigned safe ground.',
                    style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Action Grid
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95,
              children: [
                _buildCard(
                  Icons.map_outlined,
                  isNe ? 'विपद् नक्सा' : 'Disaster Map',
                  Colors.green.shade700,
                  onTap: () => onNavigate(1),
                ),
                _buildCard(
                  Icons.sos,
                  isNe ? 'उद्धार माग्नुहोस्' : 'Get SOS Aid',
                  Colors.red.shade700,
                  onTap: () => _openSOSModal(context, isNe),
                ),
                _buildCard(
                  Icons.campaign_outlined,
                  isNe ? 'विपद् रिपोर्ट' : 'Report Hazard',
                  Colors.orange.shade800,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => ReportHazardScreen(isNe: isNe)),
                  ),
                ),
                _buildCard(
                  Icons.alt_route_rounded,
                  isNe ? 'सडक अवस्था' : 'Road Status',
                  Colors.indigo.shade600,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => RoadStatusScreen(isNe: isNe)),
                  ),
                ),
                _buildCard(
                  Icons.home_work_outlined,
                  isNe ? 'सुरक्षित स्थान' : 'Safe Shelters',
                  Colors.blue.shade700,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => SheltersScreen(isNe: isNe)),
                  ),
                ),
                _buildCard(
                  Icons.contact_phone_outlined,
                  isNe ? 'सम्पर्क निर्देशिका' : 'Directory',
                  Colors.teal.shade700,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => DirectoryScreen(isNe: isNe)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Safe Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 1,
              ),
              icon: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 22),
              label: Text(
                isNe ? 'म सुरक्षित छु (I am Safe)' : 'I AM SAFE (Send Check-In)',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isNe
                          ? 'तपाईं सुरक्षित रहेको सन्देश स्थानीय उद्धार निकाय तथा परिवारलाई पठाइयो!'
                          : 'Safety status confirmed with disaster response registry!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isNe ? 'ताजा विपद् घटनाहरू' : 'Recent Incidents Nearby',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => onNavigate(2),
                  child: Text(isNe ? 'सबै हेर्नुहोस्' : 'View All'),
                )
              ],
            ),

            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.shade100,
                  child: const Icon(Icons.landslide, color: Colors.orange),
                ),
                title: Text(isNe ? 'पहिरोले सडक अवरुद्ध' : 'Landslide Blockage'),
                subtitle: Text(isNe ? 'मुग्लिन-मलेखु सडक खण्ड • ३० मिनेट अघि' : 'Mugling-Malekhu Highway • 30m ago'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => onNavigate(1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSOSModal(BuildContext context, bool isNe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => const SOSModalSheet(),
    );
  }
}