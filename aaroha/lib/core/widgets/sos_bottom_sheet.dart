import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';

/// Crisis support modal — one-tap helpline access
class SosBottomSheet extends StatelessWidget {
  const SosBottomSheet({super.key});

  Future<void> _call(String tel) async {
    final uri = Uri.parse(tel);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AarohaColors.surface,
        borderRadius: BorderRadius.circular(AarohaConstants.radiusXl),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AarohaColors.tertiary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.crisis_alert_rounded,
                  color: AarohaColors.tertiary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crisis Support',
                    style: AarohaTextStyles.titleLg.copyWith(
                      color: AarohaColors.onSurface,
                    ),
                  ),
                  Text(
                    'You are not alone. Help is here.',
                    style: AarohaTextStyles.bodySm.copyWith(
                      color: AarohaColors.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Helplines
          ...AarohaConstants.helplines.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _HelplineTile(
                name: h['name']!,
                label: h['label']!,
                note: h['note'],
                onTap: () => _call(h['number']!),
              ),
            ),
          ),

          const SizedBox(height: 4),
          Center(
            child: Text(
              'Anonymous · Confidential',
              style: AarohaTextStyles.overline.copyWith(
                color: AarohaColors.outline,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Close button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AarohaColors.onSurface,
                side: BorderSide.none,
                backgroundColor: AarohaColors.surfaceContainerHigh,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Close',
                style: AarohaTextStyles.labelLg.copyWith(
                  color: AarohaColors.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelplineTile extends StatelessWidget {
  final String name;
  final String label;
  final String? note;
  final VoidCallback onTap;

  const _HelplineTile({
    required this.name,
    required this.label,
    this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AarohaColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.toUpperCase(),
                    style: AarohaTextStyles.overline.copyWith(
                      color: AarohaColors.tertiary,
                    ),
                  ),
                  Text(
                    label,
                    style: AarohaTextStyles.labelLg.copyWith(
                      color: AarohaColors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (note != null)
                    Text(
                      note!,
                      style: AarohaTextStyles.bodySm.copyWith(
                        color: AarohaColors.outline,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AarohaColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.call_rounded,
                color: AarohaColors.primary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
