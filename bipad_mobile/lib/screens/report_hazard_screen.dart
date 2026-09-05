import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../hazard_feed_manager.dart';

class ReportHazardScreen extends StatefulWidget {
  final bool isNe;
  const ReportHazardScreen({super.key, required this.isNe});

  @override
  State<ReportHazardScreen> createState() => _ReportHazardScreenState();
}

class _ReportHazardScreenState extends State<ReportHazardScreen> {
  String _selectedHazard = 'FLOOD';
  String _selectedSeverity = 'HIGH';
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationNameController = TextEditingController();

  XFile? _selectedImage;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  bool _isSubmitting = false;
  bool _isFetchingGPS = false;
  Position? _currentPosition;

  final List<Map<String, dynamic>> _hazardCategories = [
    {
      'id': 'FLOOD',
      'label_en': 'Flood / Inundation',
      'label_ne': 'बाढी / डुबान',
      'icon': Icons.water_damage_rounded,
      'color': const Color(0xFF0284C7),
    },
    {
      'id': 'LANDSLIDE',
      'label_en': 'Landslide / Debris',
      'label_ne': 'पहिरो / गेग्रान',
      'icon': Icons.landslide_rounded,
      'color': const Color(0xFFDC2626),
    },
    {
      'id': 'ROAD_BLOCKED',
      'label_en': 'Road Blockage',
      'label_ne': 'सडक अवरोध',
      'icon': Icons.alt_route_rounded,
      'color': const Color(0xFFD97706),
    },
    {
      'id': 'FIRE',
      'label_en': 'Wildfire / Building',
      'label_ne': 'आगलागी / डढेलो',
      'icon': Icons.local_fire_department_rounded,
      'color': const Color(0xFFEA580C),
    },
    {
      'id': 'EARTHQUAKE',
      'label_en': 'Structural Damage',
      'label_ne': 'भूकम्प / क्षति',
      'icon': Icons.domain_disabled_rounded,
      'color': const Color(0xFF7C3AED),
    },
    {
      'id': 'ACCIDENT',
      'label_en': 'Accident / Other',
      'label_ne': 'दुर्घटना / अन्य',
      'icon': Icons.warning_rounded,
      'color': const Color(0xFF059669),
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  @override
  void dispose() {
    _descController.dispose();
    _locationNameController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() => _isFetchingGPS = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isFetchingGPS = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isFetchingGPS = false);
          return;
        }
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          _currentPosition = pos;
          _isFetchingGPS = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isFetchingGPS = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1280,
      );
      if (photo != null) {
        final bytes = await photo.readAsBytes();
        setState(() {
          _selectedImage = photo;
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load image: $e')),
        );
      }
    }
  }

  void _showImageSourcePicker() {
    final isNe = widget.isNe;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isNe ? 'तस्बिर स्रोत छान्नुहोस्' : 'Select Photo Source',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.camera_alt_rounded,
                      label: isNe ? 'क्यामेरा' : 'Camera',
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.photo_library_rounded,
                      label: isNe ? 'ग्यालरी' : 'Gallery',
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF8FAFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              Icon(icon, size: 28, color: const Color(0xFFDC2626)),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  void _submitReport() {
    final isNe = widget.isNe;

    if (_locationNameController.text.trim().isEmpty && _currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isNe ? 'कृपया स्थान वा GPS विवरण प्रदान गर्नुहोस्' : 'Please provide location or GPS details'),
          backgroundColor: const Color(0xFFEA580C),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(seconds: 1), () {
      final cat = _hazardCategories.firstWhere(
        (c) => c['id'] == _selectedHazard,
        orElse: () => _hazardCategories.first,
      );

      final newReport = HazardReportItem(
        id: 'HAZ-${DateTime.now().millisecondsSinceEpoch}',
        author: isNe ? 'नागरिक रिपोर्टर (Citizen)' : 'Citizen Reporter',
        title: _descController.text.trim().isNotEmpty
            ? _descController.text.trim()
            : (isNe ? '${cat['label_ne']} रिपोर्ट गरिएको छ' : '${cat['label_en']} incident reported'),
        location: _locationNameController.text.trim().isNotEmpty
            ? _locationNameController.text.trim()
            : (_currentPosition != null
                ? '${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}'
                : (isNe ? 'अज्ञात स्थान' : 'Unknown Location')),
        time: isNe ? 'भर्खरै' : 'Just now',
        hazardType: _selectedHazard,
        severity: _selectedSeverity,
        imageUrl: null,
        icon: cat['icon'] as IconData,
        color: cat['color'] as Color,
        upvotes: 1,
        downvotes: 0,
        userVote: 1,
        comments: [],
      );

      HazardFeedManager.instance.addReport(newReport);

      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isNe
                        ? 'विपद् घटना रिपोर्ट प्रत्यक्ष फिडमा प्रकाशित भयो!'
                        : 'Hazard report published to live community feed!',
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'विपद् घटना रिपोर्ट' : 'Report Hazard Incident',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notice Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isNe
                          ? 'तपाईंले पठाउनुभएको जानकारी प्रत्यक्ष विपद् नक्सामा प्रमाणिकरण गरी सार्वजनिक गरिनेछ।'
                          : 'Your report will be verified and published on the live crisis map for early response.',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF92400E), height: 1.35),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 1. Hazard Type Selector
            _buildSectionTitle(isNe ? 'विपद्को प्रकार (Select Hazard Type)' : 'Hazard Type'),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.05,
              ),
              itemCount: _hazardCategories.length,
              itemBuilder: (ctx, i) {
                final cat = _hazardCategories[i];
                final isSelected = _selectedHazard == cat['id'];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => _selectedHazard = cat['id']),
                    borderRadius: BorderRadius.circular(14),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: isSelected ? (cat['color'] as Color).withOpacity(0.08) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? (cat['color'] as Color) : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.8 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(cat['icon'], color: cat['color'], size: 24),
                          const SizedBox(height: 6),
                          Text(
                            isNe ? cat['label_ne'] : cat['label_en'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 22),

            // 2. Incident Photo Box
            _buildSectionTitle(isNe ? 'तस्बिर अपलोड गर्नुहोस् (Incident Photo)' : 'Incident Photo'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _showImageSourcePicker,
              child: Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _imageBytes != null ? const Color(0xFF16A34A) : const Color(0xFFCBD5E1),
                    width: 1.5,
                  ),
                ),
                child: _imageBytes != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.6),
                              radius: 16,
                              child: IconButton(
                                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                                onPressed: () => setState(() {
                                  _selectedImage = null;
                                  _imageBytes = null;
                                }),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add_a_photo_outlined, size: 26, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isNe ? 'तस्बिर लिन वा छनोट गर्न ट्याप गर्नुहोस्' : 'Tap to take photo or choose from gallery',
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isNe ? 'JPG / PNG (अधिकतम १० MB)' : 'JPG, PNG up to 10MB',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 22),

            // 3. Location & GPS Coordinates
            _buildSectionTitle(isNe ? 'घटनास्थल तथा GPS (Location)' : 'Location & GPS Tag'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _locationNameController,
                    decoration: InputDecoration(
                      hintText: isNe ? 'स्थान / सडक / वडा उल्लेख गर्नुहोस् (उदा: मुग्लिन नजिक)' : 'Specific landmark / road / locality',
                      prefixIcon: const Icon(Icons.place_outlined, size: 20, color: Color(0xFF64748B)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.my_location_rounded,
                                size: 16,
                                color: _currentPosition != null ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _isFetchingGPS
                                      ? (isNe ? 'GPS पत्ता लगाउँदै...' : 'Locking GPS...')
                                      : (_currentPosition != null
                                          ? '${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}'
                                          : (isNe ? 'GPS सक्रिय छैन' : 'No GPS Lock')),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: _isFetchingGPS ? null : _fetchCurrentLocation,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // 4. Severity Level
            _buildSectionTitle(isNe ? 'जोखिमको गम्भीरता (Severity Level)' : 'Hazard Severity Level'),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildSeverityChip('LOW', isNe ? 'सामान्य (Low)' : 'Low', const Color(0xFF16A34A)),
                const SizedBox(width: 8),
                _buildSeverityChip('MEDIUM', isNe ? 'मध्यम (Medium)' : 'Medium', const Color(0xFFEA580C)),
                const SizedBox(width: 8),
                _buildSeverityChip('HIGH', isNe ? 'उच्च (Critical)' : 'High / Critical', const Color(0xFFDC2626)),
              ],
            ),

            const SizedBox(height: 22),

            // 5. Additional Description
            _buildSectionTitle(isNe ? 'थप विवरण (Description)' : 'Additional Notes (Optional)'),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              maxLines: 3,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: isNe
                    ? 'उद्धार टोलीका लागि आवश्यक विवरण (उदा: गाडीहरू फसेका छन्, बाटो पूर्ण बन्द छ)'
                    : 'Add helpful context for dispatchers (e.g., casualties, vehicles stranded)...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              ),
            ),

            const SizedBox(height: 28),

            // 6. Submit Action Button
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 1,
              ),
              onPressed: _isSubmitting ? null : _submitReport,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(
                _isSubmitting
                    ? (isNe ? 'दर्ता हुँदैछ...' : 'Submitting Report...')
                    : (isNe ? 'रिपोर्ट दर्ता गर्नुहोस्' : 'SUBMIT HAZARD REPORT'),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 0.3),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0F172A),
      ),
    );
  }

  Widget _buildSeverityChip(String id, String label, Color color) {
    final isSelected = _selectedSeverity == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedSeverity = id),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? color : const Color(0xFFE2E8F0)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }
}