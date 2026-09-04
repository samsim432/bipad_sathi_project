import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class DisasterMapScreen extends StatefulWidget {
  final bool isNe;
  const DisasterMapScreen({super.key, required this.isNe});

  @override
  State<DisasterMapScreen> createState() => _DisasterMapScreenState();
}

class _DisasterMapScreenState extends State<DisasterMapScreen>
    with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStream;

  // Real-time GPS State
  LatLng _userPosition = const LatLng(27.7172, 85.3240); // Default Kathmandu
  Position? _rawPosition;
  double _userHeading = 0.0;
  bool _hasLocationLock = false;
  double _currentZoom = 15.0;

  // UI States
  String _activeFilter = 'ALL';
  String _mapStyle = 'STREETS';

  // Animation controller for pulsing user location dot
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initPulseAnimation();
    _initLocationTracking();
  }

  void _initPulseAnimation() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 8.0, end: 28.0).animate(
      CurvedAnimation(parent: _pulseController!, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _pulseController?.dispose();
    super.dispose();
  }

  Future<void> _initLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    try {
      Position initialPos = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _rawPosition = initialPos;
          _userPosition = LatLng(initialPos.latitude, initialPos.longitude);
          _userHeading = initialPos.heading;
          _hasLocationLock = true;
        });
        _mapController.move(_userPosition, 15.5);
      }
    } catch (_) {}

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 3,
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position pos) {
        if (!mounted) return;
        setState(() {
          _rawPosition = pos;
          _userPosition = LatLng(pos.latitude, pos.longitude);
          _userHeading = pos.heading;
          _hasLocationLock = true;
        });
      },
    );
  }

  void _recenterMap() {
    _mapController.move(_userPosition, 16.0);
  }

  void _zoomIn() {
    _currentZoom = (_currentZoom + 1).clamp(3.0, 18.0);
    _mapController.move(_mapController.camera.center, _currentZoom);
  }

  void _zoomOut() {
    _currentZoom = (_currentZoom - 1).clamp(3.0, 18.0);
    _mapController.move(_mapController.camera.center, _currentZoom);
  }

  String _getTileUrl() {
    switch (_mapStyle) {
      case 'SATELLITE':
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case 'DARK':
        return 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png';
      case 'STREETS':
      default:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Map Layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userPosition,
              initialZoom: _currentZoom,
              onPositionChanged: (pos, hasGesture) {
                if (pos.zoom != null) _currentZoom = pos.zoom!;
              },
            ),
            children: [
              TileLayer(
                urlTemplate: _getTileUrl(),
                userAgentPackageName: 'com.bipad.emergency',
                maxZoom: 19,
              ),

              // Marker Layer (Clean GPS Puck)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _userPosition,
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () => _showUserLocationDetails(isNe),
                      child: _pulseAnimation == null
                          ? _buildStaticPuck()
                          : AnimatedBuilder(
                              animation: _pulseAnimation!,
                              builder: (context, child) {
                                final pulseVal = _pulseAnimation!.value;
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Pulsing radar ripple
                                    Container(
                                      width: pulseVal * 2,
                                      height: pulseVal * 2,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF2563EB).withOpacity(
                                          (1 - (pulseVal / 28.0)).clamp(0.0, 0.4),
                                        ),
                                      ),
                                    ),
                                    // Heading arrow/cone if moving
                                    if (_userHeading > 0)
                                      Transform.rotate(
                                        angle: (_userHeading * (math.pi / 180)),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            gradient: RadialGradient(
                                              colors: [
                                                const Color(0xFF2563EB).withOpacity(0.35),
                                                Colors.transparent,
                                              ],
                                              stops: const [0.2, 1.0],
                                            ),
                                          ),
                                        ),
                                      ),
                                    // Blue clickable core puck
                                    _buildStaticPuck(),
                                  ],
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 2. Top Header & Filters
          SafeArea(
            child: Column(
              children: [
                _buildTopSearchCard(isNe),
                const SizedBox(height: 8),
                _buildFloatingFilterRibbon(isNe),
              ],
            ),
          ),

          // 3. Side Controls
          Positioned(
            right: 16,
            bottom: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMapFloatingButton(
                  icon: Icons.layers_rounded,
                  onPressed: _showLayerSelectionModal,
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMiniIconButton(icon: Icons.add_rounded, onPressed: _zoomIn),
                      Container(height: 1, width: 28, color: const Color(0xFFF1F5F9)),
                      _buildMiniIconButton(icon: Icons.remove_rounded, onPressed: _zoomOut),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildMapFloatingButton(
                  icon: Icons.my_location_rounded,
                  iconColor: _hasLocationLock ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                  onPressed: _recenterMap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticPuck() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSearchCard(bool isNe) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
            onPressed: () => Navigator.maybePop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isNe ? 'आपत्कालीन लाइभ नक्सा' : 'Emergency Live Radar',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _hasLocationLock ? const Color(0xFF22C55E) : const Color(0xFFEAB308),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _hasLocationLock
                          ? (isNe ? 'प्रत्यक्ष जीपीएस सक्रिय' : 'Live GPS Connected')
                          : (isNe ? 'जीपीएस खोजी हुँदैछ...' : 'Searching for GPS...'),
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFFEE2E2),
            child: const Icon(Icons.notifications_active_outlined, color: Color(0xFFDC2626), size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingFilterRibbon(bool isNe) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip('ALL', isNe ? 'सबै विपद्' : 'All Incidents', Icons.grid_view_rounded),
          _buildFilterChip('FLOOD', isNe ? 'बाढी' : 'Floods', Icons.water_damage_rounded),
          _buildFilterChip('LANDSLIDE', isNe ? 'पहिरो' : 'Landslides', Icons.landslide_rounded),
          _buildFilterChip('SHELTER', isNe ? 'सुरक्षित आश्रय' : 'Shelters', Icons.home_filled),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label, IconData icon) {
    final isSelected = _activeFilter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => setState(() => _activeFilter = key),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Color(0x0D000000), blurRadius: 6, offset: Offset(0, 2)),
              ],
              border: Border.all(
                color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: isSelected ? Colors.white : const Color(0xFF64748B)),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapFloatingButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = const Color(0xFF1E293B),
  }) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: 22),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildMiniIconButton({required IconData icon, required VoidCallback onPressed}) {
    return SizedBox(
      width: 44,
      height: 42,
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF1E293B), size: 20),
        onPressed: onPressed,
      ),
    );
  }

  void _showLayerSelectionModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Map Style', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLayerOption('STREETS', 'Streets', Icons.map_outlined),
                  _buildLayerOption('SATELLITE', 'Satellite', Icons.satellite_alt_rounded),
                  _buildLayerOption('DARK', 'Carto Light', Icons.wb_twilight_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLayerOption(String type, String title, IconData icon) {
    final isSelected = _mapStyle == type;
    return GestureDetector(
      onTap: () {
        setState(() => _mapStyle = type);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                width: 2,
              ),
            ),
            child: Icon(icon, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B), size: 26),
          ),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  // --- LOCATION DETAILS BOTTOM SHEET ---
  void _showUserLocationDetails(bool isNe) {
    final lat = _userPosition.latitude.toStringAsFixed(6);
    final lng = _userPosition.longitude.toStringAsFixed(6);
    final accuracy = _rawPosition?.accuracy.toStringAsFixed(1) ?? 'N/A';
    final altitude = _rawPosition?.altitude.toStringAsFixed(1) ?? 'N/A';
    final coordsText = '$lat, $lng';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.my_location_rounded, color: Color(0xFF2563EB), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isNe ? 'तपाईंको वर्तमान स्थान' : 'Your Current Location',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        Text(
                          _hasLocationLock
                              ? (isNe ? 'सटीक जीपीएस सक्रिय' : 'Accurate GPS Signal Active')
                              : (isNe ? 'अनुमानित स्थान' : 'Approximate Location'),
                          style: TextStyle(
                            fontSize: 12,
                            color: _hasLocationLock ? const Color(0xFF16A34A) : const Color(0xFFEAB308),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Coordinates Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isNe ? 'निर्देशाङ्क (Coordinates)' : 'Coordinates',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                        Text(
                          coordsText,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    const Divider(height: 16, color: Color(0xFFE2E8F0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(isNe ? 'सटीकता (Accuracy)' : 'Accuracy', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        Text('±$accuracy m', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    ),
                    const Divider(height: 16, color: Color(0xFFE2E8F0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(isNe ? 'उचाइ (Altitude)' : 'Altitude', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        Text('$altitude m', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: Text(
                        isNe ? 'स्थान प्रतिलिपि गर्नुहोस्' : 'Copy Coordinates',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: coordsText));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isNe ? 'निर्देशाङ्क प्रतिलिपि भयो!' : 'Coordinates copied to clipboard!'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: const Color(0xFF16A34A),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.center_focus_strong_rounded, size: 20),
                    onPressed: () {
                      Navigator.pop(context);
                      _recenterMap();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}