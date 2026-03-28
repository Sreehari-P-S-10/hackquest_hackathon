// lib/features/onboarding/presentation/widgets/onboarding_widgets.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';

/// Standard text field for onboarding forms
class AarohaFormField extends StatelessWidget {
  const AarohaFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.maxLines = 1,
    this.optional = false,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final int maxLines;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AarohaTextStyles.labelMd.copyWith(
                color: AarohaColors.onSurfaceVariant,
                letterSpacing: 0.3,
              ),
            ),
            if (optional) ...[
              const SizedBox(width: 4),
              Text(
                '(optional)',
                style: AarohaTextStyles.labelSm.copyWith(
                  color: AarohaColors.outline,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AarohaConstants.space8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          validator: validator,
          style: AarohaTextStyles.bodyLg.copyWith(
            color: AarohaColors.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon,
                    color: AarohaColors.outline, size: 20)
                : null,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

/// Section header for grouping form fields
class FormSectionHeader extends StatelessWidget {
  const FormSectionHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AarohaTextStyles.headlineSm.copyWith(
            color: AarohaColors.onSurface,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AarohaConstants.space4),
          Text(
            subtitle!,
            style: AarohaTextStyles.bodyMd.copyWith(
              color: AarohaColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// Multi-select chip group
class ChipSelector extends StatelessWidget {
  const ChipSelector({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.optional = false,
  });

  final String label;
  final List<String> options;
  final List<String> selected;
  final void Function(List<String>) onChanged;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AarohaTextStyles.labelMd.copyWith(
                color: AarohaColors.onSurfaceVariant,
                letterSpacing: 0.3,
              ),
            ),
            if (optional) ...[
              const SizedBox(width: 4),
              Text(
                '(optional)',
                style: AarohaTextStyles.labelSm.copyWith(
                  color: AarohaColors.outline,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AarohaConstants.space10),
        Wrap(
          spacing: AarohaConstants.space8,
          runSpacing: AarohaConstants.space8,
          children: options.map((opt) {
            final isSelected = selected.contains(opt);
            return GestureDetector(
              onTap: () {
                final updated = List<String>.from(selected);
                if (isSelected) {
                  updated.remove(opt);
                } else {
                  updated.add(opt);
                }
                onChanged(updated);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: AarohaConstants.space16,
                  vertical: AarohaConstants.space8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AarohaColors.primary
                      : AarohaColors.surfaceContainerHigh,
                  borderRadius:
                      BorderRadius.circular(AarohaConstants.radiusFull),
                  border: Border.all(
                    color: isSelected
                        ? AarohaColors.primary
                        : AarohaColors.outlineVariant,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  opt,
                  style: AarohaTextStyles.labelMd.copyWith(
                    color: isSelected
                        ? AarohaColors.onPrimary
                        : AarohaColors.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Single-select option list (radio-style)
class RadioOptionList extends StatelessWidget {
  const RadioOptionList({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.optional = false,
  });

  final String label;
  final List<String> options;
  final String? selected;
  final void Function(String) onChanged;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AarohaTextStyles.labelMd.copyWith(
                color: AarohaColors.onSurfaceVariant,
                letterSpacing: 0.3,
              ),
            ),
            if (optional) ...[
              const SizedBox(width: 4),
              Text(
                '(optional)',
                style: AarohaTextStyles.labelSm.copyWith(
                  color: AarohaColors.outline,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AarohaConstants.space8),
        ...options.map((opt) {
          final isSelected = selected == opt;
          return Padding(
            padding: const EdgeInsets.only(bottom: AarohaConstants.space8),
            child: GestureDetector(
              onTap: () => onChanged(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: AarohaConstants.space16,
                  vertical: AarohaConstants.space14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AarohaColors.primary.withOpacity(0.07)
                      : AarohaColors.surfaceContainerLow,
                  borderRadius:
                      BorderRadius.circular(AarohaConstants.radiusMd),
                  border: Border.all(
                    color: isSelected
                        ? AarohaColors.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        opt,
                        style: AarohaTextStyles.bodyLg.copyWith(
                          color: isSelected
                              ? AarohaColors.primary
                              : AarohaColors.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AarohaColors.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? AarohaColors.primary
                              : AarohaColors.outlineVariant,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              color: AarohaColors.onPrimary, size: 12)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// Extra spacing constant needed
extension on AarohaConstants {
  static const double space10 = 10;
  static const double space14 = 14;
}

// We expose these as top-level consts to avoid extension issues
const double kSpace10 = 10;
const double kSpace14 = 14;
