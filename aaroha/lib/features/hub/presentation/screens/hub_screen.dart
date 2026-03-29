import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../profile/data/profile_providers.dart';

class HubScreen extends ConsumerStatefulWidget {
  const HubScreen({super.key});
  @override
  ConsumerState<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends ConsumerState<HubScreen> {
  int _selectedFilter = 0;
  final _filters = ['All', 'Tip', 'Story', 'Resource', 'Program'];

  static const _quickResources = [
    ('Journal Prompts',   'Resource', Icons.menu_book_rounded,         AarohaColors.tertiary),
    ('Local Meetups',     'Program',  Icons.groups_rounded,            AarohaColors.secondary),
    ('Meditation Guide',  'Resource', Icons.self_improvement_rounded,  AarohaColors.primaryContainer),
    ('Family Support',    'Guide',    Icons.family_restroom_rounded,   AarohaColors.outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          Text('Awareness Hub', style: AarohaTextStyles.headlineMd).animate().fadeIn(),
          Text('Tools, stories & guidance for your journey.',
            style: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.onSurfaceVariant))
            .animate(delay: 50.ms).fadeIn(),

          const SizedBox(height: 16),

          // Filter chips
          SizedBox(height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => AarohaFilterChip(
                label: _filters[i], isSelected: _selectedFilter == i,
                onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedFilter = i); }),
            ),
          ).animate(delay: 80.ms).fadeIn(),

          const SizedBox(height: 20),

          // ── Featured Story — tap → stat ───────────────────
          _FeaturedStoryCard(onTap: () => ref.read(statsProvider.notifier).storyRead())
              .animate(delay: 120.ms).fadeIn().slideY(begin: 0.04),

          const SizedBox(height: 16),

          // ── Tip card ──────────────────────────────────────
          _TipCard(onTap: () => ref.read(statsProvider.notifier).resourceViewed())
              .animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 20),

          const SectionHeader(title: 'Resources & Programs').animate(delay: 260.ms).fadeIn(),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1,
            children: _quickResources.asMap().entries.map((entry) {
              final i = entry.key; final r = entry.value;
              return _ResourceCard(
                title: r.$1, category: r.$2, icon: r.$3, color: r.$4,
                onTap: () => ref.read(statsProvider.notifier).resourceViewed(),
              ).animate(delay: Duration(milliseconds: 280 + i * 50)).fadeIn().scale(begin: const Offset(0.95, 0.95));
            }).toList(),
          ),

          const SizedBox(height: 20),

          _ProgramCard(onTap: () => ref.read(statsProvider.notifier).resourceViewed())
              .animate(delay: 400.ms).fadeIn(),

          const SizedBox(height: 20),

          const _WeeklyReflectionCard().animate(delay: 460.ms).fadeIn(),
        ],
      ),
    );
  }
}

// ── Featured Story Card ───────────────────────────────────────
class _FeaturedStoryCard extends StatelessWidget {
  final VoidCallback onTap;
  const _FeaturedStoryCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TappableCard(
      color: AarohaColors.surfaceContainerLow,
      radius: AarohaConstants.radiusXl,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(height: 180,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(AarohaConstants.radiusXl)),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [AarohaColors.mintSurface, AarohaColors.secondaryContainer])),
          child: Stack(children: [
            Positioned(top: -20, right: -20, child: Container(width: 140, height: 140,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AarohaColors.primaryFixedDim.withOpacity(0.4)))),
            Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.forest_rounded, color: AarohaColors.primaryContainer.withOpacity(0.7), size: 56),
              const SizedBox(height: 8),
              Text('Finding stillness in the noise', style: AarohaTextStyles.titleMd.copyWith(color: AarohaColors.primaryContainer)),
            ])),
          ])),
        Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const OverlineTag(label: 'Story'),
          const SizedBox(height: 10),
          Text('Finding stillness in the noise', style: AarohaTextStyles.titleMd.copyWith(color: AarohaColors.onSurface)),
          const SizedBox(height: 6),
          Text('How meditation became a cornerstone of recovery for Sarah after ten years of struggle.',
            style: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.onSurfaceVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 14),
          Row(children: [
            const CircleAvatar(radius: 14, backgroundColor: AarohaColors.surfaceContainerHighest,
              child: Icon(Icons.person_rounded, color: AarohaColors.primary, size: 14)),
            const SizedBox(width: 8),
            Text('By Sarah J.', style: AarohaTextStyles.labelMd),
            const Spacer(),
            Text('8 min read', style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.outline)),
          ]),
        ])),
      ]),
    );
  }
}

// ── Tip Card ──────────────────────────────────────────────────
class _TipCard extends StatelessWidget {
  final VoidCallback onTap;
  const _TipCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TappableCard(
      color: AarohaColors.mintSurface, radius: AarohaConstants.radiusXl,
      padding: const EdgeInsets.all(24), onTap: onTap,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          OverlineTag(label: 'Tip', backgroundColor: AarohaColors.primary.withOpacity(0.12), textColor: AarohaColors.primary),
          const Icon(Icons.lightbulb_rounded, color: AarohaColors.primaryContainer),
        ]),
        const SizedBox(height: 14),
        Text('The 5-minute rule', style: AarohaTextStyles.headlineSm.copyWith(color: AarohaColors.primaryContainer)),
        const SizedBox(height: 8),
        Text('Cravings peak and fade within 15–20 minutes. Wait just 5 minutes and you\'re halfway there.',
          style: AarohaTextStyles.bodyLg.copyWith(color: AarohaColors.onPrimaryFixedVariant, height: 1.5)),
        const SizedBox(height: 16),
        Row(children: [
          Text('Learn more', style: AarohaTextStyles.labelMd.copyWith(color: AarohaColors.primary)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_rounded, color: AarohaColors.primary, size: 16),
        ]),
      ]),
    );
  }
}

// ── Resource Card ─────────────────────────────────────────────
class _ResourceCard extends StatelessWidget {
  final String title, category;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ResourceCard({required this.title, required this.category, required this.icon, required this.color, required this.onTap});

  Color get _bg {
    if (color == AarohaColors.tertiary) return AarohaColors.tertiaryFixed.withOpacity(0.25);
    if (color == AarohaColors.secondary) return AarohaColors.secondaryContainer.withOpacity(0.3);
    if (color == AarohaColors.primaryContainer) return AarohaColors.mintSurface;
    return AarohaColors.surfaceContainerHigh;
  }

  @override
  Widget build(BuildContext context) {
    return TappableCard(color: _bg, radius: AarohaConstants.radiusXl, onTap: onTap,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: color, size: 22)),
        const SizedBox(height: 12),
        Text(category.toUpperCase(), style: AarohaTextStyles.overline.copyWith(color: color.withOpacity(0.7))),
        const SizedBox(height: 4),
        Text(title, style: AarohaTextStyles.labelLg.copyWith(color: AarohaColors.onSurface, height: 1.3)),
      ]),
    );
  }
}

// ── Program Card ──────────────────────────────────────────────
class _ProgramCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ProgramCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TappableCard(color: AarohaColors.surfaceContainerLow, radius: AarohaConstants.radiusXl, onTap: onTap,
      child: Row(children: [
        Container(width: 80, height: 80,
          decoration: BoxDecoration(color: AarohaColors.mintSurface, borderRadius: BorderRadius.circular(AarohaConstants.radiusMd)),
          child: const Icon(Icons.air_rounded, color: AarohaColors.primaryContainer, size: 40)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          OverlineTag(label: 'Program', backgroundColor: AarohaColors.outlineVariant.withOpacity(0.2), textColor: AarohaColors.outline),
          const SizedBox(height: 6),
          Text('Breathwork 101: A Beginner\'s Path', style: AarohaTextStyles.labelLg.copyWith(color: AarohaColors.onSurface, height: 1.3)),
          const SizedBox(height: 4),
          Text('Starting tomorrow · 6:00 PM', style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.outline)),
        ])),
      ]),
    );
  }
}

// ── Weekly Reflection CTA ─────────────────────────────────────
class _WeeklyReflectionCard extends StatelessWidget {
  const _WeeklyReflectionCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: AarohaColors.heroGradientAngled, borderRadius: BorderRadius.circular(AarohaConstants.radiusXl)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Weekly Reflection', style: AarohaTextStyles.titleMd.copyWith(color: AarohaColors.onPrimary)),
          const SizedBox(height: 4),
          Text('Take 5 minutes to celebrate your progress this week.',
            style: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.onPrimary.withOpacity(0.8), height: 1.4)),
        ])),
        const SizedBox(width: 12),
        Container(width: 44, height: 44,
          decoration: BoxDecoration(color: AarohaColors.onPrimary.withOpacity(0.15), shape: BoxShape.circle),
          child: const Icon(Icons.arrow_forward_rounded, color: AarohaColors.onPrimary, size: 22)),
      ]),
    );
  }
}
