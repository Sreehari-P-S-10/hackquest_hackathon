// lib/features/onboarding/domain/onboarding_state.dart

/// Holds all answers collected during the onboarding questionnaire.
/// Passed forward via GoRouter `extra` or a simple InheritedWidget.
class OnboardingState {
  String quitting = '';
  DateTime soberStartDate = DateTime.now();
  bool isFutureDate = false;
  int daysPerWeek = 0;
  List<bool> drinkDays = List.filled(7, true);
  int drinksPerDay = 0;
  List<String> improvementGoals = [];
  String sobrietyImportance = '';
  String involvePreference = '';
  String whyQuit = '';
  String identity = '';
  String firstMilestone = '';
  String morningCheckIn = '08:00';
  String eveningCheckIn = '20:00';

  OnboardingState();
}
