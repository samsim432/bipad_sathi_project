import 'package:flutter/material.dart';
import '../hazard_feed_manager.dart';
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

class HomeScreen extends StatefulWidget {
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HazardFeedManager _feedManager = HazardFeedManager.instance;

  @override
  void initState() {
    super.initState();
    _feedManager.addListener(_onFeedChanged);
  }

  @override
  void dispose() {
    _feedManager.removeListener(_onFeedChanged);
    super.dispose();
  }

  void _onFeedChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shield_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              isNe ? 'विपद् साथी' : 'Bipad Sathi',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Color(0xFF0F172A),
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              minimumSize: const Size(0, 32),
            ),
            onPressed: () => widget.onLanguageChange(isNe ? 'en' : 'ne'),
            child: Text(
              isNe ? 'English' : 'नेपाली',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded, color: Color(0xFF334155), size: 24),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => ProfileScreen(isNe: isNe)),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Live Alert Header
            _buildLiveAlertCard(isNe),
            const SizedBox(height: 20),

            // 2. Hero Primary Actions
            Row(
              children: [
                Expanded(
                  child: _buildHeroCard(
                    title: isNe ? 'प्रत्यक्ष नक्सा' : 'Live Map',
                    subtitle: isNe ? 'जोखिम र सुरक्षित क्षेत्र' : 'Incidents & Safe Zones',
                    icon: Icons.map_rounded,
                    gradient: const [Color(0xFF1E293B), Color(0xFF0F172A)],
                    iconColor: const Color(0xFF38BDF8),
                    onTap: () => widget.onNavigate(1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildHeroCard(
                    title: isNe ? 'उद्धार माग्नुहोस्' : 'Get SOS Aid',
                    subtitle: isNe ? 'तत्काल उद्धार अनुरोध' : 'Instant Dispatch & GPS',
                    icon: Icons.sos_rounded,
                    gradient: const [Color(0xFFDC2626), Color(0xFFB91C1C)],
                    iconColor: Colors.white,
                    isEmergency: true,
                    onTap: () => _openSOSModal(context, isNe),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Section: Immediate Response
            _buildSectionHeader(isNe ? 'तत्काल प्रतिकार्य' : 'Immediate Response'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildCompactAction(
                    icon: Icons.medical_services_rounded,
                    title: isNe ? 'प्राथमिक उपचार' : 'First Aid',
                    subtitle: isNe ? 'अफलाइन गाइड' : 'Offline Guide',
                    color: const Color(0xFF059669),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => FirstAidScreen(isNe: isNe)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildCompactAction(
                    icon: Icons.campaign_rounded,
                    title: isNe ? 'घटना रिपोर्ट' : 'Report Hazard',
                    subtitle: isNe ? 'जोखिम सूचना' : 'Crowdsource',
                    color: const Color(0xFFEA580C),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => ReportHazardScreen(isNe: isNe)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildCompactAction(
                    icon: Icons.ring_volume_rounded,
                    title: isNe ? 'साइरन / बिकन' : 'SOS Siren',
                    subtitle: isNe ? 'ध्वनि र प्रकाश' : 'Strobe & Sound',
                    color: const Color(0xFFD97706),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => EmergencySirenScreen(isNe: isNe)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Section: Live Monitoring
            _buildSectionHeader(isNe ? 'प्रत्यक्ष निगरानी तथा पूर्वाधार' : 'Live Monitoring'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildListActionTile(
                    icon: Icons.water_rounded,
                    iconColor: const Color(0xFF0284C7),
                    title: isNe ? 'नदी जलसतह तथा बाढी सूचना' : 'River Basin Flood Radar',
                    subtitle: isNe ? 'DHM प्रत्यक्ष जलमापन प्रणाली' : 'Live telemetry & flood gauges',
                    badge: isNe ? 'नारायणी उच्च' : 'Narayani Alert',
                    badgeColor: const Color(0xFFDC2626),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => RiverAlertsScreen(isNe: isNe)),
                    ),
                  ),
                  const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
                  _buildListActionTile(
                    icon: Icons.alt_route_rounded,
                    iconColor: const Color(0xFF4F46E5),
                    title: isNe ? 'सडक तथा राजमार्ग अवस्था' : 'Road & Highway Status',
                    subtitle: isNe ? 'पहिरो र बाटो अवरोध विवरण' : 'Blockages, clearances & updates',
                    badge: isNe ? 'मुग्लिन अवरुद्ध' : 'Mugling Blocked',
                    badgeColor: const Color(0xFFEA580C),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => RoadStatusScreen(isNe: isNe)),
                    ),
                  ),
                  const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
                  _buildListActionTile(
                    icon: Icons.home_work_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    title: isNe ? 'नजिकका सुरक्षित आश्रय स्थल' : 'Verified Safe Shelters',
                    subtitle: isNe ? 'क्षमता, पानी र स्वास्थ्य सेवा विवरण' : 'Capacities, provisions & locations',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => SheltersScreen(isNe: isNe)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. Section: Community & Readiness
            _buildSectionHeader(isNe ? 'तयारी तथा समुदाय' : 'Community & Preparedness'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildListActionTile(
                    icon: Icons.bloodtype_rounded,
                    iconColor: const Color(0xFFE11D48),
                    title: isNe ? 'रक्तदान तथा ब्लड बैंक' : 'Blood Bank & Donor Network',
                    subtitle: isNe ? '२४/७ आपत्कालीन रक्त सेवा' : 'Find nearest blood groups & banks',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => BloodNetworkScreen(isNe: isNe)),
                    ),
                  ),
                  const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
                  _buildListActionTile(
                    icon: Icons.person_search_rounded,
                    iconColor: const Color(0xFF0284C7),
                    title: isNe ? 'खोजतलास तथा पुनर्मिलन' : 'Missing Persons Board',
                    subtitle: isNe ? 'हराएका व्यक्तिको सूची र रिपोर्ट' : 'Reunite families & shelter checks',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => MissingPersonsScreen(isNe: isNe)),
                    ),
                  ),
                  const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
                  _buildListActionTile(
                    icon: Icons.backpack_rounded,
                    iconColor: const Color(0xFF059669),
                    title: isNe ? 'आपत्कालीन झोला (Go-Bag)' : 'Emergency Go-Bag Kit',
                    subtitle: isNe ? '७२ घण्टे जीवनरक्षा तयारी सूची' : '72-hour survival readiness checklist',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => EmergencyKitScreen(isNe: isNe)),
                    ),
                  ),
                  const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
                  _buildListActionTile(
                    icon: Icons.contact_phone_rounded,
                    iconColor: const Color(0xFF0F766E),
                    title: isNe ? 'आपत्कालीन निर्देशिका' : 'Emergency Directory',
                    subtitle: isNe ? 'प्रहरी, एम्बुलेन्स र उद्धार टोली' : 'Direct dispatch hotline numbers',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => DirectoryScreen(isNe: isNe)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 6. "I Am Safe" Check-In Banner
            _buildSafetyCheckIn(context, isNe),
            const SizedBox(height: 28),

            // 7. NEW: CROWDSOURCED COMMUNITY HAZARD VERIFICATION FEED
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.verified_user_outlined, color: Color(0xFFDC2626), size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isNe ? 'नागरिक विपद् सूचना तथा प्रमाणिकरण' : 'Community Hazard Feed',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => ReportHazardScreen(isNe: isNe)),
                  ),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 16, color: Color(0xFFDC2626)),
                  label: Text(
                    isNe ? 'रिपोर्ट थप्नुहोस्' : 'Report',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFDC2626)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // List of Community Hazard Posts with Upvote/Downvote & Comments
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _feedManager.reports.length,
              itemBuilder: (ctx, idx) {
                final report = _feedManager.reports[idx];
                return _buildCommunityHazardCard(report, isNe);
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- CROWDSOURCED HAZARD CARD (REDDIT STYLE) ---
  Widget _buildCommunityHazardCard(HazardReportItem report, bool isNe) {
    final netScore = report.upvotes - report.downvotes;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: report.isDisputed ? const Color(0xFFFECACA) : const Color(0xFFE2E8F0),
          width: report.isDisputed ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header: Author, Time, Verification Badge
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: report.color.withOpacity(0.12),
                  child: Icon(report.icon, color: report.color, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.author,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        '${report.time} • ${report.location}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Verification pill
                if (report.isVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 12),
                        const SizedBox(width: 4),
                        Text(
                          isNe ? 'प्रमाणित' : 'Verified',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                        ),
                      ],
                    ),
                  )
                else if (report.isDisputed)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flag_rounded, color: Color(0xFFDC2626), size: 12),
                        const SizedBox(width: 4),
                        Text(
                          isNe ? 'विवादित' : 'Disputed',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Title & Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Text(
              report.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), height: 1.35),
            ),
          ),

          // Optional Image
          if (report.imageUrl != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              child: Image.network(
                report.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => const SizedBox.shrink(),
              ),
            ),
          ],

          const Divider(height: 16, color: Color(0xFFF1F5F9)),

          // Actions Row: Upvote, Downvote, Comments
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 14, 10),
            child: Row(
              children: [
                // Upvote / Downvote Capsule
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          Icons.arrow_upward_rounded,
                          size: 18,
                          color: report.userVote == 1 ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                        ),
                        onPressed: () => _feedManager.vote(report.id, 1),
                      ),
                      Text(
                        '$netScore',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: report.userVote == 1
                              ? const Color(0xFF16A34A)
                              : (report.userVote == -1 ? const Color(0xFFDC2626) : const Color(0xFF0F172A)),
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          Icons.arrow_downward_rounded,
                          size: 18,
                          color: report.userVote == -1 ? const Color(0xFFDC2626) : const Color(0xFF64748B),
                        ),
                        onPressed: () => _feedManager.vote(report.id, -1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Comment Button
                InkWell(
                  onTap: () => _openCommentsSheet(report, isNe),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.mode_comment_outlined, size: 16, color: Color(0xFF475569)),
                        const SizedBox(width: 6),
                        Text(
                          '${report.comments.length}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),

                // Live status tag
                Text(
                  isNe ? 'प्रमाणिकरण सक्रिय' : 'Live Verification',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- COMMENT MODAL SHEET ---
  void _openCommentsSheet(HazardReportItem report, bool isNe) {
    final TextEditingController commentCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
            top: 16,
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isNe ? 'प्रत्यक्ष स्थिति र प्रतिक्रिया' : 'Live Updates & Verification',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    '${report.comments.length} comments',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),

              // Comments List
              Expanded(
                child: report.comments.isEmpty
                    ? Center(
                        child: Text(
                          isNe ? 'अहिलेसम्म कुनै प्रतिक्रिया छैन। पहिलो अपडेट दिनुहोस्!' : 'No updates yet. Be the first to confirm status!',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        ),
                      )
                    : ListView.builder(
                        itemCount: report.comments.length,
                        itemBuilder: (c, i) {
                          final cmt = report.comments[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cmt['author'] ?? 'Anonymous',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B)),
                                    ),
                                    Text(
                                      cmt['time'] ?? 'Just now',
                                      style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cmt['text'] ?? '',
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.3),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // Add Comment Input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentCtrl,
                        decoration: InputDecoration(
                          hintText: isNe ? 'के स्थिति अहिले सामान्य छ? लेख्नुहोस्...' : 'Confirm current situation or alert others...',
                          hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: Color(0xFF2563EB), size: 20),
                      onPressed: () {
                        if (commentCtrl.text.trim().isNotEmpty) {
                          _feedManager.addComment(report.id, commentCtrl.text.trim(), 'Citizen (नागरिक)');
                          commentCtrl.clear();
                          setModalState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TOP LIVE ALERT ---
  Widget _buildLiveAlertCard(bool isNe) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                isNe ? 'उच्च जोखिम चेतावनी (LIVE)' : 'HIGH RISK ALERT (LIVE)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF991B1B),
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                isNe ? 'नारायणी जलाधार' : 'Narayani Basin',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isNe
                ? 'नारायणी नदीमा जलसतह चेतावनी रेखा पार गरेको छ। तटीय क्षेत्रका बासिन्दा तुरुन्तै सुरक्षित स्थानमा जानुहोस्।'
                : 'Critical flood level crossed at Devghat gauge. Low-lying areas advised to evacuate immediately.',
            style: const TextStyle(fontSize: 13, color: Color(0xFF7F1D1D), height: 1.4),
          ),
        ],
      ),
    );
  }

  // --- HERO PRIMARY ACTION CARDS ---
  Widget _buildHeroCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required Color iconColor,
    bool isEmergency = false,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 125,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white.withOpacity(0.7), size: 18),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- COMPACT 3-COLUMN ACTIONS ---
  Widget _buildCompactAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- LIST ACTION TILE ---
  Widget _buildListActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badge,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              if (badge != null && badgeColor != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: badgeColor,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // --- "I AM SAFE" CHECK IN ---
  Widget _buildSafetyCheckIn(BuildContext context, bool isNe) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isNe
                      ? 'तपाईं सुरक्षित रहेको सन्देश स्थानीय उद्धार निकाय तथा परिवारलाई पठाइयो!'
                      : 'Safety status confirmed with disaster response registry!',
                ),
                backgroundColor: const Color(0xFF16A34A),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF16A34A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isNe ? 'म सुरक्षित छु (I am Safe)' : 'I AM SAFE (Check-In)',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14532D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isNe ? 'परिवार र उद्धार टोलीलाई तुरुन्तै सूचित गर्नुहोस्' : 'Ping emergency registry & loved ones',
                        style: const TextStyle(fontSize: 11.5, color: Color(0xFF166534)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded, color: Color(0xFF16A34A), size: 18),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF64748B),
        letterSpacing: 0.2,
      ),
    );
  }
}