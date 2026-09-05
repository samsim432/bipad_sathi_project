import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmergencySirenScreen extends StatefulWidget {
  final bool isNe;
  const EmergencySirenScreen({super.key, required this.isNe});

  @override
  State<EmergencySirenScreen> createState() => _EmergencySirenScreenState();
}

class _EmergencySirenScreenState extends State<EmergencySirenScreen> with SingleTickerProviderStateMixin {
  bool _isActive = false;
  String _mode = 'POLICE'; // POLICE, SOS_MORSE, WHITE_STROBE
  Color _currentColor = const Color(0xFF0F172A);
  
  Timer? _strobeTimer;
  Timer? _hapticTimer;
  late AnimationController _radarController;

  final List<int> _morseSequence = [
    150, 150, 150, 150, 150, 450,
    450, 150, 450, 150, 450, 450,
    150, 150, 150, 150, 150, 1000
  ];
  int _morseIndex = 0;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _stopSiren();
    _radarController.dispose();
    super.dispose();
  }

  void _toggleSiren() {
    if (_isActive) {
      _stopSiren();
    } else {
      _startSiren();
    }
  }

  void _startSiren() {
    setState(() => _isActive = true);
    _radarController.repeat();

    _hapticTimer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      HapticFeedback.heavyImpact();
    });

    if (_mode == 'POLICE') {
      _strobeTimer = Timer.periodic(const Duration(milliseconds: 180), (timer) {
        setState(() {
          _currentColor = (_currentColor == const Color(0xFFDC2626))
              ? const Color(0xFF2563EB)
              : const Color(0xFFDC2626);
        });
      });
    } else if (_mode == 'WHITE_STROBE') {
      _strobeTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
        setState(() {
          _currentColor = (_currentColor == Colors.white) ? Colors.black : Colors.white;
        });
      });
    } else if (_mode == 'SOS_MORSE') {
      _runMorseLoop();
    }
  }

  void _runMorseLoop() {
    if (!_isActive || _mode != 'SOS_MORSE') return;

    final duration = _morseSequence[_morseIndex % _morseSequence.length];
    final isLightOn = _morseIndex % 2 == 0;

    setState(() {
      _currentColor = isLightOn ? Colors.white : Colors.black;
    });

    _strobeTimer = Timer(Duration(milliseconds: duration), () {
      _morseIndex++;
      _runMorseLoop();
    });
  }

  void _stopSiren() {
    _strobeTimer?.cancel();
    _hapticTimer?.cancel();
    _radarController.stop();
    setState(() {
      _isActive = false;
      _currentColor = const Color(0xFF0F172A);
      _morseIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;
    final isLightBackground = _currentColor == Colors.white;

    return Scaffold(
      backgroundColor: _currentColor,
      appBar: AppBar(
        title: Text(
          isNe ? 'आकस्मिक साइरन / बत्ती' : 'Emergency Siren & Beacon',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isLightBackground ? Colors.black : Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isLightBackground ? Colors.black : Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: (isLightBackground ? Colors.black12 : Colors.white12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isActive ? Icons.sensors_rounded : Icons.info_outline_rounded,
                      color: isLightBackground ? Colors.black : Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _isActive
                            ? (isNe ? 'साइरन र प्रकाश सक्रिय छ!' : 'Siren & Visual Beacon Active')
                            : (isNe
                                ? 'उद्धार टोलीको ध्यान आकर्षण गर्न यो साइरन बजाउनुहोस्।'
                                : 'Use this beacon to signal rescue teams in darkness or debris.'),
                        style: TextStyle(
                          color: isLightBackground ? Colors.black : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: _toggleSiren,
                  child: AnimatedBuilder(
                    animation: _radarController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_isActive)
                            Container(
                              width: 220 + (_radarController.value * 60),
                              height: 220 + (_radarController.value * 60),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (_mode == 'POLICE' ? const Color(0xFFDC2626) : Colors.white)
                                    .withOpacity((1 - _radarController.value) * 0.4),
                              ),
                            ),
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isActive ? const Color(0xFFDC2626) : const Color(0xFF1E293B),
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isActive ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                                  size: 52,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _isActive
                                      ? (isNe ? 'रोक्नुहोस्' : 'STOP')
                                      : (isNe ? 'सुरु गर्नुहोस्' : 'START BEACON'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLightBackground ? Colors.black.withOpacity(0.08) : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      isNe ? 'मोड चयन गर्नुहोस् (Signal Mode)' : 'Select Signal Mode',
                      style: TextStyle(
                        color: isLightBackground ? Colors.black87 : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildModeOption('POLICE', isNe ? 'पुलिस स्ट्रोब' : 'Police', Icons.local_police_rounded),
                        const SizedBox(width: 8),
                        _buildModeOption('SOS_MORSE', isNe ? 'मोर्स SOS' : 'Morse SOS', Icons.flash_on_rounded),
                        const SizedBox(width: 8),
                        _buildModeOption('WHITE_STROBE', isNe ? 'सेतो फ्ल्यास' : 'Strobe', Icons.wb_sunny_rounded),
                      ],
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

  Widget _buildModeOption(String id, String title, IconData icon) {
    final sel = _mode == id;
    final isLight = _currentColor == Colors.white;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_isActive) _stopSiren();
          setState(() => _mode = id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: sel
                ? const Color(0xFF2563EB)
                : (isLight ? Colors.black12 : Colors.white12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: sel ? Colors.white : Colors.transparent),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: Colors.white),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}