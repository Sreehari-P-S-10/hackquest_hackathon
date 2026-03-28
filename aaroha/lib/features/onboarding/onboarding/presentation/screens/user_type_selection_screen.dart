// lib/features/onboarding/presentation/screens/user_type_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/app_router.dart';
import '../../domain/onboarding_models.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  State<UserTypeSelectionScreen> createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen>
    with SingleTickerProviderStateMixin {
  UserType? _selected;
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_selected == null) return;
    switch (_selected!) {
      case UserType.privateUser:
        context.go(Routes.privateUserQuestions);
      case UserType.familyMember:
        context.go(Routes.familyQuestions);
      case UserType.supportCommunity:
        context.go(Routes.communitySetup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AarohaColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AarohaColors.heroGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.spa_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(height: 20),
                    Text('Who are you?',
                        style: AarohaTextStyles.headlineLg
                            .copyWith(color: AarohaColors.onSurface)),
                    const SizedBox(height: 8),
                    Text(
                      'This helps us personalise\nyour experience.',
                      style: AarohaTextStyles.bodyLg
                          .copyWith(color: AarohaColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _TypeCard(
                      icon: Icons.person_outline_rounded,
                      title: 'Private User',
                      description:
                          "I'm seeking support for myself or someone I care about",
                      selected: _selected == UserType.privateUser,
                      onTap: () =>
                          setState(() => _selected = UserType.privateUser),
                    ),
                    const SizedBox(height: 12),
                    _TypeCard(
                      icon: Icons.family_restroom_rounded,
                      title: 'Family Member',
                      description:
                          "I want to support a loved one on their recovery journey",
                      selected: _selected == UserType.familyMember,
                      onTap: () =>
                          setState(() => _selected = UserType.familyMember),
                    ),
                    const SizedBox(height: 12),
                    _TypeCard(
                      icon: Icons.groups_2_rounded,
                      title: 'Support Community',
                      description:
                          'NGO, rehab centre or organisation offering recovery services',
                      selected: _selected == UserType.supportCommunity,
                      onTap: () => setState(
                          () => _selected = UserType.supportCommunity),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: AnimatedOpacity(
                  opacity: _selected != null ? 1.0 : 0.4,
                  duration: const Duration(milliseconds: 200),
                  child: ElevatedButton(
                    onPressed: _selected != null ? _onContinue : null,
                    child: const Text('Continue'),
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

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected
            ? AarohaColors.primary.withOpacity(0.07)
            : AarohaColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: selected ? AarohaColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: selected
                        ? AarohaColors.primary
                        : AarohaColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon,
                      color: selected
                          ? Colors.white
                          : AarohaColors.onSurfaceVariant,
                      size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: AarohaTextStyles.titleMd.copyWith(
                              color: selected
                                  ? AarohaColors.primary
                                  : AarohaColors.onSurface)),
                      const SizedBox(height: 4),
                      Text(description,
                          style: AarohaTextStyles.bodyMd.copyWith(
                              color: AarohaColors.onSurfaceVariant)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AarohaColors.primary : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? AarohaColors.primary
                          : AarohaColors.outlineVariant,
                      width: 2,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
