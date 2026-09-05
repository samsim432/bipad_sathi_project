import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import '../hazard_feed_manager.dart';

class ReportHazardScreen extends StatefulWidget {
  final bool isNe;
  const ReportHazardScreen({super.key, required this.isNe});

  @override
  State<ReportHazardScreen> createState() => _ReportHazardScreenState();
}

class _ReportHazardScreenState extends State<ReportHazardScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _detailsController = TextEditingController();

  String _selectedHazard = 'LANDSLIDE';
  HazardSeverity _selectedSeverity = HazardSeverity.high;
  LatLng _incidentLocation = const LatLng(27.7172, 85.3240);
  bool _isLocating = false;
  bool _hasLocation = false;
  XFile? _pickedImage;

  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _hazardTypes = [
    {'type': 'LANDSLIDE', 'labelNe': 'पहिरो (Landslide)', 'icon': Icons.landslide_rounded, 'color': Color(0xFFDC2626)},
    {'type': 'FLOOD', 'labelNe': 'बाढी (Flood / Inundation)', 'icon': Icons.water_damage_rounded, 'color': Color(0xFF0284C7)},
    {'type': 'FIRE', 'labelNe': 'डढेलो / आगलागी (Fire)', 'icon': Icons.local_fire_department_rounded, 'color': Color(0xFFEA580C)},
    {'type': 'ROAD_BLOCK', 'labelNe': 'सडक अवरोध (Road Block)', 'icon': Icons.remove_road_rounded, 'color': Color(0xFFD97706)},
  ];

  @override
  void initState() {
    super.initState();
    _fetchLiveLocation();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _fetchLiveLocation() async {
    setState(() => _isLocating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 6),
      );
      if (mounted) {
        setState(() {
          _incidentLocation = LatLng(pos.latitude, pos.longitude);
          _hasLocation = true;
          if (_locationController.text.isEmpty) {
            _locationController.text = 'GPS: ${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}';
          }
        });
      }
    } catch (_) {} finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final img = await _picker.pickImage(source: source, imageQuality: 70);
      if (img != null) {
        setState(() => _pickedImage = img);
      }
    } catch (_) {}
  }

  void _submitReport() {
    final title = _titleController.text.trim();
    final location = _locationController.text.trim();

    if (title.isEmpty || location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isNe ? 'कृपया शीर्षक र स्थान भर्नुहोस्' : 'Please provide title and location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final selectedConfig = _hazardTypes.firstWhere((h) => h['type'] == _selectedHazard);

    final report = HazardReportItem(
      id: 'HAZ-${DateTime.now().millisecondsSinceEpoch % 10000}',
      author: 'Citizen Reporter (नागरिक)',
      title: title,
      location: location,
      position: _incidentLocation,
      time: 'Just now (भर्खरै)',
      hazardType: _selectedHazard,
      severity: _selectedSeverity,
      source: HazardSource.crowdsourced,
      imageUrl: _pickedImage?.path,
      icon: selectedConfig['icon'] as IconData,
      color: selectedConfig['color'] as Color,
      upvotes: 1,
      downvotes: 0,
      userVote: 1,
      comments: _detailsController.text.isNotEmpty
          ? [{'author': 'Reporter Note', 'text': _detailsController.text.trim(), 'time': 'Just now'}]
          : [],
    );

    HazardFeedManager.instance.addReport(report);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.isNe ? 'विपद् सूचना सफलतापूर्वक दर्ता भयो!' : 'Hazard report submitted!'),
        backgroundColor: const Color(0xFF16A34A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'विपद् घटना रिपोर्ट गर्नुहोस्' : 'Report Hazard / Incident',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Hazard Type Picker
          Text(isNe ? 'विपद्को प्रकार (Hazard Type)' : 'Select Hazard Type', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _hazardTypes.map((h) {
              final sel = _selectedHazard == h['type'];
              final Color color = h['color'];
              return ChoiceChip(
                avatar: Icon(h['icon'], size: 16, color: sel ? Colors.white : color),
                label: Text(h['labelNe'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: sel ? Colors.white : const Color(0xFF1E293B))),
                selected: sel,
                selectedColor: color,
                backgroundColor: Colors.white,
                onSelected: (_) => setState(() => _selectedHazard = h['type']),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),

          // 2. Incident Title & Location
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: isNe ? 'घटनाको शीर्षक (Short Summary)' : 'Incident Title',
              hintText: isNe ? 'उदा: पहिरो खसेर बाटो अवरुद्ध...' : 'e.g. Landslide blocking highway',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: isNe ? 'घटनास्थल / ठेगाना (Location)' : 'Location / Landmark',
              suffixIcon: IconButton(
                icon: _isLocating
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(Icons.my_location_rounded, color: _hasLocation ? const Color(0xFF16A34A) : const Color(0xFF64748B)),
                onPressed: _fetchLiveLocation,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // 3. Severity Level
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(isNe ? 'जोखिम तह (Severity)' : 'Severity Level', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                DropdownButton<HazardSeverity>(
                  value: _selectedSeverity,
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(value: HazardSeverity.low, child: Text(isNe ? 'न्यून (Low)' : 'Low', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                    DropdownMenuItem(value: HazardSeverity.medium, child: Text(isNe ? 'मध्यम (Medium)' : 'Medium', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
                    DropdownMenuItem(value: HazardSeverity.high, child: Text(isNe ? 'उच्च (High)' : 'High', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                    DropdownMenuItem(value: HazardSeverity.critical, child: Text(isNe ? 'अति जोखिम (Critical)' : 'Critical', style: const TextStyle(color: Color(0xFF991B1B), fontWeight: FontWeight.bold))),
                  ],
                  onChanged: (val) => setState(() => _selectedSeverity = val!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4. Photo Upload Card
          GestureDetector(
            onTap: () => _pickImage(ImageSource.camera),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
              ),
              child: _pickedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(File(_pickedImage!.path), fit: BoxFit.cover, width: double.infinity),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_a_photo_rounded, color: Color(0xFF64748B), size: 30),
                        const SizedBox(height: 6),
                        Text(
                          isNe ? 'घटनास्थलको फोटो खिच्नुहोस्' : 'Take Photo of Incident',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),

          // 5. Additional Details
          TextField(
            controller: _detailsController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: isNe ? 'थप विवरण (Additional Details)' : 'Additional Notes / Trapped status',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // 6. Submit Button
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.send_rounded, size: 18),
            label: Text(
              isNe ? 'विपद् सूचना पेश गर्नुहोस् (Submit Report)' : 'Submit Incident Report',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            onPressed: _submitReport,
          ),
        ],
      ),
    );
  }
}