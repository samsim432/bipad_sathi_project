import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FirstAidScreen extends StatefulWidget {
  final bool isNe;
  const FirstAidScreen({super.key, required this.isNe});

  @override
  State<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> with TickerProviderStateMixin {
  String _selectedCategory = 'CRITICAL';

  // CPR Metronome State
  bool _isCprRunning = false;
  int _cprCount = 0;
  int _cycleCount = 1;
  Timer? _cprTimer;
  late AnimationController _cprPulseController;

  @override
  void initState() {
    super.initState();
    // 105 Beats Per Minute = ~571ms per beat (AHA Guideline: 100-120 BPM)
    _cprPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 571),
    );
  }

  @override
  void dispose() {
    _cprTimer?.cancel();
    _cprPulseController.dispose();
    super.dispose();
  }

  void _toggleCPR() {
    if (_isCprRunning) {
      _cprTimer?.cancel();
      _cprPulseController.stop();
      setState(() {
        _isCprRunning = false;
        _cprCount = 0;
        _cycleCount = 1;
      });
    } else {
      setState(() => _isCprRunning = true);
      _cprPulseController.repeat(reverse: true);
      _cprTimer = Timer.periodic(const Duration(milliseconds: 571), (timer) {
        HapticFeedback.heavyImpact();
        setState(() {
          _cprCount++;
          if (_cprCount > 30) {
            _cprCount = 1;
            _cycleCount++;
            HapticFeedback.vibrate();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNe = widget.isNe;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isNe ? 'आकस्मिक प्राथमिक उपचार' : 'Emergency First Aid Guide',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. CPR Interactive Metronome Card
          _buildCprMetronomeCard(isNe),
          const SizedBox(height: 20),

          // 2. Category Selector
          _buildCategoryFilter(isNe),
          const SizedBox(height: 16),

          // 3. Protocol Guides
          if (_selectedCategory == 'CRITICAL') ...[
            _buildProtocolCard(
              title: isNe ? 'सर्पदंश (Snakebite Protocol)' : 'Snakebite Emergency',
              subtitle: isNe ? 'गोमन / करेत वा अन्य सर्पले टोकेमा तुरुन्त गर्नुपर्ने' : 'Critical steps for venomous bites in Nepal',
              icon: Icons.healing_rounded,
              accentColor: const Color(0xFFDC2626),
              dos: isNe
                  ? ['बिरामीलाई शान्त राख्ने र हलचल गर्न नदिने', 'टोकेको भागलाई मुटुको सतहभन्दा तल राख्ने', 'तुरुन्त नजिकको एन्टी-भेनम भएको अस्पताल पुर्‍याउने']
                  : ['Keep patient calm and completely still', 'Immobilize limb below heart level', 'Rush immediately to the nearest Anti-Venom facility'],
              donts: isNe
                  ? ['डोरी वा कपडाले कडा गरी नबाँध्ने (No Tourniquet)', 'ब्लेडले चिर्ने वा मुखले विष नचुस्ने', 'कुनै जडीबुटी वा झारफुकमा समय खेर नफाल्ने']
                  : ['Do NOT tie tight tourniquets', 'Do NOT cut or suck the wound', 'Do NOT delay transport for traditional healers'],
            ),
            const SizedBox(height: 14),
            _buildProtocolCard(
              title: isNe ? 'गम्भीर रक्तस्राव (Severe Bleeding)' : 'Severe Hemorrhage Control',
              subtitle: isNe ? 'पहिरो वा चोटपटकबाट अत्यधिक रगत बगेमा' : 'Immediate direct pressure and elevation',
              icon: Icons.water_drop_rounded,
              accentColor: const Color(0xFFEA580C),
              dos: isNe
                  ? ['सफा कपडाले घाउमा सिधै कडा दबाब दिने', 'रक्तस्राव भएको अंगलाई माथि उठाउने', 'रगत थामिएपछि मात्र ब्यान्डेज बाँध्ने']
                  : ['Apply direct firm pressure with clean cloth', 'Elevate wounded limb above heart level', 'Apply pressure bandage once bleeding slows'],
              donts: isNe
                  ? ['घाउमा टाँसिएको कपडा नहटाउने', 'घाउ भित्र पसेको वस्तु (फलाम/काठ) नझिक्ने']
                  : ['Do not remove deeply embedded objects', 'Do not clean extensive open wounds with raw water'],
            ),
          ] else ...[
            _buildProtocolCard(
              title: isNe ? 'हड्डी भाँचिएको (Fractures)' : 'Bone Fractures & Sprains',
              subtitle: isNe ? 'भूकम्प वा पहिरोमा थिचिएर हड्डी भाँचिएमा' : 'Immobilization and splinting guide',
              icon: Icons.accessibility_new_rounded,
              accentColor: const Color(0xFF2563EB),
              dos: isNe
                  ? ['भाँचिएको ठाउँलाई काठ वा कार्डबोर्डले स्प्लिन्ट बाँधेर अचल बनाउने', 'सुन्निन कम गर्न बरफ वा चिसो कपडा प्रयोग गर्ने']
                  : ['Immobilize fracture using rigid splints (wood/cardboard)', 'Keep patient still until stretcher arrives'],
              donts: isNe
                  ? ['भाँचिएको हड्डी आफैं सीधा बनाउने प्रयास नगर्ने', 'घाइतेलाई जबर्जस्ती हिँड्न नलगाउने']
                  : ['Do NOT try to realign broken bones manually', 'Do NOT move injured person without stabilization'],
            ),
            const SizedBox(height: 14),
            _buildProtocolCard(
              title: isNe ? 'आगोले पोलेको (Burns)' : 'Thermal Burns Protocol',
              subtitle: isNe ? 'आगो वा तातो पानीले पोलेको प्राथमिक उपचार' : 'Cooling and sterile protection',
              icon: Icons.local_fire_department_rounded,
              accentColor: const Color(0xFFD97706),
              dos: isNe
                  ? ['पोलेको ठाउँमा १०-१५ मिनेट चिसो पानी बगाउने', 'सफा सुक्खा कपडाले खुकुलो गरी ढाक्ने']
                  : ['Cool burn with clean running water for 10-15 mins', 'Cover loosely with sterile, clean cloth'],
              donts: isNe
                  ? ['बरफ, घिउ वा टुथपेस्ट कहिल्यै नलगाउने', 'पोलेर उठेको फोका नफुटाउने']
                  : ['Do NOT apply toothpaste, butter, or ice directly', 'Do NOT pop burn blisters'],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCprMetronomeCard(bool isNe) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFDC2626), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isNe ? 'सीपीआर रिदम (CPR Guide)' : 'CPR Chest Compression Beat',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        isNe ? '१०५ कम्प्रेसन प्रति मिनेट' : '105 BPM Audio-Haptic Pulse',
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              if (_isCprRunning)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(12)),
                  child: Text('Cycle: #$_cycleCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Pulsing Metronome Circle
          ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 1.15).animate(
              CurvedAnimation(parent: _cprPulseController, curve: Curves.easeInOut),
            ),
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isCprRunning ? const Color(0xFFDC2626) : const Color(0xFF1E293B),
                border: Border.all(color: Colors.white24, width: 3),
              ),
              child: Center(
                child: Text(
                  _isCprRunning ? '$_cprCount' : '30:2',
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isCprRunning
                ? (_cprCount >= 30 ? (isNe ? '२ पटक श्वास दिनुहोस् (Give 2 Breaths)' : 'Give 2 Rescue Breaths!') : (isNe ? 'छातीमा दबाब दिनुहोस् (Push Hard & Fast)' : 'Push hard & fast on center of chest'))
                : (isNe ? '३० पटक दबाब र २ पटक श्वासको चक्र' : '30 Compressions then 2 Breaths'),
            style: TextStyle(
              color: _isCprRunning && _cprCount >= 30 ? const Color(0xFFFBBF24) : Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Start/Stop Button
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: _isCprRunning ? const Color(0xFFEF4444) : const Color(0xFF2563EB),
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(_isCprRunning ? Icons.stop_rounded : Icons.play_arrow_rounded),
            label: Text(
              _isCprRunning ? (isNe ? 'रोक्नुहोस् (STOP)' : 'STOP METRONOME') : (isNe ? 'सीपीआर सुरु गर्नुहोस् (START)' : 'START CPR METRONOME'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _toggleCPR,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(bool isNe) {
    return Row(
      children: [
        _buildTabBtn('CRITICAL', isNe ? 'तत्काल ज्यान जोखिम (Critical)' : 'Life Threatening'),
        const SizedBox(width: 8),
        _buildTabBtn('TRAUMA', isNe ? 'चोटपटक तथा दुर्घटना' : 'Trauma & Burns'),
      ],
    );
  }

  Widget _buildTabBtn(String id, String label) {
    final sel = _selectedCategory == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategory = id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: sel ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: sel ? Colors.transparent : const Color(0xFFE2E8F0)),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: sel ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProtocolCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required List<String> dos,
    required List<String> donts,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: accentColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: accentColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          // DOs
          const Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: Color(0xFF16A34A), size: 16),
              SizedBox(width: 6),
              Text('के गर्ने (DOs)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF16A34A), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          ...dos.map((d) => Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(child: Text(d, style: const TextStyle(fontSize: 12, color: Color(0xFF334155)))),
                  ],
                ),
              )),
          const SizedBox(height: 10),
          // DONTs
          const Row(
            children: [
              Icon(Icons.cancel_outlined, color: Color(0xFFDC2626), size: 16),
              SizedBox(width: 6),
              Text('के नगर्ने (DON\'Ts)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFDC2626), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          ...donts.map((d) => Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(child: Text(d, style: const TextStyle(fontSize: 12, color: Color(0xFF334155)))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}