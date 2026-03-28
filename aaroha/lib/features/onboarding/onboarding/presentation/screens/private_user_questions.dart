// lib/features/onboarding/presentation/screens/private_user_questions.dart
//
// Flow for Private User:
//   Step 1 — Privacy consent
//   Step 2 — What are you quitting?
//   Step 3 — Sober start date
//   Step 4 — Days per week
//   Step 5 — Drinks per day
//   Step 6 — What to improve (up to 3)
//   Step 7 — How important is sobriety
//   Step 8 — Who to involve
//   Step 9 — Summary

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/app_router.dart';

// ─── Shared step scaffold ────────────────────────────────────

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.title,
    this.subtitle,
    required this.body,
    required this.onNext,
    this.nextEnabled = true,
    this.nextLabel = 'Next',
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final VoidCallback onNext;
  final bool nextEnabled;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      appBar: AppBar(
        backgroundColor: AarohaColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AarohaColors.onSurface),
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
                Text(title,
                    style: AarohaTextStyles.headlineSm
                        .copyWith(color: AarohaColors.onSurface)),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(subtitle!,
                      style: AarohaTextStyles.bodyMd
                          .copyWith(color: AarohaColors.onSurfaceVariant)),
                ],
              ],
            ),
          ),
          Container(height: 1, color: AarohaColors.outlineVariant),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: body,
            ),
          ),
          Container(height: 1, color: AarohaColors.outlineVariant),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: nextEnabled ? onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: nextEnabled
                      ? const Color(0xFF007A5E)
                      : AarohaColors.surfaceContainerHighest,
                  foregroundColor:
                      nextEnabled ? Colors.white : AarohaColors.outline,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(nextLabel,
                    style: AarohaTextStyles.labelLg.copyWith(
                        color: nextEnabled ? Colors.white : AarohaColors.outline,
                        fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 1: Privacy ─────────────────────────────────────────

class PrivacyConsentScreen extends StatelessWidget {
  const PrivacyConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF007A5E).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_rounded,
                    color: const Color(0xFF007A5E), size: 38),
              ),
              const SizedBox(height: 24),
              Text('Privacy is fundamental\nto sobriety',
                  textAlign: TextAlign.center,
                  style: AarohaTextStyles.headlineSm
                      .copyWith(color: AarohaColors.onSurface)),
              const SizedBox(height: 16),
              Text(
                'We use your data to generate anonymous statistics. We never share or sell your information.',
                textAlign: TextAlign.center,
                style: AarohaTextStyles.bodyLg
                    .copyWith(color: AarohaColors.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              Text(
                'By agreeing, you confirm you are at least 18 years of age.',
                textAlign: TextAlign.center,
                style: AarohaTextStyles.bodyLg
                    .copyWith(color: AarohaColors.onSurfaceVariant),
              ),
              const SizedBox(height: 28),
              Text('Is this okay with you?',
                  style: AarohaTextStyles.titleMd
                      .copyWith(color: AarohaColors.onSurface)),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const WhatQuittingScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007A5E),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Yes, We Are Good',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showDataInfo(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF007A5E),
                    minimumSize: const Size.fromHeight(56),
                    side: const BorderSide(
                        color: const Color(0xFF007A5E), width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('How we use your data'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go(Routes.userTypeSelection),
                child: Text('No, please don\'t',
                    style: AarohaTextStyles.bodyMd
                        .copyWith(color: AarohaColors.onSurfaceVariant)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showDataInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AarohaColors.outlineVariant,
                      borderRadius: BorderRadius.circular(999))),
            ),
            const SizedBox(height: 20),
            Text('How we use your data',
                style: AarohaTextStyles.titleLg
                    .copyWith(color: AarohaColors.onSurface)),
            const SizedBox(height: 16),
            _infoRow(Icons.bar_chart_rounded, 'Anonymous statistics',
                'We aggregate data to understand recovery trends. Nothing is tied to your identity.'),
            const SizedBox(height: 12),
            _infoRow(Icons.lock_outline_rounded, 'Stored on your device',
                'Your personal data stays local unless you explicitly back it up.'),
            const SizedBox(height: 12),
            _infoRow(Icons.block_rounded, 'Never sold',
                'We do not sell, share or rent your data to any third party.'),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String body) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: AarohaColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AarohaColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AarohaTextStyles.labelMd
                      .copyWith(color: AarohaColors.onSurface)),
              const SizedBox(height: 2),
              Text(body,
                  style: AarohaTextStyles.bodyMd
                      .copyWith(color: AarohaColors.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Step 2: What are you quitting? ─────────────────────────

class WhatQuittingScreen extends StatefulWidget {
  const WhatQuittingScreen({super.key});

  @override
  State<WhatQuittingScreen> createState() => _WhatQuittingScreenState();
}

class _WhatQuittingScreenState extends State<WhatQuittingScreen> {
  String _search = '';
  String? _selected;

  static const Map<String, List<String>> _cats = {
    'Alcoholic drinks': [
      'Alcohol',
    ],
    'Drugs': [
      'Drugs',
    ],
    'Tobacco': [
      'Tobacco / Nicotine',
    ],
    'Technology': [
      'Social Media',
    ],
  };

  Map<String, List<String>> get _filtered {
    if (_search.isEmpty) return _cats;
    final q = _search.toLowerCase();
    final out = <String, List<String>>{};
    for (final e in _cats.entries) {
      final m = e.value.where((v) => v.toLowerCase().contains(q)).toList();
      if (m.isNotEmpty) out[e.key] = m;
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
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
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What are you quitting?',
                    style: AarohaTextStyles.headlineSm
                        .copyWith(color: AarohaColors.onSurface)),
                const SizedBox(height: 6),
                Text('You can add more later.',
                    style: AarohaTextStyles.bodyMd
                        .copyWith(color: AarohaColors.onSurfaceVariant)),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: AarohaTextStyles.bodyLg.copyWith(color: AarohaColors.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AarohaColors.outline, size: 20),
                    filled: true,
                    fillColor: AarohaColors.surfaceContainerHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: AarohaColors.outlineVariant),
          Expanded(
            child: ListView(
              children: [
                for (final entry in filtered.entries) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(entry.key,
                              style: AarohaTextStyles.labelMd.copyWith(
                                  color: const Color(0xFF007A5E))),
                        ),
                        const Icon(Icons.remove, color: AarohaColors.outline, size: 16),
                      ],
                    ),
                  ),
                  for (final item in entry.value)
                    InkWell(
                      onTap: () => setState(() => _selected = item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: AarohaColors.outlineVariant.withOpacity(0.5)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(item,
                                  style: AarohaTextStyles.bodyLg
                                      .copyWith(color: AarohaColors.onSurface)),
                            ),
                            if (_selected == item)
                              const Icon(Icons.check_rounded,
                                  color: const Color(0xFF007A5E), size: 20),
                          ],
                        ),
                      ),
                    ),
                ],
                const SizedBox(height: 80),
              ],
            ),
          ),
          Container(height: 1, color: AarohaColors.outlineVariant),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected != null
                    ? () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const SoberStartDateScreen()),
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selected != null
                      ? const Color(0xFF007A5E)
                      : AarohaColors.surfaceContainerHighest,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('Next',
                    style: TextStyle(
                        color: _selected != null
                            ? Colors.white
                            : AarohaColors.outline,
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

// ─── Step 3: Sober start date ────────────────────────────────

class SoberStartDateScreen extends StatefulWidget {
  const SoberStartDateScreen({super.key});

  @override
  State<SoberStartDateScreen> createState() => _SoberStartDateScreenState();
}

class _SoberStartDateScreenState extends State<SoberStartDateScreen> {
  DateTime _date = DateTime.now();

  Future<void> _pick() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'When was your sober start date?',
      onNext: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DaysPerWeekScreen())),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _pick,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: AarohaColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AarohaColors.outlineVariant),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(DateFormat('d MMMM yyyy').format(_date),
                        style: AarohaTextStyles.bodyLg
                            .copyWith(color: AarohaColors.onSurface)),
                  ),
                  const Icon(Icons.calendar_month_rounded,
                      color: const Color(0xFF007A5E), size: 22),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {},
            child: Text('Start tracking on a future date',
                style: AarohaTextStyles.bodyMd
                    .copyWith(color: const Color(0xFF007A5E))),
          ),
        ],
      ),
    );
  }
}

// ─── Step 4: Days per week ───────────────────────────────────

class DaysPerWeekScreen extends StatefulWidget {
  const DaysPerWeekScreen({super.key});

  @override
  State<DaysPerWeekScreen> createState() => _DaysPerWeekScreenState();
}

class _DaysPerWeekScreenState extends State<DaysPerWeekScreen> {
  int _days = 0;
  final List<bool> _sel = List.filled(7, true);

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'How many days per week did you drink?',
      subtitle: 'On average, before you started tracking.',
      onNext: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DrinksPerDayScreen())),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AarohaColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Center(
                    child: Text('$_days days',
                        style: AarohaTextStyles.titleMd
                            .copyWith(color: AarohaColors.onSurface)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _CircleBtn(
                  icon: Icons.remove,
                  onTap: () { if (_days > 0) setState(() => _days--); }),
              const SizedBox(width: 12),
              _CircleBtn(
                  icon: Icons.add,
                  onTap: () { if (_days < 7) setState(() => _days++); }),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              return GestureDetector(
                onTap: () => setState(() => _sel[i] = !_sel[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AarohaColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AarohaColors.outlineVariant),
                  ),
                  child: Center(
                    child: _sel[i]
                        ? const Icon(Icons.check_rounded,
                            color: AarohaColors.onSurfaceVariant, size: 18)
                        : Text(['M','T','W','T','F','S','S'][i],
                            style: AarohaTextStyles.labelMd.copyWith(
                                color: AarohaColors.onSurfaceVariant)),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── Step 5: Drinks per day ──────────────────────────────────

class DrinksPerDayScreen extends StatefulWidget {
  const DrinksPerDayScreen({super.key});

  @override
  State<DrinksPerDayScreen> createState() => _DrinksPerDayScreenState();
}

class _DrinksPerDayScreenState extends State<DrinksPerDayScreen> {
  int _drinks = 0;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'On days you drank, how many drinks did you have?',
      subtitle: 'On average, before you started tracking.',
      onNext: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ImprovementGoalsScreen())),
      body: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AarohaColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Center(
                child: Text('$_drinks drinks',
                    style: AarohaTextStyles.titleMd
                        .copyWith(color: AarohaColors.onSurface)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _CircleBtn(
              icon: Icons.remove,
              onTap: () { if (_drinks > 0) setState(() => _drinks--); }),
          const SizedBox(width: 12),
          _CircleBtn(
              icon: Icons.add,
              onTap: () => setState(() => _drinks++)),
        ],
      ),
    );
  }
}

// ─── Step 6: What to improve ─────────────────────────────────

class ImprovementGoalsScreen extends StatefulWidget {
  const ImprovementGoalsScreen({super.key});

  @override
  State<ImprovementGoalsScreen> createState() => _ImprovementGoalsScreenState();
}

class _ImprovementGoalsScreenState extends State<ImprovementGoalsScreen> {
  final List<String> _sel = [];

  static const _opts = [
    'Improve mental health','Take control of my life','Address health concerns',
    'Improve relationships','Deepen spiritual or religious life','Feel proud of who I am',
    'Increase productivity','Sleep better and have more energy','Handle legal responsibilities',
    'Discover new interests and hobbies','Save money','Other',
  ];

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'What would you like to improve in your life?',
      subtitle: 'Choose up to 3',
      nextEnabled: _sel.isNotEmpty,
      onNext: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SobrietyImportanceScreen())),
      body: Column(
        children: _opts.map((opt) {
          final sel = _sel.contains(opt);
          return _OptionRow(
            label: opt,
            selected: sel,
            onTap: () => setState(() {
              if (sel) { _sel.remove(opt); }
              else if (_sel.length < 3) { _sel.add(opt); }
            }),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Step 7: Sobriety importance ─────────────────────────────

class SobrietyImportanceScreen extends StatefulWidget {
  const SobrietyImportanceScreen({super.key});

  @override
  State<SobrietyImportanceScreen> createState() =>
      _SobrietyImportanceScreenState();
}

class _SobrietyImportanceScreenState extends State<SobrietyImportanceScreen> {
  String? _sel;

  static const _opts = [
    ('Critical', 'I need to change now'),
    ('Very', "It's a top focus for me"),
    ('Somewhat', "I'd like to improve this"),
    ('Nice to have', "I'm just exploring"),
  ];

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'How important is sobriety to you right now?',
      nextEnabled: _sel != null,
      onNext: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const OnboardingSummaryScreen())),
      body: Column(
        children: _opts.map((o) => _OptionRow(
          label: o.$1,
          subtitle: o.$2,
          selected: _sel == o.$1,
          onTap: () => setState(() => _sel = o.$1),
        )).toList(),
      ),
    );
  }
}

// ─── Step 8: Summary ─────────────────────────────────────────

class OnboardingSummaryScreen extends StatelessWidget {
  const OnboardingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('d MMMM yyyy').format(DateTime.now());
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF2D2B55), Color(0xFF3B2D6B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              const Text('💯', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 16),
              Text('Look at what you just did!',
                  style: AarohaTextStyles.headlineSm
                      .copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              Text("Here's what you just accomplished:",
                  style: AarohaTextStyles.bodyMd
                      .copyWith(color: Colors.white.withOpacity(0.7))),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    _Row('Named what you\'re quitting', 'Alcohol'),
                    _Row('Set your start date', today),
                    _Row('Defined your "why"', 'Making a healthy choice'),
                    _Row('Decided on who you\'re becoming', 'Making a healthy choice'),
                    _Row('Chose your first milestone', 'Weekend conquered'),
                    _Row('Identified what you want to improve', 'Motivation'),
                    _Row('Planned your daily check-ins', '08:00 and 20:00'),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go(Routes.tracker),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007A5E),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text("Let's Do This!",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(6)),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AarohaTextStyles.bodyLg.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                Text(value,
                    style: AarohaTextStyles.bodyMd
                        .copyWith(color: Colors.white.withOpacity(0.55))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared sub-widgets ──────────────────────────────────────

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });
  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: AarohaColors.outlineVariant.withOpacity(0.5)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Wrap(
                children: [
                  Text(label,
                      style: AarohaTextStyles.bodyLg
                          .copyWith(color: AarohaColors.onSurface)),
                  if (subtitle != null)
                    Text(' · $subtitle',
                        style: AarohaTextStyles.bodyMd.copyWith(
                            color: AarohaColors.onSurfaceVariant)),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_rounded,
                  color: const Color(0xFF007A5E), size: 20),
          ],
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AarohaColors.outlineVariant, width: 1.5),
        ),
        child: Icon(icon, color: AarohaColors.onSurfaceVariant, size: 20),
      ),
    );
  }
}
