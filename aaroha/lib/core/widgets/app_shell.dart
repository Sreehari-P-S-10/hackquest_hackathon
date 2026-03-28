import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';
import 'sos_bottom_sheet.dart';
import 'aaroha_app_bar.dart';
import 'aaroha_drawer.dart';

/// Persistent shell: Drawer + AppBar + BottomNav + SOS FAB
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({super.key, required this.navigationShell});

  static const _tabs = [
    _NavTab(icon: Icons.directions_walk_rounded, label: 'Tracker', index: 0),
    _NavTab(icon: Icons.smart_toy_rounded,        label: 'Swasthi', index: 1),
    _NavTab(icon: Icons.self_improvement_rounded, label: 'Shanti',  index: 2),
    _NavTab(icon: Icons.wb_sunny_rounded,         label: 'Ujjwal',  index: 3),
    _NavTab(icon: Icons.location_on_rounded,      label: 'Sangam',  index: 4),
    _NavTab(icon: Icons.import_contacts_rounded,  label: 'Hub',     index: 5),
  ];

  void _onTabTapped(BuildContext context, int index) {
    HapticFeedback.selectionClick();
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  void _showSOS(BuildContext context) {
    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SosBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Swasthi (index 1) has its own input bar — hide FAB to avoid overlap
    final bool isSwasthiTab = navigationShell.currentIndex == 1;

    return Scaffold(
      backgroundColor: AarohaColors.background,
      drawer: const AarohaDrawer(),
      appBar: AarohaAppBar(onSOS: () => _showSOS(context)),
      body: navigationShell,
      bottomNavigationBar: _GlassBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => _onTabTapped(context, i),
        tabs: _tabs,
      ),
      // Hide FAB on Swasthi tab — SOS is still accessible via AppBar button
      floatingActionButton: isSwasthiTab
          ? null
          : FloatingActionButton(
              onPressed: () => _showSOS(context),
              backgroundColor: AarohaColors.tertiary,
              foregroundColor: AarohaColors.onTertiary,
              elevation: 0,
              tooltip: 'Crisis support',
              child: const Icon(Icons.emergency_rounded, size: 28),
            ),
    );
  }
}

class _GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_NavTab> tabs;
  const _GlassBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AarohaColors.surface.withValues(alpha: 0.88),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AarohaConstants.radiusLg),
        ),
        boxShadow: [
          BoxShadow(
            color: AarohaColors.onSurface.withValues(
              alpha: AarohaConstants.ambientShadowOpacity,
            ),
            blurRadius: AarohaConstants.ambientShadowBlur,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: tabs.map((tab) {
              final isActive = currentIndex == tab.index;
              return GestureDetector(
                onTap: () => onTap(tab.index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: isActive ? 14 : 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AarohaColors.surfaceContainerHighest
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tab.icon,
                        size: 22,
                        color: isActive
                            ? AarohaColors.primary
                            : AarohaColors.outline,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tab.label,
                        style: AarohaTextStyles.labelSm.copyWith(
                          color: isActive
                              ? AarohaColors.primary
                              : AarohaColors.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  final IconData icon;
  final String label;
  final int index;
  const _NavTab({required this.icon, required this.label, required this.index});
}