import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class DisasterMapScreen extends StatefulWidget {
  final bool isNe;
  const DisasterMapScreen({super.key, required this.isNe});

  @override
  State<DisasterMapScreen> createState() => _DisasterMapScreenState();
}

class _DisasterMapScreenState extends State<DisasterMapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentPosition = const LatLng(27.7172, 85.3240);
  String _activeFilter = 'ALL';
  bool _isLoadingGPS = false;

  final List<Map<String, dynamic>> _mockMarkers = [
    {
      'type': 'FLOOD',
      'title': 'बागमती नदी जलसतह उच्च',
      'desc': 'Rautahat / Gaur area prone to flooding',
      'coords': const LatLng(27.7250, 85.3300),
      'color': Colors.blue,
      'icon': Icons.flood,
    },
    {
      'type': 'LANDSLIDE',
      'title': 'पहिरो अवरोध',
      'desc': 'Nagdhunga route partially obstructed',
      'coords': const LatLng(27.7080, 85.3100),
      'color': Colors.red,
      'icon': Icons.landslide,
    },
    {
      'type': 'SHELTER',
      'title': 'दशरथ रंगशाला सुरक्षित क्याम्प',
      'desc': 'Capacity: 1200 people | Water & Medical ready',
      'coords': const LatLng(27.6950, 85.3150),
      'color': Colors.green,
      'icon': Icons.home_work,
    },
  ];

  Future<void> _getUserLocation() async {
    setState(() => _isLoadingGPS = true);
    try {
      Position pos = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(pos.latitude, pos.longitude);
      });
      _mapController.move(_currentPosition, 14.5);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('GPS: $e'), backgroundColor: Colors.orange),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingGPS = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;
    final filteredMarkers = _mockMarkers.where((m) {
      if (_activeFilter == 'ALL') return true;
      return m['type'] == _activeFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isNe ? 'प्रत्यक्ष विपद् नक्सा' : 'Live Incident Map'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.samir.bipadmobile',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition,
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.my_location, color: Colors.indigo, size: 36),
                  ),
                  ...filteredMarkers.map(
                    (item) => Marker(
                      point: item['coords'],
                      width: 48,
                      height: 48,
                      child: GestureDetector(
                        onTap: () => _showMarkerDetails(item),
                        child: Container(
                          decoration: BoxDecoration(
                            color: item['color'],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4)],
                          ),
                          child: Icon(item['icon'], color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('ALL', isNe ? 'सबै (All)' : 'All'),
                  _buildFilterChip('FLOOD', isNe ? 'बाढी' : 'Floods'),
                  _buildFilterChip('LANDSLIDE', isNe ? 'पहिरो' : 'Landslides'),
                  _buildFilterChip('SHELTER', isNe ? 'आश्रय स्थल' : 'Shelters'),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _isLoadingGPS ? null : _getUserLocation,
              child: _isLoadingGPS
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.gps_fixed, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _activeFilter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        selectedColor: Colors.red.shade100,
        backgroundColor: Colors.white,
        onSelected: (val) => setState(() => _activeFilter = key),
      ),
    );
  }

  void _showMarkerDetails(Map<String, dynamic> item) {
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
                CircleAvatar(
                  backgroundColor: item['color'].withOpacity(0.2),
                  child: Icon(item['icon'], color: item['color']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item['title'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Text(item['desc'], style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: item['color'],
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.navigation, color: Colors.white),
              label: const Text('Navigate to Location', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }
}