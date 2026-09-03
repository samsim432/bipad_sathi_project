import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  final Function(String) onLanguageChange;
  final Locale currentLocale;

  const SplashScreen({
    super.key,
    required this.onLanguageChange,
    required this.currentLocale,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Scale & Fade Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Navigate to Main Screen after 2.2 seconds
    Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) =>
                MainNavigationContainer(
              onLanguageChange: widget.onLanguageChange,
              currentLocale: widget.currentLocale,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.currentLocale.languageCode == 'ne';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // Animated Center Logo
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Glowing Rounded Shield Badge
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFD32F2F),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD32F2F).withOpacity(0.35),
                            blurRadius: 28,
                            spreadRadius: 6,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shield_rounded,
                          size: 56,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // App Title
                    Text(
                      isNe ? 'विपद् साथी' : 'BIPAD SATHI',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Color(0xFF1E293B),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Subtitle Tagline
                    Text(
                      isNe
                          ? 'तपाईंको सुरक्षा, हाम्रो प्राथमिकता'
                          : 'Early Warning & Disaster Response Nepal',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Bottom Brand Footnote (like "from Meta")
            FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  children: [
                    Text(
                      isNe ? 'आपत्कालीन पूर्वसूचना प्रणाली' : 'EMERGENCY DISASTER NETWORK',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'NEPAL',
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}