import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';

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
  // Register adapters here after running build_runner:
  // Hive.registerAdapter(StreakModelAdapter());
  // Hive.registerAdapter(DailyGoalAdapter());

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
