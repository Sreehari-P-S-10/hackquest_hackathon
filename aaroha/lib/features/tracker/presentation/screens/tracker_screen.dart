import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../core/services/notification_service.dart';
import '../../../profile/data/profile_providers.dart';
import '../../data/streak_provider.dart';
import '../../domain/streak_model.dart';

class TrackerScreen extends ConsumerStatefulWidget {
  const TrackerScreen({super.key});

  @override
  ConsumerState<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends ConsumerState<TrackerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final goals = ref.read(goalsProvider);
      final incomplete = goals.where((g) => !g.isCompleted).map((g) => g.title).toList();
      NotificationService.instance.scheduleIncompleteGoalReminder(incomplete);
    });
  }

  void _restartStreak() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AarohaColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AarohaConstants.radiusLg),
        ),
        title: Text('Restart streak?', style: AarohaTextStyles.titleMd),
        content: Text(
          'Being honest takes courage. Restarting from today is still progress.',
          style: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              ref.read(streakProvider.notifier).restart();
              Navigator.pop(context);
              HapticFeedback.mediumImpact();
              await ref.read(statsProvider.notifier).streakRestarted();
            },
            style: FilledButton.styleFrom(backgroundColor: AarohaColors.tertiary),
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final streak = ref.watch(streakProvider);
    final goals  = ref.watch(goalsProvider);
    final doneCount = goals.where((g) => g.isCompleted).length;

    return Scaffold(
      backgroundColor: AarohaColors.background,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          // ── Streak Hero ─────────────────────────────────────
          _StreakHeroCard(streak: streak)
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.04, end: 0, duration: 400.ms),

          const SizedBox(height: 28),

          // ── Daily Goals ─────────────────────────────────────
          SectionHeader(
            title: "Today's Goals",
            actionLabel: '$doneCount/${goals.length} done',
          ).animate().fadeIn(delay: 80.ms),
          const SizedBox(height: 12),

          ...goals.asMap().entries.map((entry) {
            final i = entry.key;
            final g = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _GoalTile(
                goal: _Goal(g.title, g.subtitle, g.isCompleted),
                onToggle: () async {
                  HapticFeedback.selectionClick();
                  final wasCompleted = g.isCompleted;
                  ref.read(goalsProvider.notifier).toggle(g.id);

                  if (!wasCompleted) {
                    await ref.read(statsProvider.notifier).goalCompleted();
                    await NotificationService.instance.showGoalCompletedNotification(g.title);
                  }
                  final updated = ref.read(goalsProvider);
                  final incomplete = updated.where((goal) => !goal.isCompleted).map((goal) => goal.title).toList();
                  await NotificationService.instance.scheduleIncompleteGoalReminder(incomplete);
                },
              )
                  .animate(delay: Duration(milliseconds: 120 + i * 60))
                  .fadeIn()
                  .slideX(begin: 0.03),
            );
          }),

          const SizedBox(height: 28),

          const _QuoteCard().animate(delay: 300.ms).fadeIn(),

          const SizedBox(height: 28),

          const SectionHeader(title: 'Your Progress').animate(delay: 350.ms).fadeIn(),
          const SizedBox(height: 12),
          _BentoStats(streak: streak).animate(delay: 400.ms).fadeIn(),

          const SizedBox(height: 28),

          GradientButton(
            label: 'Talk to Swasthi now',
            icon: Icons.smart_toy_rounded,
            onTap: () {},
          ).animate(delay: 450.ms).fadeIn(),

          const SizedBox(height: 12),

          Center(
            child: TextButton.icon(
              onPressed: _restartStreak,
              icon: const Icon(Icons.refresh_rounded, color: AarohaColors.tertiary, size: 18),
              label: Text('I need to restart my streak',
                  style: AarohaTextStyles.labelMd.copyWith(color: AarohaColors.tertiary)),
            ),
          ).animate(delay: 480.ms).fadeIn(),
        ],
      ),
    );
  }
}

// ── Streak Hero Card ──────────────────────────────────────────
class _StreakHeroCard extends StatelessWidget {
  final StreakModel streak;
  const _StreakHeroCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AarohaColors.mintSurface,
        borderRadius: BorderRadius.circular(AarohaConstants.radiusHero),
      ),
      child: Stack(
        children: [
          Positioned(top: -40, right: -40,
            child: Container(width: 120, height: 120,
              decoration: BoxDecoration(color: AarohaColors.primaryContainer.withOpacity(0.06), shape: BoxShape.circle))),
          Positioned(bottom: -30, left: -30,
            child: Container(width: 90, height: 90,
              decoration: BoxDecoration(color: AarohaColors.primaryContainer.withOpacity(0.10), shape: BoxShape.circle))),
          Column(
            children: [
              Text('CURRENT STREAK', style: AarohaTextStyles.overline.copyWith(color: AarohaColors.primaryContainer)),
              const SizedBox(height: 8),
              Text('${streak.daysSober}', style: AarohaTextStyles.displayLg.copyWith(color: AarohaColors.primaryContainer, fontSize: 88)),
              Text('Days Clean', style: AarohaTextStyles.headlineSm.copyWith(color: AarohaColors.primaryContainer.withOpacity(0.8))),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: AarohaColors.primaryContainer.withOpacity(0.15)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('NEXT MILESTONE', style: AarohaTextStyles.overline.copyWith(color: AarohaColors.primaryContainer.withOpacity(0.6))),
                      Text(streak.nextMilestoneLabel, style: AarohaTextStyles.labelMd.copyWith(color: AarohaColors.primaryContainer)),
                    ]),
                    Container(
                      width: 48, height: 48,
                      decoration: const BoxDecoration(color: AarohaColors.primaryContainer, shape: BoxShape.circle),
                      child: const Icon(Icons.workspace_premium_rounded, color: AarohaColors.onPrimary, size: 26),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Goal Tile ─────────────────────────────────────────────────
class _GoalTile extends StatelessWidget {
  final _Goal goal;
  final VoidCallback onToggle;
  const _GoalTile({required this.goal, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AarohaColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AarohaConstants.radiusMd),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: goal.done ? AarohaColors.primary.withOpacity(0.12) : AarohaColors.outlineVariant.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                goal.done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: goal.done ? AarohaColors.primary : AarohaColors.outline,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(goal.title, style: AarohaTextStyles.labelLg.copyWith(color: AarohaColors.onSurface)),
                Text(goal.subtitle, style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.outline)),
              ]),
            ),
            if (!goal.done) const Icon(Icons.chevron_right_rounded, color: AarohaColors.outline, size: 20),
            if (goal.done)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AarohaColors.primary.withOpacity(0.10), borderRadius: BorderRadius.circular(20)),
                child: Text('Done', style: AarohaTextStyles.overline.copyWith(color: AarohaColors.primary, letterSpacing: 0.5)),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Quote Card ────────────────────────────────────────────────
class _QuoteCard extends StatelessWidget {
  const _QuoteCard();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.format_quote_rounded, color: AarohaColors.primary.withOpacity(0.3), size: 36),
        const SizedBox(height: 8),
        Text('"Cravings are waves — they rise, and they fall. You are the shore."',
            style: AarohaTextStyles.titleMd.copyWith(
              fontStyle: FontStyle.italic, color: AarohaColors.onSurface.withOpacity(0.75), height: 1.5)),
        const SizedBox(height: 10),
        Container(width: 40, height: 3,
          decoration: BoxDecoration(color: AarohaColors.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(2))),
      ]),
    );
  }
}

// ── Bento Stats ───────────────────────────────────────────────
class _BentoStats extends StatelessWidget {
  final StreakModel streak;
  const _BentoStats({required this.streak});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _Stat('₹${streak.moneySavedAuto.toStringAsFixed(0)}', 'Money Saved', Icons.savings_rounded, AarohaColors.primary),
      _Stat('${streak.hoursSober}h', 'Hours Sober', Icons.timer_rounded, AarohaColors.secondary),
      const _Stat('3', 'Badges Earned', Icons.emoji_events_rounded, AarohaColors.primary),
      _Stat('${streak.bestStreak}', 'Best Streak', Icons.local_fire_department_rounded, AarohaColors.tertiary),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: stats.map((s) => _StatCard(stat: s)).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final _Stat stat;
  const _StatCard({required this.stat});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AarohaColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AarohaConstants.radiusXl),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(stat.icon, color: stat.color, size: 24),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(stat.value, style: AarohaTextStyles.headlineSm.copyWith(color: AarohaColors.onSurface)),
          Text(stat.label, style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.onSurfaceVariant)),
        ]),
      ]),
    );
  }
}

class _Goal {
  final String title;
  final String subtitle;
  final bool done;
  const _Goal(this.title, this.subtitle, this.done);
}

class _Stat {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _Stat(this.value, this.label, this.icon, this.color);
}
