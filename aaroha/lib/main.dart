import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'core/services/notification_service.dart';
import 'features/profile/services/user_service.dart';
// Hive adapters for streak / goals (existing)
import 'features/tracker/domain/streak_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Load .env (GROQ key) ─────────────────────────────────
  await dotenv.load(fileName: '.env');

  // ── System UI ────────────────────────────────────────────
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // ── Hive ─────────────────────────────────────────────────
  await Hive.initFlutter();

  // Register existing streak / goal adapters
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(StreakModelAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(DailyGoalAdapter());

  // ── User service (UserModel + AppStats Hive boxes) ───────
  // This registers adapters typeId 10 & 11 and seeds default data if absent.
  await UserService.init();

  // ── Notifications ────────────────────────────────────────
  await NotificationService.instance.init();
  await NotificationService.instance.scheduleDailyQuote();

  const int daysSober = 12;
  await NotificationService.instance.checkAndNotifyBadge(daysSober);

  await NotificationService.instance.scheduleEventReminders([
    {
      'title': 'Breathwork 101 — Beginners',
      'dateTime': DateTime.now().add(const Duration(days: 1)).copyWith(hour: 18, minute: 0, second: 0),
      'mode': 'online',
    },
    {
      'title': 'AA Group Meeting — Thrissur',
      'dateTime': DateTime.now().add(const Duration(days: 8)).copyWith(hour: 10, minute: 0, second: 0),
      'mode': 'in-person',
    },
  ]);

  runApp(const ProviderScope(child: AarohaApp()));
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
