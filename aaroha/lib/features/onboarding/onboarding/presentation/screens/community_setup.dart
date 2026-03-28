// lib/features/onboarding/presentation/screens/community_setup.dart
//
// Flow for Support Community:
//   Step 1 — Organisation details (name, type, address, contact)
//   Step 2 — Services offered
//   Step 3 → Community Dashboard

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/app_router.dart';

class CommunitySetupScreen extends StatefulWidget {
  const CommunitySetupScreen({super.key});

  @override
  State<CommunitySetupScreen> createState() => _CommunitySetupScreenState();
}

class _CommunitySetupScreenState extends State<CommunitySetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  String? _orgType;
  bool _loading = false;

  static const _orgTypes = [
    'NGO', 'Hospital', 'Rehab Centre',
    'Community Centre', 'Government Body', 'Other'
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  void _next() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            CommunityServicesScreen(orgName: _nameCtrl.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      appBar: AppBar(
        backgroundColor: AarohaColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AarohaColors.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tell us about your organisation',
                      style: AarohaTextStyles.headlineSm
                          .copyWith(color: AarohaColors.onSurface)),
                  const SizedBox(height: 6),
                  Text('This helps people find you.',
                      style: AarohaTextStyles.bodyMd
                          .copyWith(color: AarohaColors.onSurfaceVariant)),
                ],
              ),
            ),
            Container(height: 1, color: AarohaColors.outlineVariant),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _lbl('Organisation Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameCtrl,
                    style: AarohaTextStyles.bodyLg.copyWith(color: AarohaColors.onSurface),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Nasha Mukti Kendra',
                      prefixIcon: Icon(Icons.business_outlined,
                          color: AarohaColors.outline, size: 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _lbl('Organisation Type'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _orgType,
                    hint: Text('Select type',
                        style: AarohaTextStyles.bodyMd
                            .copyWith(color: AarohaColors.outline)),
                    items: _orgTypes
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => setState(() => _orgType = v),
                    style: AarohaTextStyles.bodyLg
                        .copyWith(color: AarohaColors.onSurface),
                    dropdownColor: AarohaColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.category_outlined,
                          color: AarohaColors.outline, size: 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _lbl('Address'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressCtrl,
                    maxLines: 2,
                    style: AarohaTextStyles.bodyLg.copyWith(color: AarohaColors.onSurface),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    decoration: const InputDecoration(
                      hintText: 'Full address',
                      prefixIcon: Icon(Icons.location_on_outlined,
                          color: AarohaColors.outline, size: 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _lbl('Contact Number'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _contactCtrl,
                    keyboardType: TextInputType.phone,
                    style: AarohaTextStyles.bodyLg.copyWith(color: AarohaColors.onSurface),
                    validator: (v) =>
                        (v == null || v.trim().length < 10) ? 'Enter valid number' : null,
                    decoration: const InputDecoration(
                      hintText: '+91 98765 43210',
                      prefixIcon: Icon(Icons.phone_outlined,
                          color: AarohaColors.outline, size: 20),
                    ),
                  ),
                  // Verification placeholder
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AarohaColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AarohaColors.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                              color: AarohaColors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.upload_file_outlined,
                              color: AarohaColors.outline, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Upload verification document',
                                  style: AarohaTextStyles.labelMd
                                      .copyWith(color: AarohaColors.onSurface)),
                              const SizedBox(height: 2),
                              Text('Registration cert, trust deed, etc. (optional)',
                                  style: AarohaTextStyles.bodySm
                                      .copyWith(color: AarohaColors.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: AarohaColors.outlineVariant),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007A5E),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.white)))
                      : const Text('Next',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lbl(String t) => Text(t,
      style: AarohaTextStyles.labelMd
          .copyWith(color: AarohaColors.onSurfaceVariant));
}

// ─── Services Screen ─────────────────────────────────────────

class CommunityServicesScreen extends StatefulWidget {
  const CommunityServicesScreen({super.key, required this.orgName});
  final String orgName;

  @override
  State<CommunityServicesScreen> createState() =>
      _CommunityServicesScreenState();
}

class _CommunityServicesScreenState extends State<CommunityServicesScreen> {
  final List<String> _sel = [];

  static const _opts = [
    'Counselling', 'De-addiction Treatment', 'Rehabilitation',
    'Awareness Programmes', 'Support Groups', 'Helpline',
    'Legal Aid', 'Vocational Training',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      appBar: AppBar(
        backgroundColor: AarohaColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AarohaColors.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What services do you provide?',
                    style: AarohaTextStyles.headlineSm
                        .copyWith(color: AarohaColors.onSurface)),
                const SizedBox(height: 6),
                Text('Select all that apply.',
                    style: AarohaTextStyles.bodyMd
                        .copyWith(color: AarohaColors.onSurfaceVariant)),
              ],
            ),
          ),
          Container(height: 1, color: AarohaColors.outlineVariant),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _opts.map((opt) {
                  final sel = _sel.contains(opt);
                  return GestureDetector(
                    onTap: () => setState(
                        () => sel ? _sel.remove(opt) : _sel.add(opt)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: sel
                            ? AarohaColors.primary
                            : AarohaColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                            color: sel
                                ? AarohaColors.primary
                                : AarohaColors.outlineVariant),
                      ),
                      child: Text(opt,
                          style: AarohaTextStyles.labelMd.copyWith(
                              color: sel
                                  ? Colors.white
                                  : AarohaColors.onSurfaceVariant)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Container(height: 1, color: AarohaColors.outlineVariant),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sel.isNotEmpty
                    ? () => context.go(Routes.communityDashboard,
                        extra: widget.orgName)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _sel.isNotEmpty
                      ? const Color(0xFF007A5E)
                      : AarohaColors.surfaceContainerHighest,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text("Let's Go!",
                    style: TextStyle(
                        color:
                            _sel.isNotEmpty ? Colors.white : AarohaColors.outline,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
