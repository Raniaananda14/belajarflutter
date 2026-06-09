import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_19/database/preference_handler.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/views/splash_view.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await PreferenceHandler.init();
  await SessionManager.init(); // Initialize Session Manager SharedPreferences
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SessionManager.themeNotifier,
      builder: (context, themeModeStr, child) {
        final themeMode = themeModeStr == "dark" ? ThemeMode.dark : ThemeMode.light;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BizGrow',
          themeMode: themeMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0D9488),
              brightness: Brightness.light,
              surface: const Color(0xFFFAFBFC),
              onSurface: const Color(0xFF0F172A),
              onSurfaceVariant: const Color(0xFF64748B),
              outlineVariant: const Color(0xFFE2E8F0),
            ),
            cardColor: Colors.white,
            dividerColor: const Color(0xFFF1F5F9),
            fontFamily: 'Roboto',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0D9488),
              brightness: Brightness.dark,
              surface: const Color(0xFF0F172A),
              onSurface: const Color(0xFFF8FAFC),
              onSurfaceVariant: const Color(0xFF94A3B8),
              outlineVariant: const Color(0xFF334155),
            ),
            cardColor: const Color(0xFF1E293B),
            dividerColor: const Color(0xFF334155),
            fontFamily: 'Roboto',
          ),
          home: const SplashView(),
        );
      },
    );
  }
}
