import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/disaster_map_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/missing_persons_screen.dart';

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

  void _toggleLanguage(String langCode) {
    setState(() {
      _locale = Locale(langCode);
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
      home: SplashScreen(
        onLanguageChange: _toggleLanguage,
        currentLocale: _locale,
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        indicatorColor: Colors.red.shade100,
        backgroundColor: Colors.white,
        elevation: 3,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: Colors.red),
            label: isNe ? 'गृहपृष्ठ' : 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map, color: Colors.red),
            label: isNe ? 'नक्सा' : 'Map',
          ),
          NavigationDestination(
            icon: const Icon(Icons.notifications_active_outlined),
            selectedIcon: const Icon(Icons.notifications_active, color: Colors.red),
            label: isNe ? 'सूचना' : 'Alerts',
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people, color: Colors.red),
            label: isNe ? 'खोजतलास' : 'Missing',
          ),
        ],
      ),
    );
  }
}