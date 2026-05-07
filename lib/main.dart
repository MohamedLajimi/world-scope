import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:worldscope/core/di/service_locator.dart';
import 'package:worldscope/core/router/app_router.dart';
import 'package:worldscope/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await dotenv.load(fileName: '.env');

  runApp(const WorldScopeApp());
}

class WorldScopeApp extends StatelessWidget {
  const WorldScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WorldScope',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.dark,
      routerConfig: AppRouter.router,
    );
  }
}
