import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../data/profile_providers.dart';
import '../../domain/user_model.dart';
import 'edit_profile_screen.dart';
import '../../services/user_service.dart';
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user  = ref.watch(userProvider);
    final stats = ref.watch(statsProvider);

    return Scaffold(
      backgroundColor: AarohaColors.background,
      appBar: AppBar(
        backgroundColor: AarohaColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AarohaColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('My Profile', style: AarohaTextStyles.titleLg.copyWith(
          color: AarohaColors.primary,
        )),
        actions: [
          // Edit button
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AarohaColors.primary),
            tooltip: 'Edit profile',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
        children: [
          // ── Avatar + name ────────────────────────────────────
          _ProfileHeroCard(user: user).animate().fadeIn(duration: 350.ms),

          const SizedBox(height: 24),

          // ── Usage stats ───────────────────────────────────────
          Text('Your Activity', style: AarohaTextStyles.titleMd).animate(delay: 80.ms).fadeIn(),
          const SizedBox(height: 12),
          _StatsGrid(stats: stats).animate(delay: 120.ms).fadeIn(),

          const SizedBox(height: 24),

          // ── Preferences ───────────────────────────────────────
          Text('Preferences', style: AarohaTextStyles.titleMd).animate(delay: 180.ms).fadeIn(),
          const SizedBox(height: 12),
          _PreferenceCard(user: user).animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 24),

          // ── Danger zone ───────────────────────────────────────
          _DangerZone().animate(delay: 260.ms).fadeIn(),
        ],
      ),
    );
  }
}

// ── Profile Hero Card ─────────────────────────────────────────
class _ProfileHeroCard extends StatelessWidget {
  final UserModel user;
  const _ProfileHeroCard({required this.user});

  String get _initials {
    final parts = user.name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }

  String get _daysSober {
    final diff = DateTime.now().difference(user.soberStartDate).inDays;
    return '$diff';
  }

  String get _userTypeLabel => switch (user.userType) {
    'privateUser'        => 'Private User',
    'familyMember'       => 'Family Member',
    'supportCommunity'   => 'Support Community',
    _                    => 'User',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AarohaColors.mintSurface,
        borderRadius: BorderRadius.circular(AarohaConstants.radiusXl),
      ),
      child: Column(
        children: [
          // Avatar circle
          Container(
            width: 80, height: 80,
            decoration: const BoxDecoration(
              gradient: AarohaColors.heroGradientAngled,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _initials,
                style: AarohaTextStyles.headlineMd.copyWith(
                  color: AarohaColors.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(user.name, style: AarohaTextStyles.headlineSm.copyWith(
            color: AarohaColors.primaryContainer,
          )),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AarohaColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AarohaConstants.radiusFull),
            ),
            child: Text(_userTypeLabel, style: AarohaTextStyles.labelMd.copyWith(
              color: AarohaColors.primary,
            )),
          ),
          const SizedBox(height: 20),
          // Quick stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _QuickStat(label: 'Days Sober', value: _daysSober),
              _QuickStat(label: 'Quitting', value: user.quitting),
              _QuickStat(label: 'Importance', value: user.sobrietyImportance),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  const _QuickStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AarohaTextStyles.titleLg.copyWith(
          color: AarohaColors.primaryContainer,
        )),
        Text(label, style: AarohaTextStyles.bodySm.copyWith(
          color: AarohaColors.onSurfaceVariant,
        )),
      ],
    );
  }
}

// ── Stats Grid ─────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final dynamic stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Goals Completed',        '${stats.goalsCompleted}',        Icons.check_circle_rounded,        AarohaColors.primary),
      ('Chat Messages',          '${stats.chatMessagesSent}',      Icons.chat_bubble_rounded,         AarohaColors.primaryContainer),
      ('Mood Check-ins',         '${stats.moodCheckins}',          Icons.mood_rounded,                AarohaColors.secondary),
      ('Breathwork Sessions',    '${stats.breathworkSessions}',    Icons.air_rounded,                 AarohaColors.primaryContainer),
      ('Craving Journals',       '${stats.cravingJournalEntries}', Icons.edit_note_rounded,           AarohaColors.outline),
      ('Quotes Liked',           '${stats.quotesLiked}',           Icons.favorite_rounded,            AarohaColors.tertiary),
      ('Stories Read',           '${stats.storiesRead}',           Icons.menu_book_rounded,           AarohaColors.secondary),
      ('Hope Wall Posts',        '${stats.hopeWallPosts}',         Icons.emoji_emotions_rounded,      AarohaColors.primaryContainer),
      ('Soundscapes Played',     '${stats.soundscapesPlayed}',     Icons.music_note_rounded,          AarohaColors.primary),
      ('Centre Calls',           '${stats.centreCallsMade}',       Icons.call_rounded,                AarohaColors.tertiary),
      ('Events Joined',          '${stats.eventsJoined}',          Icons.event_rounded,               AarohaColors.secondary),
      ('Resources Viewed',       '${stats.resourcesViewed}',       Icons.import_contacts_rounded,     AarohaColors.outline),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.95,
      children: items.map((item) => _StatTile(
        label: item.$1,
        value: item.$2,
        icon:  item.$3,
        color: item.$4,
      )).toList(),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatTile({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AarohaColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AarohaConstants.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: AarohaTextStyles.headlineSm.copyWith(
            color: AarohaColors.onSurface, fontSize: 20,
          )),
          Text(label, style: AarohaTextStyles.bodySm.copyWith(
            color: AarohaColors.onSurfaceVariant, fontSize: 10,
          ), maxLines: 2),
        ],
      ),
    );
  }
}

// ── Preferences Card ──────────────────────────────────────────
class _PreferenceCard extends StatelessWidget {
  final UserModel user;
  const _PreferenceCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final goals = user.improvementGoals.isEmpty
        ? 'None set'
        : user.improvementGoals.join(', ');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AarohaColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AarohaConstants.radiusXl),
      ),
      child: Column(
        children: [
          _PrefRow(icon: Icons.self_improvement_rounded, label: 'Sobriety Importance', value: user.sobrietyImportance),
          _PrefRow(icon: Icons.wb_sunny_rounded,          label: 'Morning Check-in',    value: user.morningCheckIn),
          _PrefRow(icon: Icons.nights_stay_rounded,       label: 'Evening Check-in',    value: user.eveningCheckIn),
          _PrefRow(icon: Icons.star_rounded,              label: 'Improvement Goals',   value: goals, isLast: true),
        ],
      ),
    );
  }
}

class _PrefRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;
  const _PrefRow({required this.icon, required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(color: AarohaColors.outlineVariant.withOpacity(0.4)),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AarohaColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AarohaTextStyles.labelMd.copyWith(
                  color: AarohaColors.onSurfaceVariant,
                )),
                Text(value, style: AarohaTextStyles.bodyMd.copyWith(
                  color: AarohaColors.onSurface,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Danger Zone ───────────────────────────────────────────────
class _DangerZone extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Reset stats
        ListTile(
          tileColor: AarohaColors.surfaceContainerLow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: const Icon(Icons.refresh_rounded, color: AarohaColors.secondary),
          title: Text('Reset Activity Stats', style: AarohaTextStyles.bodyLg),
          subtitle: Text('Clears all counters', style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.outline)),
          trailing: const Icon(Icons.chevron_right_rounded, color: AarohaColors.outline),
          onTap: () async {
            final confirm = await _confirmDialog(context, 'Reset all stats?',
                'All counters will be set to zero.');
            if (confirm == true) {
              HapticFeedback.mediumImpact();
              await ref.read(statsProvider.notifier).reset();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Stats reset to zero')),
                );
              }
            }
          },
        ),
        const SizedBox(height: 10),
        // Sign out / delete all
        ListTile(
          tileColor: AarohaColors.errorContainer.withOpacity(0.25),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: Icon(Icons.logout_rounded, color: AarohaColors.error),
          title: Text('Sign Out & Reset', style: AarohaTextStyles.bodyLg.copyWith(color: AarohaColors.error)),
          subtitle: Text('Deletes local data', style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.outline)),
          trailing: Icon(Icons.chevron_right_rounded, color: AarohaColors.error),
          onTap: () async {
            final confirm = await _confirmDialog(context, 'Delete all data?',
                'This cannot be undone. App restarts with a fresh profile.');
            if (confirm == true) {
              HapticFeedback.heavyImpact();
              await UserService.init(); // re-seeds after delete
              // Invalidate providers so they reload
              ref.invalidate(userProvider);
              ref.invalidate(statsProvider);
              if (context.mounted) Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Future<bool?> _confirmDialog(BuildContext context, String title, String body) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AarohaColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(title, style: AarohaTextStyles.titleMd),
        content: Text(body, style: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.onSurfaceVariant)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AarohaColors.error),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

// Re-export so profile_screen can call UserService.init()

