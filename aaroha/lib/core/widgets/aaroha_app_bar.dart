import 'package:aaroha/features/profile/presentations/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';


/// Persistent AppBar for all Aaroha screens.
/// The profile avatar in the top-right now navigates to ProfileScreen.
class AarohaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSOS;
  final String? title;
  final List<Widget>? actions;

  const AarohaAppBar({
    super.key,
    this.onSOS,
    this.title,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AarohaColors.surface,
      scrolledUnderElevation: 0.5,
      shadowColor: AarohaColors.outlineVariant.withOpacity(0.3),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AarohaColors.primary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AarohaConstants.appName,
            style: AarohaTextStyles.titleLg.copyWith(
              color: AarohaColors.primary,
              height: 1,
            ),
          ),
          Text(
            AarohaConstants.appTagline,
            style: AarohaTextStyles.overline.copyWith(
              color: AarohaColors.primaryContainer.withOpacity(0.8),
              letterSpacing: 1.2,
              height: 1,
            ),
          ),
        ],
      ),
      actions: [
        // SOS chip
        if (onSOS != null)
          GestureDetector(
            onTap: onSOS,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: AarohaColors.tertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AarohaConstants.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emergency_rounded,
                    color: AarohaColors.tertiary,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'SOS',
                    style: AarohaTextStyles.overline.copyWith(
                      color: AarohaColors.tertiary,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // ── Profile avatar — tapping opens ProfileScreen ─────
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: AarohaColors.surfaceContainerHighest,
              child: Icon(
                Icons.person_rounded,
                color: AarohaColors.primary,
                size: 20,
              ),
            ),
          ),
        ),
        ...?actions,
      ],
    );
  }
}
