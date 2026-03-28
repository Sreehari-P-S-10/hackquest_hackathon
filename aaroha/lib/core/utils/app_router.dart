import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/tracker/presentation/screens/tracker_screen.dart';
import '../../features/swasthi/presentation/screens/swasthi_screen.dart';
import '../../features/shanti/presentation/screens/shanti_screen.dart';
import '../../features/ujjwal/presentation/screens/ujjwal_screen.dart';
import '../../features/sangam/presentation/screens/sangam_screen.dart';
import '../../features/hub/presentation/screens/hub_screen.dart';
import '../../features/onboarding/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/onboarding/onboarding/presentation/screens/user_type_selection_screen.dart';
import '../../features/onboarding/onboarding/presentation/screens/sign_in_screen.dart';
import '../../features/onboarding/onboarding/presentation/screens/private_user_questions.dart';
import '../../features/onboarding/onboarding/presentation/screens/family_questions.dart';
import '../../features/onboarding/onboarding/presentation/screens/community_setup.dart';
import '../../features/onboarding/onboarding/presentation/screens/community_dashboard_screen.dart';
import '../../features/onboarding/onboarding/presentation/screens/privacy_screen.dart';
import '../widgets/app_shell.dart';

/// Named route constants
class Routes {
  Routes._();

  // Entry
  static const String welcome              = '/';
  static const String signIn               = '/sign-in';

  // User type selection
  static const String userTypeSelection    = '/who-are-you';

  // Private user — entry point only (rest via Navigator.push)
  static const String privateUserQuestions = '/private-questions';

  // Family member — entry point only
  static const String familyQuestions      = '/family-questions';

  // Community — entry point only
  static const String communitySetup       = '/community-setup';

  // Community dashboard (after setup)
  static const String communityDashboard   = '/community-dashboard';

  // Privacy
  static const String privacyScreen        = '/privacy';

  // Questionnaire flow
  static const String whatQuitting         = '/what-quitting';
  static const String soberStartDate       = '/sober-start-date';
  static const String daysPerWeek          = '/days-per-week';
  static const String drinksPerDay         = '/drinks-per-day';
  static const String improvementGoals     = '/improvement-goals';
  static const String sobrietyImportance   = '/sobriety-importance';
  static const String onboardingSummary    = '/onboarding-summary';

  // Main app
  static const String tracker  = '/tracker';
  static const String swasthi  = '/swasthi';
  static const String shanti   = '/shanti';
  static const String ujjwal   = '/ujjwal';
  static const String sangam   = '/sangam';
  static const String hub      = '/hub';
}

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.welcome,
  routes: [
    // ── Onboarding ───────────────────────────────────────────
    GoRoute(
      path: Routes.welcome,
      builder: (_, __) => const WelcomeScreen(),
    ),
    GoRoute(
      path: Routes.signIn,
      builder: (_, __) => const SignInScreen(),
    ),
    GoRoute(
      path: Routes.userTypeSelection,
      builder: (_, __) => const UserTypeSelectionScreen(),
    ),
    GoRoute(
      path: Routes.privacyScreen,
      builder: (_, __) => const PrivacyScreen(),
    ),
    GoRoute(
      path: Routes.whatQuitting,
      builder: (_, __) => const WhatQuittingScreen(),
    ),
    GoRoute(
      path: Routes.soberStartDate,
      builder: (_, __) => const SoberStartDateScreen(),
    ),
    GoRoute(
      path: Routes.daysPerWeek,
      builder: (_, __) => const DaysPerWeekScreen(),
    ),
    GoRoute(
      path: Routes.drinksPerDay,
      builder: (_, __) => const DrinksPerDayScreen(),
    ),
    GoRoute(
      path: Routes.improvementGoals,
      builder: (_, __) => const ImprovementGoalsScreen(),
    ),
    GoRoute(
      path: Routes.sobrietyImportance,
      builder: (_, __) => const SobrietyImportanceScreen(),
    ),
    GoRoute(
      path: Routes.onboardingSummary,
      builder: (_, __) => const OnboardingSummaryScreen(),
    ),

    // Private user: entry → PrivacyConsentScreen, rest via Navigator.push
    GoRoute(
      path: Routes.privateUserQuestions,
      builder: (_, __) => const PrivacyConsentScreen(),
    ),

    // Family member: entry → FamilyRelationshipScreen, rest via Navigator.push
    GoRoute(
      path: Routes.familyQuestions,
      builder: (_, __) => const FamilyRelationshipScreen(),
    ),

    // Community: entry → CommunitySetupScreen, rest via Navigator.push
    GoRoute(
      path: Routes.communitySetup,
      builder: (_, __) => const CommunitySetupScreen(),
    ),
    GoRoute(
      path: Routes.communityDashboard,
      builder: (context, state) {
        final orgName = state.extra as String? ?? 'Organisation';
        return CommunityDashboardScreen(orgName: orgName);
      },
    ),

    // ── Main App (with shell) ────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.tracker,
              builder: (_, __) => const TrackerScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.swasthi,
              builder: (_, __) => const SwasthiScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.shanti,
              builder: (_, __) => const ShantiScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.ujjwal,
              builder: (_, __) => const UjjwalScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.sangam,
              builder: (_, __) => const SangamScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.hub,
              builder: (_, __) => const HubScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
