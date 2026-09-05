import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../hazard_feed_manager.dart';
import 'blood_network_screen.dart';
import 'directory_screen.dart';
import 'disaster_map_screen.dart';
import 'emergency_kit_screen.dart';
import 'emergency_siren_screen.dart';
import 'first_aid_screen.dart';
import 'profile_screen.dart';
import 'report_hazard_screen.dart';
import 'river_alerts_screen.dart';
import 'road_status_screen.dart';
import 'shelters_screen.dart';
import 'sos_modal_sheet.dart';

class HomeScreen extends StatelessWidget {
  final bool isNe;
  final dynamic onLanguageChange;
  final Function(int)? onNavigate;

  const HomeScreen({
    super.key,
    this.isNe = true,
    this.onLanguageChange,
    this.onNavigate,
  });

  void _handleLanguageToggle() {
    if (onLanguageChange != null) {
      try {
        onLanguageChange!(isNe ? 'en' : 'ne');
      } catch (_) {
        try {
          onLanguageChange!();
        } catch (_) {}
      }
    }
  }

  Future<void> _triggerIAmSafe(BuildContext context) async {
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
      );
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('user_name') ?? 'नागरिक';
      final familyPhone = prefs.getString('emergency_phone') ?? '100';

      final safePayload = '✅ I AM SAFE / म सुरक्षित छु!\n'
          'Name: $name\n'
          'Status: No injuries reported\n'
          'GPS: https://maps.google.com/?q=${pos.latitude},${pos.longitude}';

      final Uri smsUri = Uri(
        scheme: 'sms',
        path: familyPhone,
        queryParameters: {'body': safePayload},
      );

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isNe ? 'परिवारलाई "म सुरक्षित छु" सन्देश पठाइयो।' : '"I Am Safe" update broadcasted.'),
            backgroundColor: const Color(0xFF16A34A),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle),
              child: const Icon(Icons.shield_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Text(
              isNe ? 'विपद् साथी' : 'BIPAD SATHI',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: _handleLanguageToggle,
            child: Text(
              isNe ? 'English' : 'नेपाली',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Color(0xFF0F172A)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(isNe: isNe))),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: HazardFeedManager.instance,
        builder: (context, _) {
          final feedManager = HazardFeedManager.instance;
          final reports = feedManager.reports;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
            children: [
              // 1. Live Warning Ticker
              if (reports.isNotEmpty) _buildWarningTicker(reports.first),
              const SizedBox(height: 14),

              // 2. High-Impact Action Cards (Live Radar & SOS Rescue)
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      title: isNe ? 'प्रत्यक्ष नक्सा' : 'Live Radar',
                      subtitle: isNe ? 'जोखिम र सुरक्षित क्षेत्र' : 'Risk & Safe Zones',
                      icon: Icons.map_rounded,
                      color: const Color(0xFF0F172A),
                      onTap: () {
                        if (onNavigate != null) {
                          onNavigate!(1);
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => DisasterMapScreen(isNe: isNe)));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionCard(
                      title: isNe ? 'उद्धार माग्नुहोस्' : 'Request SOS',
                      subtitle: isNe ? 'तत्काल ३-तह उद्धार' : '3-Tier Dispatch',
                      icon: Icons.emergency_rounded,
                      color: const Color(0xFFDC2626),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => const SOSModalSheet(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. Quick Response Grid
              _buildSectionHeader(isNe ? 'तत्काल प्रतिकार्य (Quick Response)' : 'Emergency Utilities'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildToolTile(
                      title: isNe ? 'प्राथमिक उपचार' : 'First Aid',
                      subtitle: isNe ? 'सीपीआर गाइड' : 'CPR Metronome',
                      icon: Icons.medical_services_rounded,
                      color: const Color(0xFF16A34A),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FirstAidScreen(isNe: isNe))),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildToolTile(
                      title: isNe ? 'घटना रिपोर्ट' : 'Report Hazard',
                      subtitle: isNe ? 'जोखिम सूचना' : 'Crowdsource',
                      icon: Icons.campaign_rounded,
                      color: const Color(0xFFEA580C),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportHazardScreen(isNe: isNe))),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildToolTile(
                      title: isNe ? 'साइरन / बत्ती' : 'Siren Beacon',
                      subtitle: isNe ? 'ध्वनि र प्रकाश' : 'Audio & Strobe',
                      icon: Icons.volume_up_rounded,
                      color: const Color(0xFFD97706),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmergencySirenScreen(isNe: isNe))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 4. Live Hazard Radar Links
              _buildSectionHeader(isNe ? 'प्रत्यक्ष निगरानी तथा पूर्वधार' : 'Live Hazard Telemetry'),
              const SizedBox(height: 8),
              _buildNavCard(
                title: isNe ? 'नदी जलसतह तथा बाढी सूचना' : 'River Water Level & Flood Radar',
                subtitle: isNe ? 'DHM प्रत्यक्ष जलमापन प्रणाली' : 'DHM Live River Telemetry',
                badgeText: isNe ? 'नारायणी उच्च' : 'Narayani Alert',
                badgeColor: Colors.red,
                icon: Icons.water_damage_rounded,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RiverAlertsScreen(isNe: isNe))),
              ),
              const SizedBox(height: 8),
              _buildNavCard(
                title: isNe ? 'सडक तथा राजमार्ग अवस्था' : 'Highways & Landslide Radar',
                subtitle: isNe ? 'पहिरो र बाटो अवरोध विवरण' : 'Live Blockages & Clearance ETA',
                badgeText: isNe ? 'मुग्लिन अवरुद्ध' : 'Mugling Blocked',
                badgeColor: Colors.orange,
                icon: Icons.remove_road_rounded,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RoadStatusScreen(isNe: isNe))),
              ),
              const SizedBox(height: 8),
              _buildNavCard(
                title: isNe ? 'नजिकका सुरक्षित आश्रय स्थल' : 'Nearby Emergency Shelters',
                subtitle: isNe ? 'क्षमता, पानी र स्वास्थ्य सेवा विवरण' : 'Available Beds & Utilities',
                badgeText: isNe ? '२ आश्रय खुला' : '2 Open',
                badgeColor: Colors.green,
                icon: Icons.night_shelter_rounded,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SheltersScreen(isNe: isNe))),
              ),
              const SizedBox(height: 18),

              // 5. Preparation & Community Tools
              _buildSectionHeader(isNe ? 'तयारी तथा समुदाय' : 'Community & Readiness'),
              const SizedBox(height: 8),
              _buildNavCard(
                title: isNe ? 'रक्तदान तथा ब्लड बैंक' : 'Blood Bank & Donor Network',
                subtitle: isNe ? '२४/७ आपत्कालीन रक्त सेवा' : 'Emergency Blood Stock',
                icon: Icons.bloodtype_rounded,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BloodNetworkScreen(isNe: isNe))),
              ),
              const SizedBox(height: 8),
              _buildNavCard(
                title: isNe ? 'आपत्कालीन झोला (Go-Bag)' : '72-Hour Emergency Go-Bag',
                subtitle: isNe ? '७२ घण्टे जीवनरक्षा तयारी सूची' : 'Readiness Checklist',
                icon: Icons.backpack_rounded,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmergencyKitScreen(isNe: isNe))),
              ),
              const SizedBox(height: 8),
              _buildNavCard(
                title: isNe ? 'आपत्कालीन निर्देशिका (Hotlines)' : 'Emergency Directory & Hotlines',
                subtitle: isNe ? 'प्रहरी, एम्बुलेन्स, सेना र उद्धार टोली' : 'Police, Ambulance & DEOC Directory',
                icon: Icons.contact_phone_rounded,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DirectoryScreen(isNe: isNe))),
              ),
              const SizedBox(height: 14),

              // 6. "I Am Safe" One-Tap Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle),
                      child: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isNe ? 'म सुरक्षित छु (I Am Safe)' : 'Broadcast "I Am Safe"',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF14532D)),
                          ),
                          Text(
                            isNe ? 'परिवार र उद्धार टोलीलाई तुरुन्त सूचित गर्नुहोस्' : 'Notify guardians of your GPS & safety',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF166534)),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _triggerIAmSafe(context),
                      child: Text(isNe ? 'पठाउनुहोस्' : 'Check-In', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 7. Live Citizen Hazard Feeds
              _buildSectionHeader(isNe ? 'नागरिक विपद् सूचना तथा प्रमाणीकरण' : 'Crowdsourced Incident Feed'),
              const SizedBox(height: 10),
              ...reports.map((report) => _buildFeedItem(report, feedManager, isNe)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWarningTicker(HazardReportItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle),
            child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${item.title} (${item.location})',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF991B1B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color.withOpacity(0.12),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 6),
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF0F172A))),
              Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9, color: Color(0xFF64748B))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavCard({
    required String title,
    required String subtitle,
    String? badgeText,
    Color badgeColor = Colors.red,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 20, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
                    Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              if (badgeText != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: badgeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(badgeText, style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 4),
              ],
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedItem(HazardReportItem item, HazardFeedManager manager, bool isNe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: item.color.withOpacity(0.15),
                child: Icon(item.icon, color: item.color, size: 14),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('${item.location} • ${item.time}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              if (item.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                  child: const Text('प्रमाणित', style: TextStyle(color: Color(0xFF16A34A), fontSize: 9, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF0F172A))),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  item.userVote == 1 ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                  size: 16,
                  color: item.userVote == 1 ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                ),
                onPressed: () => manager.vote(item.id, 1),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              Text('${item.upvotes}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(width: 14),
              IconButton(
                icon: Icon(
                  item.userVote == -1 ? Icons.thumb_down_alt : Icons.thumb_down_alt_outlined,
                  size: 16,
                  color: item.userVote == -1 ? const Color(0xFFDC2626) : const Color(0xFF64748B),
                ),
                onPressed: () => manager.vote(item.id, -1),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              Text('${item.downvotes}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}