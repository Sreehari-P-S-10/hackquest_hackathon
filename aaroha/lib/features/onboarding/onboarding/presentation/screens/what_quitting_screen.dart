// lib/features/onboarding/presentation/screens/what_quitting_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/app_router.dart';
import '../widgets/step_scaffold.dart';

class WhatQuittingScreen extends StatefulWidget {
  const WhatQuittingScreen({super.key});

  @override
  State<WhatQuittingScreen> createState() => _WhatQuittingScreenState();
}

class _WhatQuittingScreenState extends State<WhatQuittingScreen> {
  String _searchQuery = '';
  String? _selected;

  static const Map<String, List<String>> _categories = {
    'Alcoholic drinks': [
      'Alcohol',
      'Beer',
      'Binge Drinking',
      'Booze',
      'Bourbon',
      'Gin',
      'Rum',
      'Tequila',
      'Vodka',
      'Wine',
    ],
    'Drugs': [
      'Cannabis',
      'Cocaine',
      'Heroin',
      'Methamphetamine',
      'Opioids',
      'Prescription Drugs',
      'Tobacco / Nicotine',
    ],
    'Body-focused behaviors': [
      'Cheek Biting',
      'Hair Pulling',
      'Knuckle Cracking',
      'Lip Biting',
      'Nail Biting',
      'Pica (Non-food Eating)',
      'Self-harm',
      'Skin Picking',
    ],
    'Impulsive behaviors': [
      'Compulsive Spending',
      'Excessive Exercising',
      'Gambling',
      'Online Shopping',
      'Shoplifting',
      'Stealing',
    ],
    'Social behaviors': [
      'Anger',
      'Attention Seeking',
      'Bad Language (Swearing)',
      'Codependency',
      'Gossiping',
      'Lying',
      'Stalking',
      'Toxic Relationships',
    ],
    'Technology': [
      'Chatbots (AI)',
      'Dating Apps',
      'Doomscrolling',
      'Instagram',
      'Internet',
      'Online Videos',
      'Short-Form Videos',
      'Social Media',
      'TikTok',
      'Video Games',
      'Virtual Reality',
    ],
  };

  Map<String, List<String>> get _filtered {
    if (_searchQuery.isEmpty) return _categories;
    final q = _searchQuery.toLowerCase();
    final result = <String, List<String>>{};
    for (final entry in _categories.entries) {
      final matches =
          entry.value.where((v) => v.toLowerCase().contains(q)).toList();
      if (matches.isNotEmpty) result[entry.key] = matches;
    }
    return result;
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
          icon: const Icon(Icons.arrow_back_rounded,
              color: AarohaColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AarohaConstants.space24,
              AarohaConstants.space8,
              AarohaConstants.space24,
              AarohaConstants.space16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What are you quitting?',
                  style: AarohaTextStyles.headlineSm
                      .copyWith(color: AarohaColors.onSurface),
                ),
                const SizedBox(height: AarohaConstants.space6),
                Text(
                  'You can add more later.',
                  style: AarohaTextStyles.bodyMd
                      .copyWith(color: AarohaColors.onSurfaceVariant),
                ),
                const SizedBox(height: AarohaConstants.space16),
                // Search bar
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: AarohaTextStyles.bodyLg
                      .copyWith(color: AarohaColors.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AarohaColors.outline, size: 20),
                    filled: true,
                    fillColor: AarohaColors.surfaceContainerHigh,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AarohaConstants.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AarohaConstants.space16,
                      vertical: AarohaConstants.space12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(height: 1, color: AarohaColors.outlineVariant),

          // ── List ────────────────────────────────────────────
          Expanded(
            child: ListView(
              children: [
                for (final entry in filtered.entries) ...[
                  // Category header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AarohaConstants.space24,
                      AarohaConstants.space16,
                      AarohaConstants.space24,
                      AarohaConstants.space8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.key,
                            style: AarohaTextStyles.labelMd.copyWith(
                              color: const Color(0xFF007A5E),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const Icon(Icons.remove,
                            color: AarohaColors.outline, size: 16),
                      ],
                    ),
                  ),
                  // Items
                  for (final item in entry.value)
                    _SelectionTile(
                      label: item,
                      selected: _selected == item,
                      onTap: () => setState(() => _selected = item),
                    ),
                ],
                // Add custom
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AarohaConstants.space24,
                  ),
                  title: Text(
                    'Add a custom addiction',
                    style: AarohaTextStyles.bodyLg.copyWith(
                      color: AarohaColors.onSurfaceVariant,
                    ),
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: AarohaConstants.space80),
              ],
            ),
          ),

          Container(height: 1, color: AarohaColors.outlineVariant),

          // ── Next ────────────────────────────────────────────
          _NextBar(
            enabled: _selected != null,
            onNext: () => context.go(Routes.soberStartDate,
                extra: {'quitting': _selected}),
          ),
        ],
      ),
    );
  }
}

class _SelectionTile extends StatelessWidget {
  const _SelectionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
              child: Text(
                label,
                style: AarohaTextStyles.bodyLg.copyWith(
                  color: selected
                      ? AarohaColors.onSurface
                      : AarohaColors.onSurface,
                ),
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

class _NextBar extends StatelessWidget {
  const _NextBar({required this.enabled, required this.onNext});

  final bool enabled;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AarohaColors.background,
      padding: const EdgeInsets.fromLTRB(
        AarohaConstants.space24,
        AarohaConstants.space16,
        AarohaConstants.space24,
        AarohaConstants.space24,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: enabled ? onNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                enabled ? const Color(0xFF007A5E) : AarohaColors.surfaceContainerHighest,
            foregroundColor:
                enabled ? Colors.white : AarohaColors.outline,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AarohaConstants.radiusMd),
            ),
            elevation: 0,
          ),
          child: Text(
            'Next',
            style: AarohaTextStyles.labelLg.copyWith(
              color: enabled ? Colors.white : AarohaColors.outline,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
