import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'widgets/mobile_app_shell.dart';

class CoWorkHubApp extends StatefulWidget {
  const CoWorkHubApp({super.key});

  @override
  State<CoWorkHubApp> createState() => _CoWorkHubAppState();
}

class _CoWorkHubAppState extends State<CoWorkHubApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoWorkHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: MobileAppShell(
        themeMode: _themeMode,
        onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
      ),
    );
  }
}
