// lib/features/onboarding/presentation/screens/questionnaire_screens.dart
//
// Contains all step screens after "What are you quitting?":
//   SoberStartDateScreen
//   DaysPerWeekScreen
//   DrinksPerDayScreen
//   ImprovementGoalsScreen
//   SobrietyImportanceScreen
//   InvolveScreen
//   OnboardingSummaryScreen

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/app_router.dart';
import '../widgets/step_scaffold.dart';

// ─────────────────────────────────────────────────────────────
// 1. Sober Start Date
// ─────────────────────────────────────────────────────────────

class SoberStartDateScreen extends StatefulWidget {
  const SoberStartDateScreen({super.key});

  @override
  State<SoberStartDateScreen> createState() => _SoberStartDateScreenState();
}

class _SoberStartDateScreenState extends State<SoberStartDateScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isFuture = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      title: 'When was your sober start date?',
      onNext: () => context.go(Routes.daysPerWeek),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date picker tile
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AarohaConstants.space20,
                vertical: 18.0,
              ),
              decoration: BoxDecoration(
                color: AarohaColors.surfaceContainerHigh,
                borderRadius:
                    BorderRadius.circular(AarohaConstants.radiusMd),
                border: Border.all(color: AarohaColors.outlineVariant),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      DateFormat('d MMMM yyyy').format(_selectedDate),
                      style: AarohaTextStyles.bodyLg
                          .copyWith(color: AarohaColors.onSurface),
                    ),
                  ),
                  const Icon(Icons.calendar_month_rounded,
                      color: const Color(0xFF007A5E), size: 22),
                ],
              ),
            ),
          ),
          const SizedBox(height: AarohaConstants.space20),

          // Future date toggle
          GestureDetector(
            onTap: () => setState(() => _isFuture = !_isFuture),
            child: Text(
              'Start tracking on a future date',
              style: AarohaTextStyles.bodyMd.copyWith(
                color: const Color(0xFF007A5E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 2. Days Per Week
// ─────────────────────────────────────────────────────────────

class DaysPerWeekScreen extends StatefulWidget {
  const DaysPerWeekScreen({super.key});

  @override
  State<DaysPerWeekScreen> createState() => _DaysPerWeekScreenState();
}

class _DaysPerWeekScreenState extends State<DaysPerWeekScreen> {
  int _days = 0;
  final List<bool> _selected = List.filled(7, true);
  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  void _increment() {
    if (_days < 7) setState(() => _days++);
  }

  void _decrement() {
    if (_days > 0) setState(() => _days--);
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      title: 'How many days per week did you drink?',
      subtitle: 'On average, before you started tracking.',
      onNext: () => context.go(Routes.drinksPerDay),
      body: Column(
        children: [
          // Counter row
          Row(
            children: [
              // Display
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AarohaConstants.space16,
                  ),
                  decoration: BoxDecoration(
                    color: AarohaColors.surfaceContainerHigh,
                    borderRadius:
                        BorderRadius.circular(AarohaConstants.radiusFull),
                  ),
                  child: Center(
                    child: Text(
                      '$_days days',
                      style: AarohaTextStyles.titleMd.copyWith(
                        color: AarohaColors.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AarohaConstants.space12),
              // Minus
              _CounterButton(
                icon: Icons.remove,
                onTap: _decrement,
              ),
              const SizedBox(width: AarohaConstants.space12),
              // Plus
              _CounterButton(
                icon: Icons.add,
                onTap: _increment,
              ),
            ],
          ),
          const SizedBox(height: AarohaConstants.space20),

          // Day checkboxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              return GestureDetector(
                onTap: () => setState(() => _selected[i] = !_selected[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _selected[i]
                        ? AarohaColors.surfaceContainerHigh
                        : AarohaColors.surfaceContainerLow,
                    borderRadius:
                        BorderRadius.circular(AarohaConstants.radiusSm),
                    border: Border.all(
                      color: _selected[i]
                          ? AarohaColors.outlineVariant
                          : Colors.transparent,
                    ),
                  ),
                  child: Center(
                    child: _selected[i]
                        ? const Icon(Icons.check_rounded,
                            color: AarohaColors.onSurfaceVariant, size: 18)
                        : Text(
                            _dayLabels[i],
                            style: AarohaTextStyles.labelMd.copyWith(
                              color: AarohaColors.onSurfaceVariant,
                            ),
                          ),
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

// ─────────────────────────────────────────────────────────────
// 3. Drinks Per Day
// ─────────────────────────────────────────────────────────────

class DrinksPerDayScreen extends StatefulWidget {
  const DrinksPerDayScreen({super.key});

  @override
  State<DrinksPerDayScreen> createState() => _DrinksPerDayScreenState();
}

class _DrinksPerDayScreenState extends State<DrinksPerDayScreen> {
  int _drinks = 0;

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      title: 'On days you drank, how many drinks did you have?',
      subtitle: 'On average, before you started tracking.',
      onNext: () => context.go(Routes.improvementGoals),
      body: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AarohaConstants.space16,
              ),
              decoration: BoxDecoration(
                color: AarohaColors.surfaceContainerHigh,
                borderRadius:
                    BorderRadius.circular(AarohaConstants.radiusFull),
              ),
              child: Center(
                child: Text(
                  '$_drinks drinks',
                  style: AarohaTextStyles.titleMd
                      .copyWith(color: AarohaColors.onSurface),
                ),
              ),
            ),
          ),
          const SizedBox(width: AarohaConstants.space12),
          _CounterButton(
            icon: Icons.remove,
            onTap: () {
              if (_drinks > 0) setState(() => _drinks--);
            },
          ),
          const SizedBox(width: AarohaConstants.space12),
          _CounterButton(
            icon: Icons.add,
            onTap: () => setState(() => _drinks++),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 4. Improvement Goals
// ─────────────────────────────────────────────────────────────

class ImprovementGoalsScreen extends StatefulWidget {
  const ImprovementGoalsScreen({super.key});

  @override
  State<ImprovementGoalsScreen> createState() =>
      _ImprovementGoalsScreenState();
}

class _ImprovementGoalsScreenState extends State<ImprovementGoalsScreen> {
  final List<String> _selected = [];

  static const _options = [
    'Improve mental health',
    'Take control of my life',
    'Address health concerns',
    'Improve relationships',
    'Deepen spiritual or religious life',
    'Feel proud of who I am',
    'Increase productivity',
    'Sleep better and have more energy',
    'Handle legal responsibilities',
    'Discover new interests and hobbies',
    'Save money',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      title: 'What would you like to specifically improve in your life?',
      subtitle: 'Choose up to 3',
      nextEnabled: _selected.isNotEmpty,
      onNext: () => context.go(Routes.sobrietyImportance),
      body: Column(
        children: _options.map((opt) {
          final sel = _selected.contains(opt);
          return _OptionTile(
            label: opt,
            selected: sel,
            onTap: () {
              setState(() {
                if (sel) {
                  _selected.remove(opt);
                } else if (_selected.length < 3) {
                  _selected.add(opt);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 5. Sobriety Importance
// ─────────────────────────────────────────────────────────────

class SobrietyImportanceScreen extends StatefulWidget {
  const SobrietyImportanceScreen({super.key});

  @override
  State<SobrietyImportanceScreen> createState() =>
      _SobrietyImportanceScreenState();
}

class _SobrietyImportanceScreenState
    extends State<SobrietyImportanceScreen> {
  String? _selected;

  static const _options = [
    ('Critical', 'I need to change now'),
    ('Very', "It's a top focus for me"),
    ('Somewhat', "I'd like to improve this"),
    ('Nice to have', "I'm just exploring"),
  ];

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      title: 'How important is sobriety to you right now?',
      nextEnabled: _selected != null,
      onNext: () => context.go(Routes.onboardingSummary),
      body: Column(
        children: _options.map((opt) {
          final sel = _selected == opt.$1;
          return _OptionTile(
            label: opt.$1,
            subtitle: opt.$2,
            selected: sel,
            onTap: () => setState(() => _selected = opt.$1),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 6. Summary — "Look at what you just did!"
// ─────────────────────────────────────────────────────────────

class OnboardingSummaryScreen extends StatelessWidget {
  const OnboardingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF2D2B55),
              Color(0xFF3B2D6B),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              // ── Emoji ───────────────────────────────────────
              const Text('💯', style: TextStyle(fontSize: 56)),
              const SizedBox(height: AarohaConstants.space16),

              Text(
                'Look at what you just did!',
                style: AarohaTextStyles.headlineSm.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AarohaConstants.space8),
              Text(
                "Here's what you just accomplished:",
                style: AarohaTextStyles.bodyMd.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: AarohaConstants.space32),

              // ── Checklist ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AarohaConstants.space32,
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                        label: 'Named what you\'re quitting',
                        value: 'Alcohol'),
                    _SummaryRow(
                        label: 'Set your start date', value: today),
                    _SummaryRow(
                        label: 'Defined your "why"',
                        value: 'Making a healthy choice'),
                    _SummaryRow(
                        label: 'Decided on who you\'re becoming',
                        value: 'Making a healthy choice'),
                    _SummaryRow(
                        label: 'Chose your first milestone',
                        value: 'Weekend conquered'),
                    _SummaryRow(
                        label: 'Identified what you want to improve',
                        value: 'Motivation'),
                    _SummaryRow(
                        label: 'Planned your daily check-ins',
                        value: '08:00 and 20:00'),
                  ],
                ),
              ),

              const Spacer(),

              // ── CTA ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AarohaConstants.space24,
                  0,
                  AarohaConstants.space24,
                  AarohaConstants.space32,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        context.go(Routes.userTypeSelection),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007A5E),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AarohaConstants.radiusMd),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Let's Do This!",
                      style: AarohaTextStyles.labelLg.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AarohaConstants.space12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius:
                  BorderRadius.circular(AarohaConstants.radiusSm),
            ),
            child: const Icon(Icons.check_rounded,
                color: Colors.white, size: 14),
          ),
          const SizedBox(width: AarohaConstants.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AarohaTextStyles.bodyLg.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: AarohaTextStyles.bodyMd.copyWith(
                    color: Colors.white.withOpacity(0.55),
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

// ─────────────────────────────────────────────────────────────
// Shared sub-widgets
// ─────────────────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  const _OptionTile({
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
        margin: const EdgeInsets.only(bottom: 1),
        padding: const EdgeInsets.symmetric(
          horizontal: AarohaConstants.space24,
          vertical: AarohaConstants.space16,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AarohaColors.outlineVariant.withOpacity(0.5),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    label,
                    style: AarohaTextStyles.bodyLg.copyWith(
                      color: AarohaColors.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    Text(
                      ' · $subtitle',
                      style: AarohaTextStyles.bodyMd.copyWith(
                        color: AarohaColors.onSurfaceVariant,
                      ),
                    ),
                  ],
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

class _CounterButton extends StatelessWidget {
  const _CounterButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AarohaColors.outlineVariant, width: 1.5),
        ),
        child: Icon(icon, color: AarohaColors.onSurfaceVariant, size: 20),
      ),
    );
  }
}

