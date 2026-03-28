// lib/features/onboarding/presentation/screens/registration_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/app_router.dart';
import '../../domain/onboarding_models.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, required this.userType});

  final UserType userType;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Common
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  // Private user
  String _supportFor = 'Myself';
  final List<String> _areasOfConcern = [];

  // Family member
  String? _relationship;
  final _notesCtrl = TextEditingController();

  // Support community
  final _orgNameCtrl = TextEditingController();
  String? _orgType;
  final _addressCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final List<String> _services = [];

  bool _obscurePassword = true;
  bool _isLoading = false;

  static const List<String> _areasOptions = [
    'Alcohol',
    'Drugs',
    'Tobacco',
    'Gambling',
    'Gaming',
    'Mental Health',
    'Social Media',
    'Other',
  ];

  static const List<String> _relationshipOptions = [
    'Parent',
    'Spouse / Partner',
    'Child',
    'Sibling',
    'Friend',
    'Other',
  ];

  static const List<String> _orgTypes = [
    'NGO',
    'Hospital',
    'Rehab Centre',
    'Community Centre',
    'Government Body',
    'Other',
  ];

  static const List<String> _serviceOptions = [
    'Counselling',
    'De-addiction Treatment',
    'Rehabilitation',
    'Awareness Programmes',
    'Support Groups',
    'Helpline',
    'Legal Aid',
    'Vocational Training',
  ];

  String get _screenTitle {
    switch (widget.userType) {
      case UserType.privateUser:
        return 'Create your account';
      case UserType.familyMember:
        return 'Family member setup';
      case UserType.supportCommunity:
        return 'Register organisation';
    }
  }

  String get _screenSubtitle {
    switch (widget.userType) {
      case UserType.privateUser:
        return 'Your data stays private and secure.';
      case UserType.familyMember:
        return 'Help us personalise the experience.';
      case UserType.supportCommunity:
        return 'Tell us about your organisation.';
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (widget.userType == UserType.supportCommunity) {
      context.go(Routes.communityDashboard, extra: _orgNameCtrl.text.trim());
    } else {
      context.go(Routes.tracker);
    }
  }


  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _locationCtrl.dispose();
    _passwordCtrl.dispose();
    _notesCtrl.dispose();
    _orgNameCtrl.dispose();
    _addressCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AarohaColors.background,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AarohaConstants.space24,
          ),
          children: [
            // ── Header ──────────────────────────────────────
            _buildHeader(),
            const SizedBox(height: AarohaConstants.space32),

            // ── Role badge ──────────────────────────────────
            _buildRoleBadge(),
            const SizedBox(height: AarohaConstants.space32),

            // ── Form fields based on type ────────────────────
            if (widget.userType == UserType.supportCommunity) ...[
              _buildCommunityForm(),
            ] else ...[
              _buildCommonForm(),
              const SizedBox(height: AarohaConstants.space24),
              if (widget.userType == UserType.privateUser)
                _buildPrivateUserExtras()
              else
                _buildFamilyMemberExtras(),
            ],

            const SizedBox(height: AarohaConstants.space40),

            // ── Submit ──────────────────────────────────────
            _buildSubmitButton(),
            const SizedBox(height: AarohaConstants.space32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _screenTitle,
          style: AarohaTextStyles.headlineSm.copyWith(
            color: AarohaColors.onSurface,
          ),
        ),
        const SizedBox(height: AarohaConstants.space6),
        Text(
          _screenSubtitle,
          style: AarohaTextStyles.bodyLg.copyWith(
            color: AarohaColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleBadge() {
    final (IconData icon, String label, Color color) = switch (widget.userType) {
      UserType.privateUser => (
          Icons.person_outline_rounded,
          'Private User',
          AarohaColors.primary,
        ),
      UserType.familyMember => (
          Icons.family_restroom_rounded,
          'Family Member',
          const Color(0xFF50625D),
        ),
      UserType.supportCommunity => (
          Icons.groups_2_rounded,
          'Support Community',
          AarohaColors.primaryContainer,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AarohaConstants.space16,
        vertical: AarohaConstants.space12,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AarohaConstants.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: AarohaConstants.space8),
          Text(
            label,
            style: AarohaTextStyles.labelMd.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: 'Personal details'),
        const SizedBox(height: AarohaConstants.space16),
        _Field(
          controller: _nameCtrl,
          label: 'Full Name',
          hint: 'Your full name',
          icon: Icons.person_outline_rounded,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Name is required' : null,
        ),
        const SizedBox(height: AarohaConstants.space16),
        _Field(
          controller: _phoneCtrl,
          label: 'Phone Number',
          hint: '+91 98765 43210',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (v) =>
              (v == null || v.trim().length < 10) ? 'Enter a valid number' : null,
        ),
        const SizedBox(height: AarohaConstants.space16),
        _Field(
          controller: _emailCtrl,
          label: 'Email',
          hint: 'you@example.com',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          optional: true,
        ),
        const SizedBox(height: AarohaConstants.space16),
        _Field(
          controller: _locationCtrl,
          label: 'Location',
          hint: 'City, State',
          icon: Icons.location_on_outlined,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Location is required' : null,
        ),
        const SizedBox(height: AarohaConstants.space16),
        _PasswordField(
          controller: _passwordCtrl,
          obscure: _obscurePassword,
          onToggle: () =>
              setState(() => _obscurePassword = !_obscurePassword),
        ),
      ],
    );
  }

  Widget _buildPrivateUserExtras() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: 'Support preferences', optional: true),
        const SizedBox(height: AarohaConstants.space16),
        _RadioGroup(
          label: 'Seeking support for',
          options: const ['Myself', 'Someone else'],
          selected: _supportFor,
          onChanged: (v) => setState(() => _supportFor = v),
        ),
        const SizedBox(height: AarohaConstants.space20),
        _ChipGroup(
          label: 'Areas of concern',
          options: _areasOptions,
          selected: _areasOfConcern,
          onChanged: (list) => setState(() {
            _areasOfConcern
              ..clear()
              ..addAll(list);
          }),
          optional: true,
        ),
      ],
    );
  }

  Widget _buildFamilyMemberExtras() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: 'About your connection'),
        const SizedBox(height: AarohaConstants.space16),
        _DropdownField(
          label: 'Your relationship',
          hint: 'Select relationship',
          options: _relationshipOptions,
          value: _relationship,
          onChanged: (v) => setState(() => _relationship = v),
        ),
        const SizedBox(height: AarohaConstants.space16),
        _Field(
          controller: _notesCtrl,
          label: 'Additional notes',
          hint: 'Any context that might help us personalise…',
          icon: Icons.notes_rounded,
          maxLines: 3,
          optional: true,
        ),
      ],
    );
  }

  Widget _buildCommunityForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: 'Organisation details'),
        const SizedBox(height: AarohaConstants.space16),
        _Field(
          controller: _orgNameCtrl,
          label: 'Organisation Name',
          hint: 'e.g. Nasha Mukti Kendra',
          icon: Icons.business_outlined,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Name required' : null,
        ),
        const SizedBox(height: AarohaConstants.space16),
        _DropdownField(
          label: 'Organisation Type',
          hint: 'Select type',
          options: _orgTypes,
          value: _orgType,
          onChanged: (v) => setState(() => _orgType = v),
        ),
        const SizedBox(height: AarohaConstants.space16),
        _Field(
          controller: _addressCtrl,
          label: 'Address',
          hint: 'Full address',
          icon: Icons.location_on_outlined,
          maxLines: 2,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Address required' : null,
        ),
        const SizedBox(height: AarohaConstants.space16),
        _Field(
          controller: _contactCtrl,
          label: 'Contact Number',
          hint: '+91 98765 43210',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (v) =>
              (v == null || v.trim().length < 10) ? 'Enter valid number' : null,
        ),
        const SizedBox(height: AarohaConstants.space16),
        _Field(
          controller: _emailCtrl,
          label: 'Official Email',
          hint: 'contact@yourorg.in',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          optional: true,
        ),
        const SizedBox(height: AarohaConstants.space16),
        _PasswordField(
          controller: _passwordCtrl,
          obscure: _obscurePassword,
          onToggle: () =>
              setState(() => _obscurePassword = !_obscurePassword),
        ),
        const SizedBox(height: AarohaConstants.space24),
        _SectionLabel(label: 'Services provided'),
        const SizedBox(height: AarohaConstants.space16),
        _ChipGroup(
          label: 'Select all that apply',
          options: _serviceOptions,
          selected: _services,
          onChanged: (list) => setState(() {
            _services
              ..clear()
              ..addAll(list);
          }),
        ),
        const SizedBox(height: AarohaConstants.space20),
        // Verification placeholder
        _VerificationPlaceholder(),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submit,
      child: _isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(AarohaColors.onPrimary),
              ),
            )
          : Text(
              widget.userType == UserType.supportCommunity
                  ? 'Register Organisation'
                  : 'Create Account',
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Private composite widgets
// ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, this.optional = false});

  final String label;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 16,
          decoration: BoxDecoration(
            color: AarohaColors.primary,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AarohaTextStyles.titleMd.copyWith(
            color: AarohaColors.onSurface,
          ),
        ),
        if (optional) ...[
          const SizedBox(width: 6),
          Text(
            '(optional)',
            style: AarohaTextStyles.labelSm.copyWith(
              color: AarohaColors.outline,
            ),
          ),
        ],
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.optional = false,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool optional;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: AarohaTextStyles.labelMd.copyWith(
                  color: AarohaColors.onSurfaceVariant,
                )),
            if (optional) ...[
              const SizedBox(width: 4),
              Text('(optional)',
                  style: AarohaTextStyles.labelSm.copyWith(
                    color: AarohaColors.outline,
                  )),
            ],
          ],
        ),
        const SizedBox(height: AarohaConstants.space8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: AarohaTextStyles.bodyLg
              .copyWith(color: AarohaColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null
                ? Icon(icon, color: AarohaColors.outline, size: 20)
                : null,
          ),
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password',
            style: AarohaTextStyles.labelMd.copyWith(
              color: AarohaColors.onSurfaceVariant,
            )),
        const SizedBox(height: AarohaConstants.space8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: (v) =>
              (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
          style: AarohaTextStyles.bodyLg
              .copyWith(color: AarohaColors.onSurface),
          decoration: InputDecoration(
            hintText: 'Create a password',
            prefixIcon: const Icon(Icons.lock_outline_rounded,
                color: AarohaColors.outline, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AarohaColors.outline,
                size: 20,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.hint,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final List<String> options;
  final String? value;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AarohaTextStyles.labelMd.copyWith(
              color: AarohaColors.onSurfaceVariant,
            )),
        const SizedBox(height: AarohaConstants.space8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint,
              style: AarohaTextStyles.bodyMd
                  .copyWith(color: AarohaColors.outline)),
          items: options
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: onChanged,
          style: AarohaTextStyles.bodyLg
              .copyWith(color: AarohaColors.onSurface),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.arrow_drop_down_circle_outlined,
                color: AarohaColors.outline, size: 20),
          ),
          dropdownColor: AarohaColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AarohaConstants.radiusMd),
        ),
      ],
    );
  }
}

class _RadioGroup extends StatelessWidget {
  const _RadioGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final List<String> options;
  final String selected;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AarohaTextStyles.labelMd.copyWith(
              color: AarohaColors.onSurfaceVariant,
            )),
        const SizedBox(height: AarohaConstants.space8),
        Row(
          children: options.map((opt) {
            final sel = selected == opt;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: opt != options.last ? AarohaConstants.space8 : 0),
                child: GestureDetector(
                  onTap: () => onChanged(opt),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0),
                    decoration: BoxDecoration(
                      color: sel
                          ? AarohaColors.primary.withOpacity(0.1)
                          : AarohaColors.surfaceContainerLow,
                      borderRadius:
                          BorderRadius.circular(AarohaConstants.radiusMd),
                      border: Border.all(
                        color: sel
                            ? AarohaColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(opt,
                          style: AarohaTextStyles.labelMd.copyWith(
                            color: sel
                                ? AarohaColors.primary
                                : AarohaColors.onSurfaceVariant,
                          )),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ChipGroup extends StatelessWidget {
  const _ChipGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.optional = false,
  });

  final String label;
  final List<String> options;
  final List<String> selected;
  final void Function(List<String>) onChanged;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: AarohaTextStyles.labelMd.copyWith(
                  color: AarohaColors.onSurfaceVariant,
                )),
            if (optional) ...[
              const SizedBox(width: 4),
              Text('(optional)',
                  style: AarohaTextStyles.labelSm.copyWith(
                    color: AarohaColors.outline,
                  )),
            ],
          ],
        ),
        const SizedBox(height: 10.0),
        Wrap(
          spacing: AarohaConstants.space8,
          runSpacing: AarohaConstants.space8,
          children: options.map((opt) {
            final sel = selected.contains(opt);
            return GestureDetector(
              onTap: () {
                final updated = List<String>.from(selected);
                if (sel) {
                  updated.remove(opt);
                } else {
                  updated.add(opt);
                }
                onChanged(updated);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: AarohaConstants.space16,
                  vertical: AarohaConstants.space8,
                ),
                decoration: BoxDecoration(
                  color: sel
                      ? AarohaColors.primary
                      : AarohaColors.surfaceContainerHigh,
                  borderRadius:
                      BorderRadius.circular(AarohaConstants.radiusFull),
                  border: Border.all(
                    color: sel
                        ? AarohaColors.primary
                        : AarohaColors.outlineVariant,
                  ),
                ),
                child: Text(
                  opt,
                  style: AarohaTextStyles.labelMd.copyWith(
                    color: sel
                        ? AarohaColors.onPrimary
                        : AarohaColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _VerificationPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AarohaConstants.space20),
      decoration: BoxDecoration(
        color: AarohaColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AarohaConstants.radiusLg),
        border: Border.all(
          color: AarohaColors.outlineVariant,
          style: BorderStyle.solid,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AarohaColors.surfaceContainerHighest,
              borderRadius:
                  BorderRadius.circular(AarohaConstants.radiusMd),
            ),
            child: const Icon(Icons.upload_file_outlined,
                color: AarohaColors.outline, size: 22),
          ),
          const SizedBox(width: AarohaConstants.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload verification document',
                  style: AarohaTextStyles.labelMd.copyWith(
                    color: AarohaColors.onSurface,
                  ),
                ),
                const SizedBox(height: AarohaConstants.space4),
                Text(
                  'Registration cert, trust deed, etc. (optional)',
                  style: AarohaTextStyles.bodySm.copyWith(
                    color: AarohaColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
