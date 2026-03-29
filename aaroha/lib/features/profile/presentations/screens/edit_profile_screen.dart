import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../data/profile_providers.dart';
import '../../domain/user_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameCtrl   = TextEditingController();
  final _formKey    = GlobalKey<FormState>();
  bool _loading = false;

  final _quittingOptions = ['Alcohol', 'Drugs', 'Tobacco / Nicotine', 'Gambling', 'Social Media', 'Gaming', 'Other'];
  final _importanceOptions = ['Critical', 'Very', 'Somewhat', 'Nice to have'];
  final _goalOptions = [
    'Improve mental health', 'Take control of my life', 'Address health concerns',
    'Improve relationships', 'Feel proud of who I am', 'Sleep better', 'Save money', 'Other',
  ];

  late String _selectedQuitting;
  late String _selectedImportance;
  late List<String> _selectedGoals;
  late String _morningTime;
  late String _eveningTime;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameCtrl.text      = user.name;
    _selectedQuitting   = _quittingOptions.contains(user.quitting) ? user.quitting : _quittingOptions.first;
    _selectedImportance = _importanceOptions.contains(user.sobrietyImportance) ? user.sobrietyImportance : 'Very';
    _selectedGoals      = List<String>.from(user.improvementGoals);
    _morningTime        = user.morningCheckIn;
    _eveningTime        = user.eveningCheckIn;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final user = ref.read(userProvider);
    final updated = UserModel(
      name:                _nameCtrl.text.trim(),
      quitting:            _selectedQuitting,
      userType:            user.userType,
      soberStartDate:      user.soberStartDate,
      morningCheckIn:      _morningTime,
      eveningCheckIn:      _eveningTime,
      improvementGoals:    _selectedGoals,
      sobrietyImportance:  _selectedImportance,
    );

    await ref.read(userProvider.notifier).save(updated);
    setState(() => _loading = false);
    HapticFeedback.mediumImpact();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved ✓')),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickTime(bool isMorning) async {
    final current = isMorning ? _morningTime : _eveningTime;
    final parts   = current.split(':');
    final initial = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));

    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;

    final formatted =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

    setState(() {
      if (isMorning) _morningTime = formatted;
      else           _eveningTime = formatted;
    });
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Edit Profile', style: AarohaTextStyles.titleLg.copyWith(
          color: AarohaColors.primary,
        )),
        actions: [
          // Save icon at top right
          IconButton(
            icon: _loading
                ? const SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AarohaColors.primary))
                : const Icon(Icons.save_rounded, color: AarohaColors.primary),
            tooltip: 'Save changes',
            onPressed: _loading ? null : _save,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // ── Name ──────────────────────────────────────────
            _sectionLabel('Display Name'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              style: AarohaTextStyles.bodyLg.copyWith(color: AarohaColors.onSurface),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Name cannot be empty' : null,
              decoration: const InputDecoration(
                hintText: 'Your name',
                prefixIcon: Icon(Icons.person_outline_rounded, color: AarohaColors.outline, size: 20),
              ),
            ),
            const SizedBox(height: 20),

            // ── Quitting ──────────────────────────────────────
            _sectionLabel('What are you quitting?'),
            const SizedBox(height: 8),
            ..._quittingOptions.map((opt) => _RadioTile(
              label: opt,
              selected: _selectedQuitting == opt,
              onTap: () => setState(() => _selectedQuitting = opt),
            )),
            const SizedBox(height: 20),

            // ── Sobriety importance ───────────────────────────
            _sectionLabel('Sobriety importance'),
            const SizedBox(height: 8),
            ..._importanceOptions.map((opt) => _RadioTile(
              label: opt,
              selected: _selectedImportance == opt,
              onTap: () => setState(() => _selectedImportance = opt),
            )),
            const SizedBox(height: 20),

            // ── Check-in times ────────────────────────────────
            _sectionLabel('Daily check-in times'),
            const SizedBox(height: 8),
            _TimePickerTile(
              icon: Icons.wb_sunny_rounded,
              label: 'Morning check-in',
              value: _morningTime,
              onTap: () => _pickTime(true),
            ),
            const SizedBox(height: 10),
            _TimePickerTile(
              icon: Icons.nights_stay_rounded,
              label: 'Evening check-in',
              value: _eveningTime,
              onTap: () => _pickTime(false),
            ),
            const SizedBox(height: 20),

            // ── Improvement goals ─────────────────────────────
            _sectionLabel('Goals to improve (up to 3)'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _goalOptions.map((opt) {
                final selected = _selectedGoals.contains(opt);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (selected) {
                      _selectedGoals.remove(opt);
                    } else if (_selectedGoals.length < 3) {
                      _selectedGoals.add(opt);
                    }
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AarohaColors.primary : AarohaColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(AarohaConstants.radiusFull),
                      border: Border.all(
                        color: selected ? AarohaColors.primary : AarohaColors.outlineVariant,
                      ),
                    ),
                    child: Text(opt, style: AarohaTextStyles.labelMd.copyWith(
                      color: selected ? AarohaColors.onPrimary : AarohaColors.onSurfaceVariant,
                    )),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),

            // ── Save button ───────────────────────────────────
            ElevatedButton.icon(
              onPressed: _loading ? null : _save,
              icon: _loading
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AarohaColors.onPrimary))
                  : const Icon(Icons.save_rounded),
              label: const Text('Save Changes'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(text,
    style: AarohaTextStyles.titleMd.copyWith(color: AarohaColors.onSurface));
}

// ── Radio tile ────────────────────────────────────────────────
class _RadioTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RadioTile({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AarohaColors.primary.withOpacity(0.08) : AarohaColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AarohaColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AarohaTextStyles.bodyLg.copyWith(
              color: selected ? AarohaColors.primary : AarohaColors.onSurface,
            ))),
            if (selected) const Icon(Icons.check_rounded, color: AarohaColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Time picker tile ──────────────────────────────────────────
class _TimePickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _TimePickerTile({required this.icon, required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AarohaColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: AarohaColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AarohaTextStyles.bodyLg.copyWith(
              color: AarohaColors.onSurface,
            ))),
            Text(value, style: AarohaTextStyles.titleMd.copyWith(
              color: AarohaColors.primary,
            )),
            const SizedBox(width: 8),
            const Icon(Icons.edit_rounded, color: AarohaColors.outline, size: 16),
          ],
        ),
      ),
    );
  }
}
