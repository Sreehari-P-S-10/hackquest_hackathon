import 'package:hive_flutter/hive_flutter.dart';
import '../domain/user_model.dart';
import '../domain/app_stats_model.dart';

/// Simulates a backend user service.
/// All reads and writes go through here — screens never touch Hive directly.
class UserService {
  UserService._();
  static final UserService instance = UserService._();

  static const String _userBoxName  = 'aaroha_user';
  static const String _statsBoxName = 'aaroha_stats';
  static const String _userKey      = 'current_user';
  static const String _statsKey     = 'app_stats';

  // ── Box accessors ──────────────────────────────────────────
  Box<UserModel>     get _userBox  => Hive.box<UserModel>(_userBoxName);
  Box<AppStatsModel> get _statsBox => Hive.box<AppStatsModel>(_statsBoxName);

  // ── Initialise (call once from main.dart) ──────────────────
  static Future<void> init() async {
    // Register adapters if not already done
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(AppStatsModelAdapter());
    }

    await Hive.openBox<UserModel>(_userBoxName);
    await Hive.openBox<AppStatsModel>(_statsBoxName);

    // Seed default user on first launch
    if (!Hive.box<UserModel>(_userBoxName).containsKey(_userKey)) {
      await _seedDefaultUser();
    }
    // Seed stats on first launch
    if (!Hive.box<AppStatsModel>(_statsBoxName).containsKey(_statsKey)) {
      await _seedDefaultStats();
    }
  }

  static Future<void> _seedDefaultUser() async {
    final user = UserModel(
      name: 'Aaroha User',
      quitting: 'Alcohol',
      userType: 'privateUser',
      soberStartDate: DateTime.now().subtract(const Duration(days: 12)),
      morningCheckIn: '08:00',
      eveningCheckIn: '20:00',
      improvementGoals: ['Improve mental health', 'Sleep better'],
      sobrietyImportance: 'Very',
    );
    await Hive.box<UserModel>(_userBoxName).put(_userKey, user);
  }

  static Future<void> _seedDefaultStats() async {
    await Hive.box<AppStatsModel>(_statsBoxName).put(
      _statsKey,
      AppStatsModel(goalsCompleted: 2), // reflect the 2 pre-ticked goals
    );
  }

  // ── READ ───────────────────────────────────────────────────

  /// Returns the current user. Always non-null after [init].
  UserModel getUser() => _userBox.get(_userKey)!;

  /// Returns usage statistics. Always non-null after [init].
  AppStatsModel getStats() => _statsBox.get(_statsKey)!;

  // ── UPDATE user ────────────────────────────────────────────

  Future<void> updateName(String name) async {
    final user = getUser()..name = name.trim().isEmpty ? 'Aaroha User' : name.trim();
    await user.save();
  }

  Future<void> updateQuitting(String quitting) async {
    final user = getUser()..quitting = quitting;
    await user.save();
  }

  Future<void> updateCheckInTimes(String morning, String evening) async {
    final user = getUser()
      ..morningCheckIn = morning
      ..eveningCheckIn = evening;
    await user.save();
  }

  Future<void> updateGoals(List<String> goals) async {
    final user = getUser()..improvementGoals = goals;
    await user.save();
  }

  Future<void> updateSobrietyImportance(String importance) async {
    final user = getUser()..sobrietyImportance = importance;
    await user.save();
  }

  /// Fully replaces the user profile (used by edit screen).
  Future<void> saveUser(UserModel updated) async {
    await _userBox.put(_userKey, updated);
  }

  // ── UPDATE stats (individual counters) ─────────────────────

  Future<void> _saveStats(AppStatsModel s) async => s.save();

  Future<void> incrementGoalsCompleted() async {
    final s = getStats();
    s.goalsCompleted++;
    await _saveStats(s);
  }

  Future<void> incrementStreakRestarts() async {
    final s = getStats();
    s.streakRestarts++;
    await _saveStats(s);
  }

  Future<void> incrementChatMessages() async {
    final s = getStats();
    s.chatMessagesSent++;
    await _saveStats(s);
  }

  Future<void> incrementMoodCheckins() async {
    final s = getStats();
    s.moodCheckins++;
    await _saveStats(s);
  }

  Future<void> incrementBreathworkSessions() async {
    final s = getStats();
    s.breathworkSessions++;
    await _saveStats(s);
  }

  Future<void> incrementCravingJournal() async {
    final s = getStats();
    s.cravingJournalEntries++;
    await _saveStats(s);
  }

  Future<void> incrementSoundscapesPlayed() async {
    final s = getStats();
    s.soundscapesPlayed++;
    await _saveStats(s);
  }

  Future<void> incrementQuotesLiked() async {
    final s = getStats();
    s.quotesLiked++;
    await _saveStats(s);
  }

  Future<void> incrementHopeWallPosts() async {
    // final s = getStats()..hopeWallPosts++;
    // await _saveStats(s);
      final s = await getStats();
      s.hopeWallPosts++;
      await _saveStats(s);
  }

  Future<void> incrementStoriesRead() async {
    final s = getStats();
    s.storiesRead++;
    await _saveStats(s);
  }

  Future<void> incrementCentreCallsMade() async {
    final s = getStats();
    s.centreCallsMade++;
    await _saveStats(s);
  }

  Future<void> incrementEventsJoined() async {
    final s = getStats();
    s.eventsJoined++;
    await _saveStats(s);
  }

  Future<void> incrementResourcesViewed() async {
    final s = getStats();
    s.resourcesViewed++;
    await _saveStats(s);
  }

  // ── DELETE / RESET ─────────────────────────────────────────

  /// Resets all stats to zero (useful for testing or "fresh start").
  Future<void> resetStats() async {
    await _statsBox.put(_statsKey, AppStatsModel());
  }

  /// Completely wipes user + stats (acts as "sign out / reset app").
  Future<void> deleteAll() async {
    await _userBox.clear();
    await _statsBox.clear();
  }
}
