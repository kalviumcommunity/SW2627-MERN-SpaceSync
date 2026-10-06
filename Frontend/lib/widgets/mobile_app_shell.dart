import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../screens/analytics_screen.dart';
import '../screens/bookings_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/spaces_screen.dart';
import '../theme/app_theme.dart';
import 'bottom_navigation.dart';

class MobileAppShell extends StatefulWidget {
  const MobileAppShell({
    super.key,
    this.themeMode = ThemeMode.system,
    this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;

  @override
  State<MobileAppShell> createState() => _MobileAppShellState();
}

class _MobileAppShellState extends State<MobileAppShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktopPlatform =
            kIsWeb ||
            defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.linux;
        final isDesktop = isDesktopPlatform && constraints.maxWidth > 600;
        final width = isDesktop ? 420.0 : constraints.maxWidth;
        final height = isDesktop && constraints.maxHeight > 640
            ? (constraints.maxHeight - 64).clamp(560.0, 900.0).toDouble()
            : constraints.maxHeight;

        final app = ClipRRect(
          borderRadius: BorderRadius.circular(isDesktop ? 28 : 0),
          child: Material(
            color: AppColors.of(context).canvas,
            child: Column(
              children: [
                Expanded(
                  child: SafeArea(
                    bottom: false,
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: [
                        const HomeScreen(),
                        const BookingsScreen(),
                        const SpacesScreen(),
                        const AnalyticsScreen(),
                        ProfileScreen(
                          themeMode: widget.themeMode,
                          onThemeModeChanged: widget.onThemeModeChanged,
                        ),
                      ],
                    ),
                  ),
                ),
                BottomNavigation(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                ),
              ],
            ),
          ),
        );

        if (!isDesktop) return app;
        return ColoredBox(
          color: const Color(0xFF20262C),
          child: Center(
            child: SizedBox(
              width: width,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x66000000),
                      blurRadius: 40,
                      offset: Offset(0, 18),
                    ),
                  ],
                ),
                child: app,
              ),
            ),
          ),
        );
      },
    );
  }
}
