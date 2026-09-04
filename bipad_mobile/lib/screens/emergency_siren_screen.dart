import 'dart:async';
import 'package:flutter/material.dart';

class EmergencySirenScreen extends StatefulWidget {
  final bool isNe;
  const EmergencySirenScreen({super.key, required this.isNe});

  @override
  State<EmergencySirenScreen> createState() => _EmergencySirenScreenState();
}

class _EmergencySirenScreenState extends State<EmergencySirenScreen> {
  bool _isSirenActive = false;
  bool _isFlashActive = false;
  Timer? _strobeTimer;
  bool _strobeOn = false;

  void _toggleSiren() {
    setState(() {
      _isSirenActive = !_isSirenActive;
    });
  }

  void _toggleStrobe() {
    setState(() {
      _isFlashActive = !_isFlashActive;
      if (_isFlashActive) {
        _strobeTimer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
          if (mounted) setState(() => _strobeOn = !_strobeOn);
        });
      } else {
        _strobeTimer?.cancel();
        _strobeOn = false;
      }
    });
  }

  @override
  void dispose() {
    _strobeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;
    return Scaffold(
      backgroundColor: _strobeOn ? Colors.white : const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(
          isNe ? 'आपत्कालीन साइरन र बिकन' : 'SOS Siren & Beacon',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _strobeOn ? Colors.black : Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _strobeOn ? Colors.black : Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Siren Big Button
              GestureDetector(
                onTap: _toggleSiren,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isSirenActive ? const Color(0xFFDC2626) : const Color(0xFF1E293B),
                    boxShadow: _isSirenActive
                        ? [BoxShadow(color: Colors.red.withOpacity(0.6), blurRadius: 40, spreadRadius: 10)]
                        : [],
                    border: Border.all(color: Colors.redAccent, width: 3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isSirenActive ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                        color: Colors.white,
                        size: 56,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isSirenActive ? (isNe ? 'साइरन सक्रिय' : 'SIREN ON') : (isNe ? 'साइरन बजाउनुहोस्' : 'START SIREN'),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Visual Strobe Button
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: _isFlashActive ? const Color(0xFFEAB308) : const Color(0xFF334155),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: Icon(
                  Icons.flash_on_rounded,
                  color: _isFlashActive ? Colors.black : Colors.white,
                ),
                label: Text(
                  _isFlashActive
                      ? (isNe ? 'फ्ल्यासलाइट बन्द गर्नुहोस्' : 'STOP SOS STROBE')
                      : (isNe ? 'SOS फ्ल्यासलाइट सक्रिय' : 'START SOS STROBE'),
                  style: TextStyle(
                    color: _isFlashActive ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _toggleStrobe,
              ),
              const SizedBox(height: 16),
              Text(
                isNe
                    ? 'उद्धार टोलीलाई तपाईंको आवाज वा प्रकाशमार्फत स्थान पत्ता लगाउन मद्दत गर्दछ।'
                    : 'Emits an acoustic pulse and optical Morse SOS pattern for rescue teams.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: _strobeOn ? Colors.black87 : const Color(0xFF94A3B8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
