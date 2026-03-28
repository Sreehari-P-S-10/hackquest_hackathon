import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // ── System UI ────────────────────────────────────────────
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // ── Hive local storage ───────────────────────────────────
  await Hive.initFlutter();

  // ── Notifications ────────────────────────────────────────
  await NotificationService.instance.init();

  // Schedule daily 8 AM quote notification
  await NotificationService.instance.scheduleDailyQuote();

  // Check badge on launch (daysSober hardcoded = 12, wire to Hive later)
  const int daysSober = 12;
  await NotificationService.instance.checkAndNotifyBadge(daysSober);

  // Schedule event reminders (24h before each event)
  await NotificationService.instance.scheduleEventReminders([
    {
      'title': 'Breathwork 101 — Beginners',
      'dateTime': DateTime.now().add(const Duration(days: 1))
          .copyWith(hour: 18, minute: 0, second: 0),
      'mode': 'online',
    },
    {
      'title': 'AA Group Meeting — Thrissur',
      'dateTime': DateTime.now().add(const Duration(days: 8))
          .copyWith(hour: 10, minute: 0, second: 0),
      'mode': 'in-person',
    },
    {
      'title': 'Recovery Story Circle',
      'dateTime': DateTime.now().add(const Duration(days: 15))
          .copyWith(hour: 19, minute: 0, second: 0),
      'mode': 'online',
    },
  ]);

  runApp(
    const ProviderScope(child: AarohaApp()),
  );
}

class AarohaApp extends StatelessWidget {
  const AarohaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Aaroha',
      debugShowCheckedModeBanner: false,
      theme: AarohaTheme.light,
      routerConfig: appRouter,
    );
  }
}