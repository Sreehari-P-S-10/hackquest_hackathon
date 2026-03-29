import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_model.dart';
import '../domain/app_stats_model.dart';
import '../services/user_service.dart';

// ── User notifier ──────────────────────────────────────────────
class UserNotifier extends Notifier<UserModel> {
  @override
  UserModel build() => UserService.instance.getUser();

  /// Saves a complete UserModel and refreshes state.
  Future<void> save(UserModel updated) async {
    await UserService.instance.saveUser(updated);
    state = UserService.instance.getUser();
  }

  Future<void> updateName(String name) async {
    await UserService.instance.updateName(name);
    state = UserService.instance.getUser();
  }

  Future<void> updateGoals(List<String> goals) async {
    await UserService.instance.updateGoals(goals);
    state = UserService.instance.getUser();
  }

  Future<void> updateSobrietyImportance(String val) async {
    await UserService.instance.updateSobrietyImportance(val);
    state = UserService.instance.getUser();
  }

  Future<void> updateCheckInTimes(String morning, String evening) async {
    await UserService.instance.updateCheckInTimes(morning, evening);
    state = UserService.instance.getUser();
  }
}

final userProvider = NotifierProvider<UserNotifier, UserModel>(
  UserNotifier.new,
);

// ── Stats notifier ─────────────────────────────────────────────
class StatsNotifier extends Notifier<AppStatsModel> {
  @override
  AppStatsModel build() => UserService.instance.getStats();

  void _refresh() => state = UserService.instance.getStats();

  Future<void> goalCompleted() async {
    await UserService.instance.incrementGoalsCompleted();
    _refresh();
  }

  Future<void> streakRestarted() async {
    await UserService.instance.incrementStreakRestarts();
    _refresh();
  }

  Future<void> chatMessageSent() async {
    await UserService.instance.incrementChatMessages();
    _refresh();
  }

  Future<void> moodCheckin() async {
    await UserService.instance.incrementMoodCheckins();
    _refresh();
  }

  Future<void> breathworkStarted() async {
    await UserService.instance.incrementBreathworkSessions();
    _refresh();
  }

  Future<void> cravingJournalSaved() async {
    await UserService.instance.incrementCravingJournal();
    _refresh();
  }

  Future<void> soundscapePlayed() async {
    await UserService.instance.incrementSoundscapesPlayed();
    _refresh();
  }

  Future<void> quoteLiked() async {
    await UserService.instance.incrementQuotesLiked();
    _refresh();
  }

  Future<void> hopeWallPosted() async {
    await UserService.instance.incrementHopeWallPosts();
    _refresh();
  }

  Future<void> storyRead() async {
    await UserService.instance.incrementStoriesRead();
    _refresh();
  }

  Future<void> centreCalled() async {
    await UserService.instance.incrementCentreCallsMade();
    _refresh();
  }

  Future<void> eventJoined() async {
    await UserService.instance.incrementEventsJoined();
    _refresh();
  }

  Future<void> resourceViewed() async {
    await UserService.instance.incrementResourcesViewed();
    _refresh();
  }

  Future<void> reset() async {
    await UserService.instance.resetStats();
    _refresh();
  }
}

final statsProvider = NotifierProvider<StatsNotifier, AppStatsModel>(
  StatsNotifier.new,
);
