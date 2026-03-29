import 'package:hive/hive.dart';

part 'app_stats_model.g.dart';

/// Tracks usage statistics for every screen action.
/// Each counter increments whenever the user performs that action,
/// giving the Profile page meaningful "activity" data to display.
@HiveType(typeId: 11)
class AppStatsModel extends HiveObject {
  // Tracker
  @HiveField(0)
  int goalsCompleted;

  @HiveField(1)
  int streakRestarts;

  // Swasthi (AI chat)
  @HiveField(2)
  int chatMessagesSent;

  @HiveField(3)
  int moodCheckins;

  // Shanti (calm space)
  @HiveField(4)
  int breathworkSessions;

  @HiveField(5)
  int cravingJournalEntries;

  @HiveField(6)
  int soundscapesPlayed;

  // Ujjwal (feed)
  @HiveField(7)
  int quotesLiked;

  @HiveField(8)
  int hopeWallPosts;

  @HiveField(9)
  int storiesRead;

  // Sangam
  @HiveField(10)
  int centreCallsMade;

  @HiveField(11)
  int eventsJoined;

  // Hub
  @HiveField(12)
  int resourcesViewed;

  AppStatsModel({
    this.goalsCompleted = 0,
    this.streakRestarts = 0,
    this.chatMessagesSent = 0,
    this.moodCheckins = 0,
    this.breathworkSessions = 0,
    this.cravingJournalEntries = 0,
    this.soundscapesPlayed = 0,
    this.quotesLiked = 0,
    this.hopeWallPosts = 0,
    this.storiesRead = 0,
    this.centreCallsMade = 0,
    this.eventsJoined = 0,
    this.resourcesViewed = 0,
  });

  /// Total actions performed across all screens.
  int get totalActions =>
      goalsCompleted +
      chatMessagesSent +
      moodCheckins +
      breathworkSessions +
      cravingJournalEntries +
      soundscapesPlayed +
      quotesLiked +
      hopeWallPosts +
      storiesRead +
      centreCallsMade +
      eventsJoined +
      resourcesViewed;
}
