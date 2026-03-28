// lib/features/onboarding/presentation/screens/privacy_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/app_router.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AarohaConstants.space24,
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // ── Shield icon ──────────────────────────────────
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF007A5E).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: const Color(0xFF007A5E),
                  size: 38,
                ),
              ),
              const SizedBox(height: AarohaConstants.space24),

              // ── Title ─────────────────────────────────────────
              Text(
                'Privacy is fundamental\nto sobriety',
                textAlign: TextAlign.center,
                style: AarohaTextStyles.headlineSm.copyWith(
                  color: AarohaColors.onSurface,
                ),
              ),
              const SizedBox(height: AarohaConstants.space20),

              // ── Body text ─────────────────────────────────────
              Text(
                'We use your data to generate anonymous statistics. We never share or sell your information.',
                textAlign: TextAlign.center,
                style: AarohaTextStyles.bodyLg.copyWith(
                  color: AarohaColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AarohaConstants.space16),
              Text(
                'Also by agreeing, you are confirming that you are at least 18 years of age.',
                textAlign: TextAlign.center,
                style: AarohaTextStyles.bodyLg.copyWith(
                  color: AarohaColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AarohaConstants.space32),

              // ── Question ──────────────────────────────────────
              Text(
                'Is this okay with you?',
                textAlign: TextAlign.center,
                style: AarohaTextStyles.titleMd.copyWith(
                  color: AarohaColors.onSurface,
                ),
              ),
              const Spacer(flex: 2),

              // ── Yes button ────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go(Routes.whatQuitting),
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
                    'Yes, We Are Good',
                    style: AarohaTextStyles.labelLg
                        .copyWith(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: AarohaConstants.space12),

              // ── How we use data ───────────────────────────────
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showDataUsageSheet(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF007A5E),
                    minimumSize: const Size.fromHeight(56),
                    side: const BorderSide(
                        color: const Color(0xFF007A5E), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AarohaConstants.radiusMd),
                    ),
                  ),
                  child: Text(
                    'How we use your data',
                    style: AarohaTextStyles.labelLg.copyWith(
                      color: const Color(0xFF007A5E),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AarohaConstants.space16),

              // ── No thanks ─────────────────────────────────────
              TextButton(
                onPressed: () => context.go(Routes.welcome),
                child: Text(
                  "No, please don't",
                  style: AarohaTextStyles.bodyMd.copyWith(
                    color: AarohaColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: AarohaConstants.space24),
            ],
          ),
        ),
      ),
    );
  }

  void _showDataUsageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AarohaConstants.space32),
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
                  borderRadius:
                      BorderRadius.circular(AarohaConstants.radiusFull),
                ),
              ),
            ),
            const SizedBox(height: AarohaConstants.space20),
            Text('How we use your data',
                style: AarohaTextStyles.titleLg
                    .copyWith(color: AarohaColors.onSurface)),
            const SizedBox(height: AarohaConstants.space16),
            const _DataPoint(
              icon: Icons.bar_chart_rounded,
              title: 'Anonymous statistics',
              body:
                  'We aggregate data to understand recovery trends. Nothing is tied to your identity.',
            ),
            const SizedBox(height: AarohaConstants.space12),
            const _DataPoint(
              icon: Icons.lock_outline_rounded,
              title: 'Stored on your device',
              body:
                  'Your personal data stays local unless you explicitly choose to back it up.',
            ),
            const SizedBox(height: AarohaConstants.space12),
            const _DataPoint(
              icon: Icons.block_rounded,
              title: 'Never sold',
              body:
                  'We do not sell, share or rent your information to any third party.',
            ),
            const SizedBox(height: AarohaConstants.space32),
          ],
        ),
      ),
    );
  }
}

class _DataPoint extends StatelessWidget {
  const _DataPoint({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AarohaColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AarohaConstants.radiusMd),
          ),
          child: Icon(icon, color: AarohaColors.primary, size: 20),
        ),
        const SizedBox(width: AarohaConstants.space12),
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
