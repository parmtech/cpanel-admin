import 'package:flutter/material.dart';

import 'features/app_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CPanelAdminApp());
}

class CPanelAdminApp extends StatelessWidget {
  const CPanelAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF67E8D2);
    const background = Color(0xFF0B1118);

    return MaterialApp(
      title: 'cPanel Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
          surface: const Color(0xFF111B25),
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF111B25),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF263746)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF111B25),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      home: const AppHome(),
    );
  }
}
