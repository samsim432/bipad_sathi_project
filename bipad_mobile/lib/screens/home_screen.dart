import 'package:flutter/material.dart';
import 'report_hazard_screen.dart';
import 'road_status_screen.dart';
import 'shelters_screen.dart';
import 'directory_screen.dart';
import 'sos_modal_sheet.dart';
import 'profile_screen.dart';
import 'first_aid_screen.dart';
import 'blood_network_screen.dart';
import 'river_alerts_screen.dart';
import 'emergency_siren_screen.dart';
import 'missing_persons_screen.dart';
import 'emergency_kit_screen.dart';

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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shield_rounded, color: Color(0xFFDC2626), size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              isNe ? 'विपद् साथी' : 'Bipad Sathi',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          // Language Switcher Pill
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: InkWell(
              onTap: () => onLanguageChange(isNe ? 'en' : 'ne'),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.translate_rounded, size: 14, color: Color(0xFF2563EB)),
                    const SizedBox(width: 4),
                    Text(
                      isNe ? 'English' : 'नेपाली',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Profile Button
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
              ),
              child: const CircleAvatar(
                radius: 13,
                backgroundColor: Color(0xFFF1F5F9),
                child: Icon(Icons.person_rounded, size: 18, color: Color(0xFF475569)),
              ),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => ProfileScreen(isNe: isNe)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. High Risk Live Alert Banner
            _buildAlertBanner(isNe),

            const SizedBox(height: 20),

            // 2. Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isNe ? 'आपत्कालीन सेवाहरू' : 'Emergency Services',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isNe ? '१२ मोड्युल' : '12 Modules',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 3. Symmetrical 12-Card Grid (4 Rows x 3 Columns)
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.88,
              children: [
                // Row 1
                _buildModernCard(
                  icon: Icons.map_rounded,
                  label: isNe ? 'विपद् नक्सा' : 'Disaster Map',
                  color: const Color(0xFF059669),
                  onTap: () => onNavigate(1),
                ),
                _buildModernCard(
                  icon: Icons.sos_rounded,
                  label: isNe ? 'उद्धार (SOS)' : 'Get SOS Aid',
                  color: const Color(0xFFDC2626),
                  isEmergency: true,
                  onTap: () => _openSOSModal(context, isNe),
                ),
                _buildModernCard(
                  icon: Icons.campaign_rounded,
                  label: isNe ? 'विपद् रिपोर्ट' : 'Report Hazard',
                  color: const Color(0xFFEA580C),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => ReportHazardScreen(isNe: isNe)),
                  ),
                ),

                // Row 2
                _buildModernCard(
                  icon: Icons.alt_route_rounded,
                  label: isNe ? 'सडक अवस्था' : 'Road Status',
                  color: const Color(0xFF4F46E5),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => RoadStatusScreen(isNe: isNe)),
                  ),
                ),
                _buildModernCard(
                  icon: Icons.medical_services_rounded,
                  label: isNe ? 'प्राथमिक उपचार' : 'First Aid Guide',
                  color: const Color(0xFF0D9488),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => FirstAidScreen(isNe: isNe)),
                  ),
                ),
                _buildModernCard(
                  icon: Icons.bloodtype_rounded,
                  label: isNe ? 'रक्तदान नेटवर्क' : 'Blood Network',
                  color: const Color(0xFFE11D48),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => BloodNetworkScreen(isNe: isNe)),
                  ),
                ),

                // Row 3
                _buildModernCard(
                  icon: Icons.water_rounded,
                  label: isNe ? 'नदी जलसतह' : 'River Radar',
                  color: const Color(0xFF0284C7),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => RiverAlertsScreen(isNe: isNe)),
                  ),
                ),
                _buildModernCard(
                  icon: Icons.ring_volume_rounded,
                  label: isNe ? 'साइरन / बिकन' : 'SOS Siren',
                  color: const Color(0xFFD97706),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => EmergencySirenScreen(isNe: isNe)),
                  ),
                ),
                _buildModernCard(
                  icon: Icons.home_work_rounded,
                  label: isNe ? 'सुरक्षित स्थान' : 'Safe Shelters',
                  color: const Color(0xFF7C3AED),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => SheltersScreen(isNe: isNe)),
                  ),
                ),

                // Row 4
                _buildModernCard(
                  icon: Icons.person_search_rounded,
                  label: isNe ? 'खोजतलास' : 'Missing Persons',
                  color: const Color(0xFF0369A1),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => MissingPersonsScreen(isNe: isNe)),
                  ),
                ),
                _buildModernCard(
                  icon: Icons.backpack_rounded,
                  label: isNe ? 'आपत्कालीन झोला' : 'Go-Bag Kit',
                  color: const Color(0xFF15803D),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => EmergencyKitScreen(isNe: isNe)),
                  ),
                ),
                _buildModernCard(
                  icon: Icons.contact_phone_rounded,
                  label: isNe ? 'सम्पर्क निर्देशिका' : 'Directory',
                  color: const Color(0xFF0F766E),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => DirectoryScreen(isNe: isNe)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // 4. "I Am Safe" Interactive Card
            _buildSafetyStatusCard(context, isNe),

            const SizedBox(height: 22),

            // 5. Recent Incidents Nearby Feed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt_rounded, size: 18, color: Color(0xFFDC2626)),
                    const SizedBox(width: 6),
                    Text(
                      isNe ? 'ताजा विपद् घटनाहरू' : 'Recent Incidents Nearby',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => onNavigate(2),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: const Color(0xFF2563EB),
                  ),
                  child: Text(isNe ? 'सबै हेर्नुहोस्' : 'View All'),
                )
              ],
            ),

            const SizedBox(height: 8),

            // Incident Card 1
            _buildIncidentFeedItem(
              title: isNe ? 'पहिरोले मुग्लिन सडक खण्ड अवरुद्ध' : 'Landslide Blockage at Mugling',
              location: isNe ? 'मुग्लिन-मलेखु सडक, धादिङ' : 'Mugling-Malekhu Highway, Dhading',
              time: isNe ? '२५ मिनेट अघि' : '25 mins ago',
              severity: isNe ? 'अवरुद्ध' : 'BLOCKED',
              icon: Icons.landslide_rounded,
              color: const Color(0xFFEA580C),
              onTap: () => onNavigate(1),
            ),

            const SizedBox(height: 10),

            // Incident Card 2
            _buildIncidentFeedItem(
              title: isNe ? 'नारायणी नदी जलसतह उच्च चेतावनी' : 'Narayani River High Flood Alert',
              location: isNe ? 'देवघाट, चितवन' : 'Devghat Gauge Station, Chitwan',
              time: isNe ? '४५ मिनेट अघि' : '45 mins ago',
              severity: isNe ? 'उच्च जोखिम' : 'CRITICAL',
              icon: Icons.water_damage_rounded,
              color: const Color(0xFFDC2626),
              onTap: () => onNavigate(1),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- TOP DANGER BANNER ---
  Widget _buildAlertBanner(bool isNe) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB91C1C), Color(0xFF991B1B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x33DC2626), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                isNe ? 'उच्च जोखिम चेतावनी' : 'HIGH RISK ALERT',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: Color(0xFF4ADE80), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isNe ? 'प्रत्यक्ष' : 'LIVE',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isNe
                ? 'तपाईंको क्षेत्र (नारायणी जलाधार) मा जलसतह चेतावनी रेखा पार गरेको छ। सुरक्षित स्थानमा जानुहोस्।'
                : 'Critical flood level crossed in Narayani River Basin. Relocate to assigned safe ground.',
            style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 12.5, height: 1.35),
          ),
        ],
      ),
    );
  }

  // --- MODERN 3D-FEEL GRID CARD ---
  Widget _buildModernCard({
    required IconData icon,
    required String label,
    required Color color,
    bool isEmergency = false,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: isEmergency ? const Color(0xFFFEF2F2) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isEmergency ? const Color(0xFFFCA5A5) : const Color(0xFFE2E8F0),
              width: isEmergency ? 1.5 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isEmergency ? const Color(0xFFDC2626) : color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isEmergency ? Colors.white : color,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isEmergency ? const Color(0xFF991B1B) : const Color(0xFF1E293B),
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- "I AM SAFE" CHECK-IN CARD ---
  Widget _buildSafetyStatusCard(BuildContext context, bool isNe) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
        boxShadow: const [
          BoxShadow(color: Color(0x0A16A34A), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isNe
                            ? 'तपाईं सुरक्षित रहेको सन्देश स्थानीय उद्धार निकाय तथा परिवारलाई पठाइयो!'
                            : 'Safety status confirmed with disaster response registry!',
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFF16A34A),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.verified_user_rounded, color: Color(0xFF16A34A), size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isNe ? 'म सुरक्षित छु (I am Safe)' : 'I AM SAFE (Send Check-In)',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isNe ? 'परिवार र उद्धार टोलीलाई तुरुन्तै सूचित गर्नुहोस्' : 'Notify family & emergency rescue teams instantly',
                        style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF16A34A)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- RECENT INCIDENT ITEM ---
  Widget _buildIncidentFeedItem({
    required String title,
    required String location,
    required String time,
    required String severity,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              severity,
                              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: color),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF64748B)),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              location,
                              style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
              ],
            ),
          ),
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