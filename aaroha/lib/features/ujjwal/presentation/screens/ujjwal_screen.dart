import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../profile/data/profile_providers.dart';

class UjjwalScreen extends ConsumerStatefulWidget {
  const UjjwalScreen({super.key});
  @override
  ConsumerState<UjjwalScreen> createState() => _UjjwalScreenState();
}

class _UjjwalScreenState extends ConsumerState<UjjwalScreen> {
  int _selectedFilter = 0;
  final _filters = ['All', 'Quotes', 'Stories', 'Videos', 'Hope Wall'];

  /// Tracks which quote indices have been liked (heart-filled).
  final Set<int> _likedQuotes = {};

  static const _quotes = [
    ('"The comeback is always stronger than the setback."', '— Recovery Wisdom'),
    ('"Progress, not perfection."', '— AA Principle'),
    ('"You are braver than you believe."', '— A.A. Milne'),
    ('"One day at a time — some days, one moment at a time."', '— Anon'),
  ];

  static const _hopeWall = [
    ('Day 30 today. If I can do it, so can you. 💚', '2 hours ago'),
    ('The hardest part was asking for help. Now I\'m grateful I did.', 'Yesterday'),
    ('6 months clean. This app helped me through the worst nights.', '3 days ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          Text('Ujjwal Feed', style: AarohaTextStyles.headlineMd).animate().fadeIn(),
          Text('Stories, quotes & light for your journey.',
            style: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.onSurfaceVariant))
            .animate(delay: 50.ms).fadeIn(),

          const SizedBox(height: 16),

          // ── Filter chips ──────────────────────────────────
          SizedBox(height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => AarohaFilterChip(
                label: _filters[i],
                isSelected: _selectedFilter == i,
                onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedFilter = i); },
              ),
            ),
          ).animate(delay: 80.ms).fadeIn(),

          const SizedBox(height: 20),

          // ── Daily Affirmation ─────────────────────────────
          const _AffirmationHeroCard().animate(delay: 120.ms).fadeIn().slideY(begin: 0.04),
          const SizedBox(height: 16),

          // ── Featured Story — tapping increments storiesRead ──
          _StoryCard(
            category: 'Story',
            title: 'Finding stillness in the noise',
            subtitle: 'How meditation became a cornerstone of recovery for Sarah after ten years of struggle.',
            author: 'By Sarah J.',
            readTime: '8 min read',
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AarohaColors.primaryContainer, AarohaColors.primary],
            ),
            onTap: () => ref.read(statsProvider.notifier).storyRead(),
          ).animate(delay: 180.ms).fadeIn(),

          const SizedBox(height: 16),

          // ── Quote Grid ────────────────────────────────────
          const SectionHeader(title: 'Daily Quotes'),
          const SizedBox(height: 12),
          _QuoteGrid(
            quotes: _quotes,
            likedIndices: _likedQuotes,
            onLike: (index) async {
              if (_likedQuotes.contains(index)) return; // already liked
              setState(() => _likedQuotes.add(index));
              HapticFeedback.selectionClick();
              // ── Stat: quote liked ────────────────────────
              await ref.read(statsProvider.notifier).quoteLiked();
            },
          ).animate(delay: 240.ms).fadeIn(),

          const SizedBox(height: 24),

          SectionHeader(title: 'Hope Wall', actionLabel: 'From peers →')
              .animate(delay: 300.ms).fadeIn(),
          const SizedBox(height: 12),

          ..._hopeWall.asMap().entries.map((entry) {
            final i = entry.key; final hw = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _HopeWallTile(message: hw.$1, time: hw.$2)
                  .animate(delay: Duration(milliseconds: 320 + i * 60)).fadeIn().slideX(begin: 0.03),
            );
          }),

          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _shareHope(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AarohaColors.onSurfaceVariant,
              side: const BorderSide(color: AarohaColors.outlineVariant),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AarohaConstants.radiusMd)),
            ),
            child: Text('Share your hope anonymously +',
              style: AarohaTextStyles.labelLg.copyWith(color: AarohaColors.onSurfaceVariant)),
          ).animate(delay: 440.ms).fadeIn(),
        ],
      ),
    );
  }

  void _shareHope(BuildContext context) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AarohaColors.surface, borderRadius: BorderRadius.circular(AarohaConstants.radiusXl)),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Share your hope 💚', style: AarohaTextStyles.titleMd),
            const SizedBox(height: 4),
            Text('Your message is anonymous and will inspire others.', style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.outline)),
            const SizedBox(height: 16),
            TextField(controller: ctrl, maxLines: 3, autofocus: true, style: AarohaTextStyles.bodyMd,
              decoration: const InputDecoration(hintText: 'Write something that might help someone today…')),
            const SizedBox(height: 16),
            GradientButton(
              label: 'Share anonymously',
              icon: Icons.send_rounded,
              onTap: () async {
                Navigator.pop(context);
                HapticFeedback.mediumImpact();
                // ── Stat: hope wall post ─────────────────
                await ref.read(statsProvider.notifier).hopeWallPosted();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Your hope has been shared 💚')));
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}

// ── Affirmation Hero ──────────────────────────────────────────
class _AffirmationHeroCard extends StatelessWidget {
  const _AffirmationHeroCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: AarohaColors.mintSurface, borderRadius: BorderRadius.circular(AarohaConstants.radiusHero)),
      child: Stack(children: [
        Positioned(top: -20, right: -20,
          child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: AarohaColors.primaryContainer.withOpacity(0.08)))),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          OverlineTag(label: "Today's Affirmation", backgroundColor: AarohaColors.primary.withOpacity(0.12), textColor: AarohaColors.primary),
          const SizedBox(height: 14),
          Text('"Every moment sober is a victory worth celebrating."',
            style: AarohaTextStyles.headlineSm.copyWith(color: AarohaColors.primaryContainer, height: 1.3)),
          const SizedBox(height: 14),
          Row(children: [
            const Icon(Icons.auto_awesome_rounded, color: AarohaColors.primaryContainer, size: 14),
            const SizedBox(width: 6),
            Text('Tap to save to your journal',
              style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.primaryContainer.withOpacity(0.7))),
          ]),
        ]),
      ]),
    );
  }
}

// ── Story Card ────────────────────────────────────────────────
class _StoryCard extends StatelessWidget {
  final String category, title, subtitle, author, readTime;
  final Gradient gradient;
  final VoidCallback onTap;
  const _StoryCard({required this.category, required this.title, required this.subtitle, required this.author, required this.readTime, required this.gradient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TappableCard(
      color: AarohaColors.surfaceContainerLow,
      radius: AarohaConstants.radiusXl,
      padding: EdgeInsets.zero,
      onTap: onTap, // ← fires stats increment
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 180,
          decoration: BoxDecoration(gradient: gradient, borderRadius: const BorderRadius.vertical(top: Radius.circular(AarohaConstants.radiusXl))),
          child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.self_improvement_rounded, color: Colors.white54, size: 52),
            const SizedBox(height: 8),
            Text('Finding My Shore', style: AarohaTextStyles.titleMd.copyWith(color: Colors.white)),
          ])),
        ),
        Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          OverlineTag(label: category),
          const SizedBox(height: 10),
          Text(title, style: AarohaTextStyles.titleMd),
          const SizedBox(height: 6),
          Text(subtitle, style: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.onSurfaceVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 14),
          Row(children: [
            const CircleAvatar(radius: 14, backgroundColor: AarohaColors.surfaceContainerHighest,
              child: Icon(Icons.person_rounded, color: AarohaColors.primary, size: 14)),
            const SizedBox(width: 8),
            Text(author, style: AarohaTextStyles.labelMd),
            const Spacer(),
            Text(readTime, style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.outline)),
          ]),
        ])),
      ]),
    );
  }
}

// ── Quote Grid — with like button ─────────────────────────────
class _QuoteGrid extends StatelessWidget {
  final List<(String, String)> quotes;
  final Set<int> likedIndices;
  final void Function(int) onLike;
  const _QuoteGrid({required this.quotes, required this.likedIndices, required this.onLike});

  @override
  Widget build(BuildContext context) {
    final colors = [
      (AarohaColors.tertiaryFixed.withOpacity(0.25), AarohaColors.tertiary),
      (AarohaColors.secondaryContainer.withOpacity(0.3), AarohaColors.secondary),
      (AarohaColors.mintSurface, AarohaColors.primaryContainer),
      (AarohaColors.surfaceContainerHigh, AarohaColors.onSurfaceVariant),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85),
      itemCount: quotes.length,
      itemBuilder: (_, i) {
        final color = colors[i % colors.length];
        final liked = likedIndices.contains(i);
        return TappableCard(
          color: color.$1,
          radius: AarohaConstants.radiusXl,
          child: Stack(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.format_quote_rounded, color: color.$2, size: 24),
              const SizedBox(height: 10),
              Text(quotes[i].$1, style: AarohaTextStyles.labelLg.copyWith(color: AarohaColors.onSurface, height: 1.4)),
              const Spacer(),
              Text(quotes[i].$2, style: AarohaTextStyles.overline.copyWith(color: AarohaColors.outline)),
            ]),
            // Like button — top right
            Positioned(top: 0, right: 0,
              child: GestureDetector(
                onTap: () => onLike(i),
                child: Icon(
                  liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: liked ? AarohaColors.tertiary : AarohaColors.outline,
                  size: 20,
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}

// ── Hope Wall Tile ────────────────────────────────────────────
class _HopeWallTile extends StatelessWidget {
  final String message, time;
  const _HopeWallTile({required this.message, required this.time});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AarohaColors.surfaceContainerLow, borderRadius: BorderRadius.circular(AarohaConstants.radiusMd)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 32, height: 32,
          decoration: BoxDecoration(color: AarohaColors.primary.withOpacity(0.12), shape: BoxShape.circle),
          child: const Icon(Icons.person_rounded, color: AarohaColors.primary, size: 16)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(message, style: AarohaTextStyles.bodyMd.copyWith(color: AarohaColors.onSurface, height: 1.5)),
          const SizedBox(height: 4),
          Text('Anonymous · $time', style: AarohaTextStyles.bodySm.copyWith(color: AarohaColors.outline)),
        ])),
      ]),
    );
  }
}
