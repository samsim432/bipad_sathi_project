import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportHazardScreen extends StatefulWidget {
  final bool isNe;
  const ReportHazardScreen({super.key, required this.isNe});

  @override
  State<ReportHazardScreen> createState() => _ReportHazardScreenState();
}

class _ReportHazardScreenState extends State<ReportHazardScreen> {
  String _selectedHazard = 'FLOOD';
  final TextEditingController _descController = TextEditingController();
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  final Map<String, Map<String, String>> _hazardTypes = {
    'FLOOD': {'ne': 'बाढी (Flood)', 'en': 'Flood'},
    'LANDSLIDE': {'ne': 'पहिरो (Landslide)', 'en': 'Landslide'},
    'EARTHQUAKE': {'ne': 'भूकम्प (Earthquake)', 'en': 'Earthquake'},
    'ROAD_BLOCKED': {'ne': 'सडक अवरोध (Road Block)', 'en': 'Road Block'},
    'FIRE': {'ne': 'डढेलो / आगलागी (Fire)', 'en': 'Fire'},
    'ACCIDENT': {'ne': 'दुर्घटना (Accident)', 'en': 'Accident'},
  };

  Future<void> _pickImage() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (photo != null) {
      setState(() => _selectedImage = photo);
    }
  }

  void _submitReport() {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isNe ? 'कृपया विपद्को तस्बिर छनोट गर्नुहोस्' : 'Please select an incident photo'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isNe ? 'विपद् रिपोर्ट दर्ता भयो!' : 'Hazard report submitted!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNe ? 'विपद् रिपोर्ट गर्नुहोस्' : 'Report Hazard Incident'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isNe ? 'विपद्को प्रकार:' : 'Hazard Type:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedHazard,
                  isExpanded: true,
                  items: _hazardTypes.entries.map((e) {
                    return DropdownMenuItem<String>(
                      value: e.key,
                      child: Text(widget.isNe ? e.value['ne']! : e.value['en']!),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedHazard = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.isNe ? 'तस्बिर अपलोड गर्नुहोस्:' : 'Upload Incident Photo:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _selectedImage != null
                    ? (kIsWeb
                        ? Image.network(_selectedImage!.path, fit: BoxFit.cover)
                        : Image.file(File(_selectedImage!.path), fit: BoxFit.cover))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, size: 36, color: Colors.grey.shade400),
                          const SizedBox(height: 6),
                          Text(
                            widget.isNe ? 'तस्बिर छनोट गर्न यहाँ थिच्नुहोस्' : 'Tap to pick image',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.isNe ? 'विवरण (ऐच्छिक):' : 'Description (Optional):',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: widget.isNe ? 'घटनाको बारेमा केही लेख्नुहोस्...' : 'Describe what happened...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade800,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _isSubmitting ? null : _submitReport,
              child: _isSubmitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(
                      widget.isNe ? 'रिपोर्ट पठाउनुहोस्' : 'SUBMIT HAZARD REPORT',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}