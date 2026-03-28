// lib/features/onboarding/presentation/screens/community_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../domain/onboarding_models.dart';

class CommunityDashboardScreen extends StatefulWidget {
  const CommunityDashboardScreen({super.key, required this.orgName});

  final String orgName;

  @override
  State<CommunityDashboardScreen> createState() =>
      _CommunityDashboardScreenState();
}

class _CommunityDashboardScreenState extends State<CommunityDashboardScreen> {
  final List<AwarenessProgram> _programs = [];
  int _selectedIndex = 0;

  void _openAddProgramSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddProgramSheet(
        onAdd: (program) {
          setState(() => _programs.insert(0, program));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _DashboardTab(
            orgName: widget.orgName,
            programs: _programs,
            onAddProgram: _openAddProgramSheet,
          ),
          _ProfileTab(orgName: widget.orgName),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ─── Dashboard Tab ──────────────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  const _DashboardTab({
    required this.orgName,
    required this.programs,
    required this.onAddProgram,
  });

  final String orgName;
  final List<AwarenessProgram> programs;
  final VoidCallback onAddProgram;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Hero header ─────────────────────────────────────
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          backgroundColor: AarohaColors.primary,
          foregroundColor: AarohaColors.onPrimary,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: AarohaColors.heroGradientAngled,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AarohaConstants.space24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  AarohaColors.onPrimary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                  AarohaConstants.radiusMd),
                            ),
                            child: const Icon(Icons.groups_2_rounded,
                                color: AarohaColors.onPrimary, size: 22),
                          ),
                          const SizedBox(width: AarohaConstants.space12),
                          Expanded(
                            child: Text(
                              orgName,
                              style: AarohaTextStyles.titleLg.copyWith(
                                color: AarohaColors.onPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AarohaConstants.space16),
                      Text(
                        'Awareness Dashboard',
                        style: AarohaTextStyles.headlineSm.copyWith(
                          color: AarohaColors.onPrimary,
                        ),
                      ),
                      Text(
                        'Manage and publish your programmes',
                        style: AarohaTextStyles.bodyMd.copyWith(
                          color:
                              AarohaColors.onPrimary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Stats row ────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AarohaConstants.space24),
            child: Row(
              children: [
                _StatCard(
                  icon: Icons.event_rounded,
                  label: 'Total',
                  value: '${programs.length}',
                  color: AarohaColors.primary,
                ),
                const SizedBox(width: AarohaConstants.space12),
                _StatCard(
                  icon: Icons.upcoming_rounded,
                  label: 'Upcoming',
                  value: '${programs.where((p) => p.dateTime.isAfter(DateTime.now())).length}',
                  color: AarohaColors.primaryContainer,
                ),
                const SizedBox(width: AarohaConstants.space12),
                _StatCard(
                  icon: Icons.done_all_rounded,
                  label: 'Past',
                  value: '${programs.where((p) => p.dateTime.isBefore(DateTime.now())).length}',
                  color: AarohaColors.secondary,
                ),
              ],
            ),
          ),
        ),

        // ── Add button ───────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AarohaConstants.space24,
            ),
            child: ElevatedButton.icon(
              onPressed: onAddProgram,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Awareness Programme'),
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AarohaConstants.space24),
        ),

        // ── Programme list ───────────────────────────────────
        if (programs.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyState(onAdd: onAddProgram),
          )
        else ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AarohaConstants.space24,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Your Programmes',
                style: AarohaTextStyles.titleMd.copyWith(
                  color: AarohaColors.onSurface,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
              child: SizedBox(height: AarohaConstants.space12)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AarohaConstants.space24,
            ),
            sliver: SliverList.separated(
              itemCount: programs.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AarohaConstants.space12),
              itemBuilder: (_, i) =>
                  _ProgramCard(program: programs[i]),
            ),
          ),
          const SliverToBoxAdapter(
              child: SizedBox(height: AarohaConstants.space40)),
        ],
      ],
    );
  }
}

// ─── Stat Card ──────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AarohaConstants.space16),
        decoration: BoxDecoration(
          color: AarohaColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AarohaConstants.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: AarohaConstants.space8),
            Text(
              value,
              style: AarohaTextStyles.headlineSm.copyWith(color: color),
            ),
            Text(
              label,
              style: AarohaTextStyles.bodySm.copyWith(
                color: AarohaColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Programme Card ─────────────────────────────────────────────────────────

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.program});

  final AwarenessProgram program;

  @override
  Widget build(BuildContext context) {
    final isUpcoming = program.dateTime.isAfter(DateTime.now());
    final dateStr =
        DateFormat('d MMM yyyy  •  hh:mm a').format(program.dateTime);

    return Container(
      padding: const EdgeInsets.all(AarohaConstants.space20),
      decoration: BoxDecoration(
        color: AarohaColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AarohaConstants.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  program.title,
                  style: AarohaTextStyles.titleMd.copyWith(
                    color: AarohaColors.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AarohaConstants.space12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isUpcoming
                      ? AarohaColors.primary.withOpacity(0.1)
                      : AarohaColors.surfaceContainerHighest,
                  borderRadius:
                      BorderRadius.circular(AarohaConstants.radiusFull),
                ),
                child: Text(
                  isUpcoming ? 'Upcoming' : 'Past',
                  style: AarohaTextStyles.labelSm.copyWith(
                    color: isUpcoming
                        ? AarohaColors.primary
                        : AarohaColors.outline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AarohaConstants.space8),
          Text(
            program.description,
            style: AarohaTextStyles.bodyMd.copyWith(
              color: AarohaColors.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AarohaConstants.space12),
          _InfoRow(icon: Icons.schedule_rounded, text: dateStr),
          const SizedBox(height: 4),
          _InfoRow(
              icon: Icons.location_on_outlined, text: program.location),
          const SizedBox(height: 4),
          _InfoRow(icon: Icons.phone_outlined, text: program.contactInfo),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AarohaColors.outline),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: AarohaTextStyles.bodySm.copyWith(
              color: AarohaColors.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AarohaConstants.space40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AarohaColors.surfaceContainerLow,
                borderRadius:
                    BorderRadius.circular(AarohaConstants.radiusXl),
              ),
              child: const Icon(Icons.event_note_rounded,
                  color: AarohaColors.outline, size: 38),
            ),
            const SizedBox(height: AarohaConstants.space20),
            Text(
              'No programmes yet',
              style: AarohaTextStyles.titleMd.copyWith(
                color: AarohaColors.onSurface,
              ),
            ),
            const SizedBox(height: AarohaConstants.space8),
            Text(
              'Add your first awareness programme to start reaching people in need.',
              textAlign: TextAlign.center,
              style: AarohaTextStyles.bodyMd.copyWith(
                color: AarohaColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AarohaConstants.space24),
            OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Programme'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Tab ─────────────────────────────────────────────────────────────

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.orgName});

  final String orgName;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AarohaColors.background,
          automaticallyImplyLeading: false,
          title: Text('Organisation Profile',
              style: AarohaTextStyles.titleLg.copyWith(
                color: AarohaColors.primary,
              )),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AarohaConstants.space24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: const BoxDecoration(
                        gradient: AarohaColors.heroGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.groups_2_rounded,
                          color: AarohaColors.onPrimary, size: 40),
                    ),
                    const SizedBox(height: AarohaConstants.space16),
                    Text(
                      orgName,
                      style: AarohaTextStyles.headlineSm.copyWith(
                        color: AarohaColors.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AarohaConstants.space8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AarohaConstants.space12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AarohaColors.primary.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AarohaConstants.radiusFull),
                      ),
                      child: Text(
                        'Support Community',
                        style: AarohaTextStyles.labelSm.copyWith(
                          color: AarohaColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AarohaConstants.space32),
              _ProfileOption(
                icon: Icons.edit_outlined,
                label: 'Edit Organisation Details',
                onTap: () {},
              ),
              const SizedBox(height: AarohaConstants.space8),
              _ProfileOption(
                icon: Icons.verified_outlined,
                label: 'Verification Status',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AarohaConstants.space8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    borderRadius:
                        BorderRadius.circular(AarohaConstants.radiusFull),
                  ),
                  child: Text('Pending',
                      style: AarohaTextStyles.labelSm.copyWith(
                        color: const Color(0xFF856404),
                      )),
                ),
                onTap: () {},
              ),
              const SizedBox(height: AarohaConstants.space8),
              _ProfileOption(
                icon: Icons.notifications_outlined,
                label: 'Notification Settings',
                onTap: () {},
              ),
              const SizedBox(height: AarohaConstants.space8),
              _ProfileOption(
                icon: Icons.help_outline_rounded,
                label: 'Help & Support',
                onTap: () {},
              ),
              const SizedBox(height: AarohaConstants.space8),
              _ProfileOption(
                icon: Icons.logout_rounded,
                label: 'Sign Out',
                danger: true,
                onTap: () {},
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AarohaColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AarohaConstants.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AarohaConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AarohaConstants.space20,
            vertical: AarohaConstants.space16,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: danger ? AarohaColors.error : AarohaColors.onSurfaceVariant,
                size: 22,
              ),
              const SizedBox(width: AarohaConstants.space16),
              Expanded(
                child: Text(
                  label,
                  style: AarohaTextStyles.bodyLg.copyWith(
                    color: danger ? AarohaColors.error : AarohaColors.onSurface,
                  ),
                ),
              ),
              trailing ??
                  Icon(Icons.chevron_right_rounded,
                      color: AarohaColors.outline, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Add Programme Bottom Sheet ──────────────────────────────────────────────

class _AddProgramSheet extends StatefulWidget {
  const _AddProgramSheet({required this.onAdd});

  final void Function(AwarenessProgram) onAdd;

  @override
  State<_AddProgramSheet> createState() => _AddProgramSheetState();
}

class _AddProgramSheetState extends State<_AddProgramSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  DateTime? _selectedDateTime;
  bool _isLoading = false;

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (_, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme,
        ),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null || !mounted) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    widget.onAdd(AwarenessProgram(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      dateTime: _selectedDateTime!,
      location: _locationCtrl.text.trim(),
      contactInfo: _contactCtrl.text.trim(),
    ));

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AarohaColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AarohaConstants.space24,
            AarohaConstants.space24,
            AarohaConstants.space24,
            AarohaConstants.space24 + bottomInset,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AarohaColors.outlineVariant,
                        borderRadius:
                            BorderRadius.circular(AarohaConstants.radiusFull),
                      ),
                    ),
                  ),
                  const SizedBox(height: AarohaConstants.space20),
                  Text(
                    'New Awareness Programme',
                    style: AarohaTextStyles.headlineSm.copyWith(
                      color: AarohaColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AarohaConstants.space24),
                  _SheetField(
                    controller: _titleCtrl,
                    label: 'Programme Title',
                    hint: 'e.g. Free Addiction Counselling Camp',
                    icon: Icons.campaign_outlined,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AarohaConstants.space16),
                  _SheetField(
                    controller: _descCtrl,
                    label: 'Description',
                    hint: 'Describe what the programme involves…',
                    icon: Icons.notes_rounded,
                    maxLines: 3,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AarohaConstants.space16),
                  // Date-time picker
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date & Time',
                        style: AarohaTextStyles.labelMd.copyWith(
                          color: AarohaColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AarohaConstants.space8),
                      GestureDetector(
                        onTap: _pickDateTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AarohaConstants.space20,
                            vertical: AarohaConstants.space16,
                          ),
                          decoration: BoxDecoration(
                            color: AarohaColors.surfaceContainerHigh,
                            borderRadius:
                                BorderRadius.circular(AarohaConstants.radiusMd),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  color: AarohaColors.outline, size: 20),
                              const SizedBox(width: AarohaConstants.space12),
                              Text(
                                _selectedDateTime != null
                                    ? DateFormat('d MMM yyyy  •  hh:mm a')
                                        .format(_selectedDateTime!)
                                    : 'Select date and time',
                                style: AarohaTextStyles.bodyLg.copyWith(
                                  color: _selectedDateTime != null
                                      ? AarohaColors.onSurface
                                      : AarohaColors.outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AarohaConstants.space16),
                  _SheetField(
                    controller: _locationCtrl,
                    label: 'Location',
                    hint: 'Venue address or area',
                    icon: Icons.location_on_outlined,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AarohaConstants.space16),
                  _SheetField(
                    controller: _contactCtrl,
                    label: 'Contact Info',
                    hint: 'Phone number or email for enquiries',
                    icon: Icons.contact_phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AarohaConstants.space32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation(
                                  AarohaColors.onPrimary),
                            ),
                          )
                        : const Text('Publish Programme'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

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
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
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
