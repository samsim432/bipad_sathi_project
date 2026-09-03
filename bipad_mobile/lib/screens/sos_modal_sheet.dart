import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSModalSheet extends StatefulWidget {
  const SOSModalSheet({super.key});

  @override
  State<SOSModalSheet> createState() => _SOSModalSheetState();
}

class _SOSModalSheetState extends State<SOSModalSheet> {
  int _peopleCount = 1;
  bool _hasChildren = false;
  bool _hasElderly = false;
  bool _hasSpecialNeeds = false;
  bool _isLocating = false;

  Future<void> _sendSOS() async {
    setState(() => _isLocating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final Uri smsUri = Uri(
        scheme: 'sms',
        path: '100',
        queryParameters: <String, String>{
          'body': 'EMERGENCY SOS! Rescue Needed.\nCoords: https://maps.google.com/?q=${position.latitude},${position.longitude}\nPeople: $_peopleCount\nChildren: $_hasChildren, Elderly: $_hasElderly, SpecialNeeds: $_hasSpecialNeeds',
        },
      );

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('GPS: Lat ${position.latitude.toStringAsFixed(4)}, Lon ${position.longitude.toStringAsFixed(4)}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location: $e'), backgroundColor: Colors.orange),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLocating = false);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 14),
          const Text(
            'SOS - मलाई उद्धार चाहिन्छ (Rescue Me)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('व्यक्ति संख्या (People count):', style: TextStyle(fontSize: 14)),
              Row(
                children: [
                  IconButton(
                    onPressed: _peopleCount > 1 ? () => setState(() => _peopleCount--) : null,
                    icon: const Icon(Icons.remove_circle_outline, size: 24),
                  ),
                  Text('$_peopleCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => setState(() => _peopleCount++),
                    icon: const Icon(Icons.add_circle_outline, size: 24),
                  ),
                ],
              )
            ],
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('बालबालिका (Children)', style: TextStyle(fontSize: 13)),
            value: _hasChildren,
            onChanged: (v) => setState(() => _hasChildren = v ?? false),
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('वृद्धवृद्धा (Elderly)', style: TextStyle(fontSize: 13)),
            value: _hasElderly,
            onChanged: (v) => setState(() => _hasElderly = v ?? false),
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('विशेष सहयोग / घाइते (Injured / Special Aid)', style: TextStyle(fontSize: 13)),
            value: _hasSpecialNeeds,
            onChanged: (v) => setState(() => _hasSpecialNeeds = v ?? false),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _isLocating ? null : _sendSOS,
            child: _isLocating
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text(
                    'SOS पठाउनुहोस् (DISPATCH RESCUE)',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }
}