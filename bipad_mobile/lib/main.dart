import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/disaster_map_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/missing_persons_screen.dart';
import 'screens/sos_modal_sheet.dart';

void main() {
  runApp(const BipadSathiApp());
}

class BipadSathiApp extends StatefulWidget {
  const BipadSathiApp({super.key});

  @override
  State<BipadSathiApp> createState() => _BipadSathiAppState();
}

class _BipadSathiAppState extends State<BipadSathiApp> {
  Locale _locale = const Locale('ne');
  bool _showSplash = true;

  void _toggleLanguage(String langCode) {
    setState(() {
      _locale = Locale(langCode);
    });
  }

  void _finishSplash() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bipad Sathi',
      locale: _locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD32F2F),
          primary: const Color(0xFFD32F2F),
          secondary: const Color(0xFF1976D2),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 0.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
        ),
      ),
      home: _showSplash
          ? SplashScreen(
              currentLocale: _locale,
              onFinished: _finishSplash,
            )
          : MainNavigationContainer(
              currentLocale: _locale,
              onLanguageChange: _toggleLanguage,
            ),
    );
  }
}

class MainNavigationContainer extends StatefulWidget {
  final Function(String) onLanguageChange;
  final Locale currentLocale;

  const MainNavigationContainer({
    super.key,
    required this.onLanguageChange,
    required this.currentLocale,
  });

  @override
  State<MainNavigationContainer> createState() => _MainNavigationContainerState();
}

class _MainNavigationContainerState extends State<MainNavigationContainer> {
  int _currentIndex = 0;

  void _openSOSModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => const SOSModalSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.currentLocale.languageCode == 'ne';

    final List<Widget> pages = [
      HomeScreen(
        isNe: isNe,
        onLanguageChange: widget.onLanguageChange,
        onNavigate: (index) => setState(() => _currentIndex = index),
      ),
      DisasterMapScreen(isNe: isNe),
      AlertsFeedScreen(isNe: isNe),
      MissingPersonsScreen(isNe: isNe),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 1. Home
                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: isNe ? 'गृहपृष्ठ' : 'Home',
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                // 2. Map
                _buildNavItem(
                  icon: Icons.map_rounded,
                  label: isNe ? 'नक्सा' : 'Map',
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                // 3. Center SOS Button
                GestureDetector(
                  onTap: _openSOSModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE53935), Color(0xFFC62828)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD32F2F).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.emergency, color: Colors.white, size: 20),
                        SizedBox(width: 5),
                        Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 4. Alerts
                _buildNavItem(
                  icon: Icons.notifications_active_rounded,
                  label: isNe ? 'सूचना' : 'Alerts',
                  isSelected: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
                // 5. Missing
                _buildNavItem(
                  icon: Icons.people_alt_rounded,
                  label: isNe ? 'खोजतलास' : 'Missing',
                  isSelected: _currentIndex == 3,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? const Color(0xFFD32F2F) : Colors.grey.shade600,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFFD32F2F) : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}