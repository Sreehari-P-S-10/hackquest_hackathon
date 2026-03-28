// lib/features/onboarding/presentation/widgets/step_scaffold.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
/// Shared scaffold for all onboarding questionnaire steps.
/// Provides consistent back button, title, subtitle, scrollable body,
/// and a bottom-pinned Next button.
class StepScaffold extends StatelessWidget {
  const StepScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    required this.onNext,
    this.nextLabel = 'Next',
    this.nextEnabled = true,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final VoidCallback onNext;
  final String nextLabel;
  final bool nextEnabled;

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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AarohaConstants.space24,
              AarohaConstants.space8,
              AarohaConstants.space24,
              AarohaConstants.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AarohaTextStyles.headlineSm.copyWith(
                    color: AarohaColors.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AarohaConstants.space6),
                  Text(
                    subtitle!,
                    style: AarohaTextStyles.bodyMd.copyWith(
                      color: AarohaColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Thin divider
          Container(height: 1, color: AarohaColors.outlineVariant),

          // ── Scrollable content ─────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AarohaConstants.space24,
                vertical: AarohaConstants.space24,
              ),
              child: body,
            ),
          ),

          // Thin divider
          Container(height: 1, color: AarohaColors.outlineVariant),

          // ── Next button ───────────────────────────────────
          Container(
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
                onPressed: nextEnabled ? onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: nextEnabled
                      ? const Color(0xFF0EA5EA)
                      : AarohaColors.surfaceContainerHighest,
                  foregroundColor:
                      nextEnabled ? Colors.white : AarohaColors.outline,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AarohaConstants.radiusMd),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  nextLabel,
                  style: AarohaTextStyles.labelLg.copyWith(
                    color: nextEnabled ? Colors.white : AarohaColors.outline,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
