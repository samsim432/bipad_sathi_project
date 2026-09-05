import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSModalSheet extends StatefulWidget {
  const SOSModalSheet({super.key});

  @override
  State<SOSModalSheet> createState() => _SOSModalSheetState();
}

class _SOSModalSheetState extends State<SOSModalSheet> with SingleTickerProviderStateMixin {
  int _peopleCount = 1;
  bool _hasChildren = false;
  bool _hasElderly = false;
  bool _hasSpecialNeeds = false;
  bool _isLocating = false;

  late AnimationController _holdController;
  Timer? _vibrateTimer;

  @override
  void initState() {
    super.initState();
    _holdController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          HapticFeedback.heavyImpact();
          _trigger3TierSOS();
        }
      });
  }

  @override
  void dispose() {
    _holdController.dispose();
    _vibrateTimer?.cancel();
    super.dispose();
  }

  void _onHoldStart(TapDownDetails details) {
    if (_isLocating) return;
    HapticFeedback.mediumImpact();
    _holdController.forward();
    _vibrateTimer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      HapticFeedback.selectionClick();
    });
  }

  void _onHoldEnd() {
    _vibrateTimer?.cancel();
    if (_holdController.status != AnimationStatus.completed) {
      _holdController.reverse();
    }
  }

  Future<void> _trigger3TierSOS() async {
    setState(() => _isLocating = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 8),
      );

      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('user_name') ?? 'नागरिक (Citizen)';
      final phone = prefs.getString('user_phone') ?? 'N/A';
      final blood = prefs.getString('user_blood_group') ?? 'Unknown';
      final familyPhone = prefs.getString('emergency_phone') ?? '100';

      final mapLink = 'https://maps.google.com/?q=${position.latitude},${position.longitude}';

      final dispatchSMS = 
'🚨 VIPAD SOS 🚨\n'
'Name: $name\n'
'Phone: $phone | Blood: $blood\n'
'Triage: $_peopleCount ppl (Child: $_hasChildren, Elderly: $_hasElderly, Hurt: $_hasSpecialNeeds)\n'
'GPS: ${position.latitude.toStringAsFixed(5)},${position.longitude.toStringAsFixed(5)}\n'
'Map: $mapLink';

      final Uri smsUri = Uri(
        scheme: 'sms',
        path: familyPhone,
        queryParameters: {'body': dispatchSMS},
      );

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      }

      if (mounted) {
        Navigator.pop(context);
        _showDispatchedSheet(context, dispatchSMS);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('GPS Signal Failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _showDispatchedSheet(BuildContext context, String payload) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 54),
            const SizedBox(height: 12),
            const Text(
              'उद्धार अनुरोध पठाइयो (SOS Dispatched)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(payload, style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text('बन्द गर्नुहोस् (Close)'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.emergency_rounded, color: Color(0xFFDC2626), size: 24),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'आकस्मिक उद्धार अनुरोध (SOS)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    '३ सेकेन्ड थिचेर पुष्टि गर्नुहोस् (Hold 3s to send)',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Triage Details
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('व्यक्ति संख्या (Triage Headcount)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _peopleCount > 1 ? () => setState(() => _peopleCount--) : null,
                          icon: const Icon(Icons.remove_circle_outline, size: 22),
                        ),
                        Text('$_peopleCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () => setState(() => _peopleCount++),
                          icon: const Icon(Icons.add_circle_outline, size: 22),
                        ),
                      ],
                    )
                  ],
                ),
                const Divider(height: 10),
                Wrap(
                  spacing: 6,
                  children: [
                    FilterChip(
                      label: const Text('बालबालिका (Child)', style: TextStyle(fontSize: 11)),
                      selected: _hasChildren,
                      onSelected: (v) => setState(() => _hasChildren = v),
                    ),
                    FilterChip(
                      label: const Text('वृद्धवृद्धा (Elderly)', style: TextStyle(fontSize: 11)),
                      selected: _hasElderly,
                      onSelected: (v) => setState(() => _hasElderly = v),
                    ),
                    FilterChip(
                      label: const Text('घाइते (Injured)', style: TextStyle(fontSize: 11)),
                      selected: _hasSpecialNeeds,
                      onSelected: (v) => setState(() => _hasSpecialNeeds = v),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Hold-To-Confirm Animated SOS Button
          GestureDetector(
            onTapDown: _onHoldStart,
            onTapUp: (_) => _onHoldEnd(),
            onTapCancel: _onHoldEnd,
            child: AnimatedBuilder(
              animation: _holdController,
              builder: (context, child) {
                return Container(
                  height: 54,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Color(0x33DC2626), blurRadius: 14, offset: Offset(0, 6)),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Loading bar fill
                      FractionallySizedBox(
                        widthFactor: _holdController.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF991B1B),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.touch_app_rounded, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _holdController.value > 0
                                  ? 'पठाउँदै... (${(3 - (_holdController.value * 3)).toStringAsFixed(1)}s)'
                                  : 'थिचिराख्नुहोस् (HOLD 3S TO RESCUE)',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}