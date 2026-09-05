import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../hazard_feed_manager.dart';

class DisasterMapScreen extends StatefulWidget {
  final bool isNe;
  const DisasterMapScreen({super.key, required this.isNe});

  @override
  State<DisasterMapScreen> createState() => _DisasterMapScreenState();
}

class _DisasterMapScreenState extends State<DisasterMapScreen> with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStream;

  LatLng _userPosition = const LatLng(27.7172, 85.3240);
  Position? _rawPosition;
  double _userHeading = 0.0;
  bool _hasLocationLock = false;
  double _currentZoom = 13.5;

  String _activeFilter = 'ALL';
  String _mapStyle = 'STREETS';

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initPulse();
    _initLocationTracking();
  }

  void _initPulse() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _pulseAnimation = Tween<double>(begin: 6.0, end: 24.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _pulseController.dispose();
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

    try {
      Position pos = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _rawPosition = pos;
          _userPosition = LatLng(pos.latitude, pos.longitude);
          _hasLocationLock = true;
        });
        _mapController.move(_userPosition, 14.0);
      }
    } catch (_) {}

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
    ).listen((Position pos) {
      if (!mounted) return;
      setState(() {
        _rawPosition = pos;
        _userPosition = LatLng(pos.latitude, pos.longitude);
        _userHeading = pos.heading;
        _hasLocationLock = true;
      });
    });
  }

  String _getTileUrl() {
    switch (_mapStyle) {
      case 'SATELLITE':
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case 'DARK':
        return 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png';
      default:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;
    final feedManager = HazardFeedManager.instance;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userPosition,
              initialZoom: _currentZoom,
              onPositionChanged: (pos, _) {
                if (pos.zoom != null) _currentZoom = pos.zoom!;
              },
            ),
            children: [
              TileLayer(
                urlTemplate: _getTileUrl(),
                userAgentPackageName: 'np.gov.bipad.mobile',
              ),

              // 1. Hazard Warning Radius Circles
              CircleLayer(
                circles: [
                  ...feedManager.reports.map(
                    (report) => CircleMarker(
                      point: report.position,
                      color: (report.color).withOpacity(0.2),
                      borderColor: report.color,
                      borderStrokeWidth: 2,
                      useRadiusInMeter: true,
                      radius: report.severity == HazardSeverity.critical ? 1200 : 600,
                    ),
                  ),
                ],
              ),

              // 2. Incident & Resource Markers
              MarkerLayer(
                markers: [
                  // User Puck
                  Marker(
                    point: _userPosition,
                    width: 50,
                    height: 50,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) => Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: _pulseAnimation.value * 2,
                            height: _pulseAnimation.value * 2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF2563EB).withOpacity((1 - (_pulseAnimation.value / 24.0)).clamp(0.0, 0.5)),
                            ),
                          ),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Active Hazard Markers
                  if (_activeFilter == 'ALL' || _activeFilter == 'FLOOD' || _activeFilter == 'LANDSLIDE')
                    ...feedManager.reports.map(
                      (h) => Marker(
                        point: h.position,
                        width: 44,
                        height: 44,
                        child: GestureDetector(
                          onTap: () => _showHazardDetailSheet(h, isNe),
                          child: Container(
                            decoration: BoxDecoration(
                              color: h.color,
                              shape: BoxShape.circle,
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(h.icon, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ),

                  // Safe Shelters
                  if (_activeFilter == 'ALL' || _activeFilter == 'SHELTER')
                    ...feedManager.shelters.map(
                      (s) => Marker(
                        point: s.position,
                        width: 44,
                        height: 44,
                        child: GestureDetector(
                          onTap: () => _showShelterDetailSheet(s, isNe),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF16A34A),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
                            ),
                            child: const Icon(Icons.night_shelter_rounded, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Header Bar
          SafeArea(
            child: Column(
              children: [
                _buildTopSearchCard(isNe),
                const SizedBox(height: 6),
                _buildFilterChips(isNe),
              ],
            ),
          ),

          // Floating Controls
          Positioned(
            right: 16,
            bottom: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMapButton(Icons.layers_outlined, () => _showMapTypeSheet()),
                const SizedBox(height: 10),
                _buildMapButton(Icons.my_location_rounded, () => _mapController.move(_userPosition, 15.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSearchCard(bool isNe) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10)],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
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
                  isNe ? 'आपत्कालीन प्रत्यक्ष नक्सा' : 'Live Emergency Radar',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  _hasLocationLock ? 'GPS Connected (High Accuracy)' : 'Finding location...',
                  style: TextStyle(fontSize: 10, color: _hasLocationLock ? Colors.green : Colors.orange),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(10)),
            child: const Text('RED ALERT', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isNe) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildChip('ALL', isNe ? 'सबै विपद्' : 'All', Icons.grid_view_rounded),
          _buildChip('LANDSLIDE', isNe ? 'पहिरो' : 'Landslides', Icons.landslide_rounded),
          _buildChip('FLOOD', isNe ? 'बाढी' : 'Floods', Icons.water_damage_rounded),
          _buildChip('SHELTER', isNe ? 'आश्रय स्थल' : 'Shelters', Icons.night_shelter_rounded),
        ],
      ),
    );
  }

  Widget _buildChip(String id, String title, IconData icon) {
    final sel = _activeFilter == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        avatar: Icon(icon, size: 14, color: sel ? Colors.white : Colors.black87),
        label: Text(title, style: TextStyle(color: sel ? Colors.white : Colors.black87, fontSize: 11)),
        selected: sel,
        selectedColor: const Color(0xFF0F172A),
        backgroundColor: Colors.white,
        onSelected: (_) => setState(() => _activeFilter = id),
      ),
    );
  }

  Widget _buildMapButton(IconData icon, VoidCallback tap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: IconButton(icon: Icon(icon, color: const Color(0xFF0F172A), size: 20), onPressed: tap),
    );
  }

  void _showHazardDetailSheet(HazardReportItem item, bool isNe) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: item.color.withOpacity(0.2), shape: BoxShape.circle),
                  child: Icon(item.icon, color: item.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('${item.location} • ${item.time}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Chip(
                  label: Text(item.isVerified ? 'प्रमाणित (Verified)' : 'नागरिक रिपोर्ट', style: const TextStyle(fontSize: 10)),
                  backgroundColor: item.isVerified ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('SEVERITY: ${item.severity.name.toUpperCase()}', style: const TextStyle(fontSize: 10, color: Colors.red)),
                  backgroundColor: const Color(0xFFFEE2E2),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0F172A), minimumSize: const Size(double.infinity, 44)),
              icon: const Icon(Icons.share_location_rounded, size: 18),
              label: Text(isNe ? 'निर्देशाङ्क प्रतिलिपि गर्नुहोस्' : 'Copy GPS Location'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: '${item.position.latitude}, ${item.position.longitude}'));
                Navigator.pop(ctx);
              },
            )
          ],
        ),
      ),
    );
  }

  void _showShelterDetailSheet(ShelterLocation shelter, bool isNe) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(shelter.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(shelter.address, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShelterStat('कुल क्षमता', '${shelter.capacity} जना'),
                _buildShelterStat('बाँकी ठाउँ', '${shelter.availableBeds} बेड', isHighlight: true),
                _buildShelterStat('खानेपानी', shelter.hasWater ? 'उपलब्ध' : 'छैन'),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF16A34A)),
                    icon: const Icon(Icons.call_rounded),
                    label: const Text('सम्पर्क (Call)'),
                    onPressed: () => launchUrl(Uri(scheme: 'tel', path: shelter.contactPhone)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShelterStat(String label, String value, {bool isHighlight = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isHighlight ? Colors.green : Colors.black87),
        ),
      ],
    );
  }

  void _showMapTypeSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.map_outlined),
              title: const Text('OpenStreetMap (Standard)'),
              onTap: () {
                setState(() => _mapStyle = 'STREETS');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.satellite_alt_rounded),
              title: const Text('ArcGIS Satellite Imagery'),
              onTap: () {
                setState(() => _mapStyle = 'SATELLITE');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}