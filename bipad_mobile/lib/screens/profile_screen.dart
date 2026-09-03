import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final bool isNe;
  const ProfileScreen({super.key, required this.isNe});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _municipalityController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  
  // Emergency Contact (Family)
  final TextEditingController _emergencyContactNameController = TextEditingController();
  final TextEditingController _emergencyContactPhoneController = TextEditingController();
  String _emergencyRelation = 'Family';

  // Medical / Accessibility Info
  String _selectedBloodGroup = 'A+';
  bool _hasDisability = false;
  final TextEditingController _disabilityNotesController = TextEditingController();

  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  final List<String> _relations = ['Parent (आमा/बुवा)', 'Spouse (श्रीमान/श्रीमती)', 'Sibling (दाजु/भाइ/दिदी/बहिनी)', 'Child (छोरा/छोरी)', 'Friend (साथी)'];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? '';
      _phoneController.text = prefs.getString('user_phone') ?? '';
      _emailController.text = prefs.getString('user_email') ?? '';
      _districtController.text = prefs.getString('user_district') ?? '';
      _municipalityController.text = prefs.getString('user_municipality') ?? '';
      _wardController.text = prefs.getString('user_ward') ?? '';
      
      _emergencyContactNameController.text = prefs.getString('emergency_name') ?? '';
      _emergencyContactPhoneController.text = prefs.getString('emergency_phone') ?? '';
      _emergencyRelation = prefs.getString('emergency_relation') ?? _relations.first;

      _selectedBloodGroup = prefs.getString('user_blood_group') ?? 'A+';
      _hasDisability = prefs.getBool('user_has_disability') ?? false;
      _disabilityNotesController.text = prefs.getString('user_disability_notes') ?? '';
    });
  }

  Future<void> _saveProfileData() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text.trim());
    await prefs.setString('user_phone', _phoneController.text.trim());
    await prefs.setString('user_email', _emailController.text.trim());
    await prefs.setString('user_district', _districtController.text.trim());
    await prefs.setString('user_municipality', _municipalityController.text.trim());
    await prefs.setString('user_ward', _wardController.text.trim());
    
    await prefs.setString('emergency_name', _emergencyContactNameController.text.trim());
    await prefs.setString('emergency_phone', _emergencyContactPhoneController.text.trim());
    await prefs.setString('emergency_relation', _emergencyRelation);

    await prefs.setString('user_blood_group', _selectedBloodGroup);
    await prefs.setBool('user_has_disability', _hasDisability);
    await prefs.setString('user_disability_notes', _disabilityNotesController.text.trim());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isNe ? 'तपाईंको प्रोफाइल विवरण सुरक्षित भयो!' : 'Emergency Profile Saved!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;

    return Scaffold(
      appBar: AppBar(
        title: Text(isNe ? 'मेरो आपत्कालीन प्रोफाइल' : 'Emergency Profile'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.privacy_tip_outlined, color: Colors.blue, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isNe
                          ? 'यो विवरण SOS थिच्दा मात्र उद्धार टोली, परिवार र ५ कि.मि वरपरका सहयोगीहरूलाई पठाइनेछ।'
                          : 'This info is used exclusively for instant auto-dispatching during SOS activations.',
                      style: const TextStyle(fontSize: 12, color: Colors.blueGrey, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            _buildSectionHeader(isNe ? 'व्यक्तिगत विवरण (Personal Details)' : 'Personal Details'),
            _buildTextField(_nameController, isNe ? 'पूरा नाम (Full Name) *' : 'Full Name *', isRequired: true),
            _buildTextField(_phoneController, isNe ? 'फोन नम्बर (Phone Number) *' : 'Phone Number *', keyboardType: TextInputType.phone, isRequired: true),
            _buildTextField(_emailController, isNe ? 'इमेल (Email)' : 'Email', keyboardType: TextInputType.emailAddress),

            const SizedBox(height: 18),
            _buildSectionHeader(isNe ? 'ठेगाना विवरण (Address Details)' : 'Address Details'),
            _buildTextField(_districtController, isNe ? 'जिल्ला (District) *' : 'District *', isRequired: true),
            Row(
              children: [
                Expanded(child: _buildTextField(_municipalityController, isNe ? 'पालिका (Municipality)' : 'Municipality')),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField(_wardController, isNe ? 'वडा नं (Ward No)' : 'Ward No', keyboardType: TextInputType.number)),
              ],
            ),

            const SizedBox(height: 18),
            _buildSectionHeader(isNe ? 'आकस्मिक सम्पर्क / परिवार (Family Emergency Contact)' : 'Family Emergency Contact'),
            _buildTextField(_emergencyContactNameController, isNe ? 'सम्पर्क व्यक्तिको नाम *' : 'Contact Person Name *', isRequired: true),
            _buildTextField(_emergencyContactPhoneController, isNe ? 'सम्पर्क व्यक्तिको फोन नम्बर *' : 'Contact Phone Number *', keyboardType: TextInputType.phone, isRequired: true),
            _buildDropdown(
              label: isNe ? 'नाता / सम्बन्ध (Relationship)' : 'Relationship',
              value: _emergencyRelation,
              items: _relations,
              onChanged: (val) => setState(() => _emergencyRelation = val!),
            ),

            const SizedBox(height: 18),
            _buildSectionHeader(isNe ? 'स्वास्थ्य तथा विशेष अवस्था (Medical & Accessibility)' : 'Medical & Accessibility'),
            _buildDropdown(
              label: isNe ? 'रक्त समूह (Blood Group)' : 'Blood Group',
              value: _selectedBloodGroup,
              items: _bloodGroups,
              onChanged: (val) => setState(() => _selectedBloodGroup = val!),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(isNe ? 'अशक्तता / विशेष हेरचाह आवश्यक?' : 'Disability / Special Assistance Needed?'),
              value: _hasDisability,
              onChanged: (val) => setState(() => _hasDisability = val),
            ),
            if (_hasDisability)
              _buildTextField(
                _disabilityNotesController,
                isNe ? 'विवरण (उदा: ह्वीलचेयर, आँखा नदेख्ने, आदि)' : 'Details (e.g., wheelchair, visually impaired)',
              ),

            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _saveProfileData,
              child: Text(
                isNe ? 'विवरण सुरक्षित गर्नुहोस् (SAVE PROFILE)' : 'SAVE EMERGENCY PROFILE',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isRequired = false, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: isRequired ? (val) => (val == null || val.trim().isEmpty) ? 'Required' : null : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        ),
      ),
    );
  }

  Widget _buildDropdown({required String label, required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : items.first,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}