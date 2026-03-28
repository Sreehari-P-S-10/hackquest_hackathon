import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Notification channel IDs
  static const String _goalChannelId = 'aaroha_goals';
  static const String _quoteChannelId = 'aaroha_quotes';
  static const String _reminderChannelId = 'aaroha_reminders';
  static const String _eventChannelId = 'aaroha_events';
  static const String _badgeChannelId = 'aaroha_badges';

  // Notification IDs
  static const int _dailyQuoteId = 1000;
  static const int _incompleteGoalBaseId = 2000;
  static const int _goalCompleteBaseId = 3000;
  static const int _badgeId = 4000;
  // Event notifications use IDs 5000 + index

  // SharedPreferences keys
  static const String _lastBadgeKey = 'aaroha_last_badge_days';
  static const String _lastCheckDateKey = 'aaroha_last_badge_check';

  // ── Milestones map ────────────────────────────────────────
  static const _milestones = [1, 3, 7, 14, 21, 30, 60, 90, 180, 365];
  static const _badgeNames = {
    1: 'First Step 🌱',
    3: 'Bronze Seed 🌿',
    7: 'Silver Root 🌾',
    14: 'Gold Branch 🌳',
    21: 'Platinum Leaf 🍃',
    30: 'Sapphire Tree 💙',
    60: 'Emerald Forest 💚',
    90: 'Diamond Grove 💎',
    180: 'Crystal Mountain ⛰️',
    365: 'Golden Year ✨',
  };

  // ── Initialise ────────────────────────────────────────────
  Future<void> init() async {
    tz.initializeTimeZones();

    // Android init
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS/macOS init
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create Android notification channels
    if (Platform.isAndroid) {
      await _createChannels();
    }

    // Request permissions on Android 13+
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> _createChannels() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    await android.createNotificationChannel(AndroidNotificationChannel(
      _goalChannelId,
      'Goal Completions',
      description: 'Notifications when you complete a daily goal',
      importance: Importance.high,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      playSound: true,
    ));

    await android.createNotificationChannel(AndroidNotificationChannel(
      _quoteChannelId,
      'Daily Quotes',
      description: 'Morning affirmation and quote notifications',
      importance: Importance.defaultImportance,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      playSound: true,
    ));

    await android.createNotificationChannel(AndroidNotificationChannel(
      _reminderChannelId,
      'Goal Reminders',
      description: 'Afternoon reminders for incomplete goals',
      importance: Importance.high,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      playSound: true,
    ));

    await android.createNotificationChannel(AndroidNotificationChannel(
      _eventChannelId,
      'Event Reminders',
      description: 'Reminders for upcoming recovery events',
      importance: Importance.high,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      playSound: true,
    ));

    await android.createNotificationChannel(AndroidNotificationChannel(
      _badgeChannelId,
      'Badge Achievements',
      description: 'Notifications when you earn a new badge',
      importance: Importance.high,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      playSound: true,
    ));
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle tap — extend with navigation if needed
    debugPrint('Notification tapped: ${response.id}');
  }

  // ── Notification details helpers ──────────────────────────
  NotificationDetails _details(String channelId, String channelName) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.high,
        priority: Priority.high,
        sound: const RawResourceAndroidNotificationSound('notification_sound'),
        playSound: true,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        sound: 'notification_sound.mp3',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      macOS: const DarwinNotificationDetails(
        sound: 'notification_sound.mp3',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  // ── FEATURE 1: Goal completed notification ────────────────
  Future<void> showGoalCompletedNotification(String goalTitle) async {
    await _plugin.show(
      _goalCompleteBaseId + goalTitle.hashCode.abs() % 1000,
      '🎉 Goal Completed!',
      'You completed "$goalTitle". Keep going — you\'re doing amazing!',
      _details(_goalChannelId, 'Goal Completions'),
    );
  }

  // ── FEATURE 2: Schedule daily quote at 8:00 AM ────────────
  Future<void> scheduleDailyQuote() async {
    // Cancel previous to avoid duplicates on re-schedule
    await _plugin.cancel(_dailyQuoteId);

    const quotes = [
      'Every moment sober is a victory worth celebrating.',
      'The comeback is always stronger than the setback.',
      'Progress, not perfection.',
      'You are braver than you believe.',
      'One day at a time — some days, one moment at a time.',
      'Cravings are waves — they rise, and they fall. You are the shore.',
      'Each new day is a new beginning.',
    ];

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      8, // 8:00 AM
      0,
    );

    // If 8 AM already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final quoteIndex = now.day % quotes.length;
    final quote = quotes[quoteIndex];

    await _plugin.zonedSchedule(
      _dailyQuoteId,
      '☀️ Your Morning Affirmation',
      '"$quote"',
      scheduledDate,
      _details(_quoteChannelId, 'Daily Quotes'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // repeat daily
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ── FEATURE 3: Incomplete goals reminder at 12:00 PM ─────
  Future<void> scheduleIncompleteGoalReminder(
    List<String> incompleteGoalTitles,
  ) async {
    // Cancel previous incomplete goal reminders
    for (var i = 0; i < 10; i++) {
      await _plugin.cancel(_incompleteGoalBaseId + i);
    }

    if (incompleteGoalTitles.isEmpty) return;

    final now = tz.TZDateTime.now(tz.local);
    final noon = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      12, // 12:00 PM noon
      0,
    );

    // If noon already passed, skip for today
    if (noon.isBefore(now)) return;

    final body = incompleteGoalTitles.length == 1
        ? 'Still pending: "${incompleteGoalTitles[0]}" — you\'ve got this! 💪'
        : '${incompleteGoalTitles.length} goals still waiting for you today. Keep going! 💪';

    await _plugin.zonedSchedule(
      _incompleteGoalBaseId,
      '🌿 Goals Check-in',
      body,
      noon,
      _details(_reminderChannelId, 'Goal Reminders'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ── FEATURE 4: Event reminder 24 hours before ────────────
  Future<void> scheduleEventReminders(
    List<Map<String, dynamic>> events,
  ) async {
    // Cancel old event reminders (IDs 5000–5099)
    for (var i = 0; i < 100; i++) {
      await _plugin.cancel(5000 + i);
    }

    final now = DateTime.now();

    for (var i = 0; i < events.length && i < 100; i++) {
      final event = events[i];
      final DateTime eventDate = event['dateTime'] as DateTime;
      final String title = event['title'] as String;
      final String mode = event['mode'] as String? ?? '';

      final reminderTime = eventDate.subtract(const Duration(hours: 24));

      // Only schedule if reminder time is in the future
      if (reminderTime.isAfter(now)) {
        final tzReminderTime = tz.TZDateTime.from(reminderTime, tz.local);
        final modeLabel = mode == 'online' ? 'Online' : 'In-person';

        await _plugin.zonedSchedule(
          5000 + i,
          '📅 Event Tomorrow!',
          '"$title" ($modeLabel) — happening in 24 hours. Don\'t miss it!',
          tzReminderTime,
          _details(_eventChannelId, 'Event Reminders'),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  // ── FEATURE 5: Badge earned notification ─────────────────
  Future<void> checkAndNotifyBadge(int daysSober) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final lastCheckDate = prefs.getString(_lastCheckDateKey) ?? '';
    // Only check once per day
    if (lastCheckDate == todayStr) return;

    await prefs.setString(_lastCheckDateKey, todayStr);

    final lastBadgeDays = prefs.getInt(_lastBadgeKey) ?? 0;

    // Find the highest milestone reached now
    int? newMilestone;
    for (final milestone in _milestones) {
      if (daysSober >= milestone && lastBadgeDays < milestone) {
        newMilestone = milestone;
      }
    }

    if (newMilestone != null) {
      await prefs.setInt(_lastBadgeKey, newMilestone);
      final badgeName = _badgeNames[newMilestone] ?? 'New Badge';

      await _plugin.show(
        _badgeId,
        '🏆 New Badge Earned!',
        'You\'ve earned the "$badgeName" badge for $newMilestone days sober. Incredible!',
        _details(_badgeChannelId, 'Badge Achievements'),
      );
    }
  }

  // ── Cancel all ────────────────────────────────────────────
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}