// lib/features/onboarding/presentation/screens/family_questions.dart
//
// Flow for Family Member:
//   Step 1 — Relationship to person
//   Step 2 — What is the person struggling with?
//   Step 3 — How can you help?
//   Step 4 — Summary → App

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/app_router.dart';

// ─── Shared step scaffold (local copy) ──────────────────────

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.title,
    this.subtitle,
    required this.body,
    required this.onNext,
    this.nextEnabled = true,
  });
  final String title;
  final String? subtitle;
  final Widget body;
  final VoidCallback onNext;
  final bool nextEnabled;

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
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: AarohaTextStyles.headlineSm.copyWith(color: AarohaColors.onSurface)),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(subtitle!, style: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.onSurfaceVariant)),
              ],
            ]),
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
                  backgroundColor: nextEnabled ? const Color(0xFF007A5E) : AarohaColors.surfaceContainerHighest,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('Next',
                    style: TextStyle(
                        color: nextEnabled ? Colors.white : AarohaColors.outline,
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 1: Relationship ────────────────────────────────────

class FamilyRelationshipScreen extends StatefulWidget {
  const FamilyRelationshipScreen({super.key});

  @override
  State<FamilyRelationshipScreen> createState() =>
      _FamilyRelationshipScreenState();
}

class _FamilyRelationshipScreenState extends State<FamilyRelationshipScreen> {
  String? _sel;

  static const _opts = [
    ('Parent', Icons.escalator_warning_rounded),
    ('Spouse / Partner', Icons.favorite_outline_rounded),
    ('Child', Icons.child_care_rounded),
    ('Sibling', Icons.people_outline_rounded),
    ('Friend', Icons.person_outline_rounded),
    ('Other', Icons.more_horiz_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'What is your relationship to the person?',
      nextEnabled: _sel != null,
      onNext: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FamilyStruggleScreen())),
      body: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: _opts.map((o) {
          final sel = _sel == o.$1;
          return GestureDetector(
            onTap: () => setState(() => _sel = o.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: (MediaQuery.of(context).size.width - 72) / 2,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: sel
                    ? AarohaColors.primary.withOpacity(0.07)
                    : AarohaColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: sel ? AarohaColors.primary : Colors.transparent,
                    width: 2),
              ),
              child: Column(
                children: [
                  Icon(o.$2,
                      color: sel ? AarohaColors.primary : AarohaColors.onSurfaceVariant,
                      size: 28),
                  const SizedBox(height: 8),
                  Text(o.$1,
                      style: AarohaTextStyles.labelMd.copyWith(
                          color: sel ? AarohaColors.primary : AarohaColors.onSurface)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Step 2: What are they struggling with? ──────────────────

class FamilyStruggleScreen extends StatefulWidget {
  const FamilyStruggleScreen({super.key});

  @override
  State<FamilyStruggleScreen> createState() => _FamilyStruggleScreenState();
}

class _FamilyStruggleScreenState extends State<FamilyStruggleScreen> {
  final List<String> _sel = [];

  static const _opts = [
    'Alcohol', 'Drugs', 'Gambling', 'Gaming', 'Social Media',
    'Tobacco', 'Mental Health', 'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'What is the person struggling with?',
      subtitle: 'Select all that apply',
      nextEnabled: _sel.isNotEmpty,
      onNext: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FamilyHelpScreen())),
      body: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _opts.map((opt) {
          final sel = _sel.contains(opt);
          return GestureDetector(
            onTap: () => setState(() {
              sel ? _sel.remove(opt) : _sel.add(opt);
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: sel ? AarohaColors.primary : AarohaColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                    color: sel ? AarohaColors.primary : AarohaColors.outlineVariant),
              ),
              child: Text(opt,
                  style: AarohaTextStyles.labelMd.copyWith(
                      color: sel ? Colors.white : AarohaColors.onSurfaceVariant)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Step 3: How can you help? ───────────────────────────────

class FamilyHelpScreen extends StatefulWidget {
  const FamilyHelpScreen({super.key});

  @override
  State<FamilyHelpScreen> createState() => _FamilyHelpScreenState();
}

class _FamilyHelpScreenState extends State<FamilyHelpScreen> {
  String? _sel;

  static const _opts = [
    ('Be a listener', 'Provide emotional support'),
    ('Help find resources', 'Rehabs, counsellors, helplines'),
    ('Track progress together', 'Stay involved in recovery'),
    ('Learn about addiction', 'Understand what they face'),
  ];

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'How would you like to help?',
      nextEnabled: _sel != null,
      onNext: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FamilySummaryScreen())),
      body: Column(
        children: _opts.map((o) {
          final sel = _sel == o.$1;
          return GestureDetector(
            onTap: () => setState(() => _sel = o.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: sel
                    ? AarohaColors.primary.withOpacity(0.07)
                    : AarohaColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: sel ? AarohaColors.primary : Colors.transparent,
                    width: 2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(o.$1,
                            style: AarohaTextStyles.titleMd.copyWith(
                                color: sel ? AarohaColors.primary : AarohaColors.onSurface)),
                        const SizedBox(height: 4),
                        Text(o.$2,
                            style: AarohaTextStyles.bodyMd
                                .copyWith(color: AarohaColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  if (sel)
                    const Icon(Icons.check_circle_rounded,
                        color: AarohaColors.primary, size: 22),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Step 4: Family Summary ──────────────────────────────────

class FamilySummaryScreen extends StatelessWidget {
  const FamilySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              const Text('🤝', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 16),
              Text('You\'re here for them!',
                  style: AarohaTextStyles.headlineSm.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Your support can make a real difference in their recovery journey.',
                  textAlign: TextAlign.center,
                  style: AarohaTextStyles.bodyLg
                      .copyWith(color: Colors.white.withOpacity(0.7)),
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
                    child: const Text("Let's Get Started",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
