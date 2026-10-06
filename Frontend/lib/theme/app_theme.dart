import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.canvas,
    required this.surface,
    required this.surfaceRaised,
    required this.primarySoft,
    required this.iconSurface,
    required this.outline,
    required this.outlineSoft,
    required this.muted,
    required this.tertiary,
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.danger,
    required this.dangerContainer,
    required this.info,
    required this.infoContainer,
    required this.chartGrid,
    required this.chartFill,
    required this.shadow,
  });

  final Color canvas;
  final Color surface;
  final Color surfaceRaised;
  final Color primarySoft;
  final Color iconSurface;
  final Color outline;
  final Color outlineSoft;
  final Color muted;
  final Color tertiary;
  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color danger;
  final Color dangerContainer;
  final Color info;
  final Color infoContainer;
  final Color chartGrid;
  final Color chartFill;
  final Color shadow;

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceRaised,
    Color? primarySoft,
    Color? iconSurface,
    Color? outline,
    Color? outlineSoft,
    Color? muted,
    Color? tertiary,
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? danger,
    Color? dangerContainer,
    Color? info,
    Color? infoContainer,
    Color? chartGrid,
    Color? chartFill,
    Color? shadow,
  }) => AppColors(
    canvas: canvas ?? this.canvas,
    surface: surface ?? this.surface,
    surfaceRaised: surfaceRaised ?? this.surfaceRaised,
    primarySoft: primarySoft ?? this.primarySoft,
    iconSurface: iconSurface ?? this.iconSurface,
    outline: outline ?? this.outline,
    outlineSoft: outlineSoft ?? this.outlineSoft,
    muted: muted ?? this.muted,
    tertiary: tertiary ?? this.tertiary,
    success: success ?? this.success,
    successContainer: successContainer ?? this.successContainer,
    warning: warning ?? this.warning,
    warningContainer: warningContainer ?? this.warningContainer,
    danger: danger ?? this.danger,
    dangerContainer: dangerContainer ?? this.dangerContainer,
    info: info ?? this.info,
    infoContainer: infoContainer ?? this.infoContainer,
    chartGrid: chartGrid ?? this.chartGrid,
    chartFill: chartFill ?? this.chartFill,
    shadow: shadow ?? this.shadow,
  );

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      iconSurface: Color.lerp(iconSurface, other.iconSurface, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineSoft: Color.lerp(outlineSoft, other.outlineSoft, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerContainer: Color.lerp(dangerContainer, other.dangerContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      chartGrid: Color.lerp(chartGrid, other.chartGrid, t)!,
      chartFill: Color.lerp(chartFill, other.chartFill, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

abstract final class AppTheme {
  static const _lightColors = AppColors(
    canvas: Color(0xFFF5F7F6),
    surface: Color(0xFFFFFEFC),
    surfaceRaised: Color(0xFFF8FAF9),
    primarySoft: Color(0xFFE8F0F6),
    iconSurface: Color(0xFFF0F4F5),
    outline: Color(0xFFE3E9E7),
    outlineSoft: Color(0xFFEDF0EF),
    muted: Color(0xFF68777D),
    tertiary: Color(0xFF849096),
    success: Color(0xFF21835D),
    successContainer: Color(0xFFE5F3EC),
    warning: Color(0xFFAE6B21),
    warningContainer: Color(0xFFFFF1E0),
    danger: Color(0xFFC4545D),
    dangerContainer: Color(0xFFFFE9E9),
    info: Color(0xFF456D9B),
    infoContainer: Color(0xFFEAF0F8),
    chartGrid: Color(0xFFE6ECEB),
    chartFill: Color(0x26385A7C),
    shadow: Color(0x141B3540),
  );

  static const _darkColors = AppColors(
    canvas: Color(0xFF121A20),
    surface: Color(0xFF1B252D),
    surfaceRaised: Color(0xFF202D36),
    primarySoft: Color(0xFF2C4050),
    iconSurface: Color(0xFF263640),
    outline: Color(0xFF34444E),
    outlineSoft: Color(0xFF2A3942),
    muted: Color(0xFFB0BDC4),
    tertiary: Color(0xFF91A0A8),
    success: Color(0xFF79D5A8),
    successContainer: Color(0xFF234235),
    warning: Color(0xFFF0BA73),
    warningContainer: Color(0xFF4A3725),
    danger: Color(0xFFFF9698),
    dangerContainer: Color(0xFF4B2E34),
    info: Color(0xFF9FC5E4),
    infoContainer: Color(0xFF2B4050),
    chartGrid: Color(0xFF34424A),
    chartFill: Color(0x304E8ABC),
    shadow: Color(0x55000000),
  );

  static final light = _buildTheme(Brightness.light, _lightColors);
  static final dark = _buildTheme(Brightness.dark, _darkColors);

  static ThemeData _buildTheme(Brightness brightness, AppColors colors) {
    final isDark = brightness == Brightness.dark;
    const primaryLight = Color(0xFF385A7C);
    const primaryDark = Color(0xFF9FC5E4);
    final primary = isDark ? primaryDark : primaryLight;
    final onPrimary = isDark ? const Color(0xFF17232B) : Colors.white;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: isDark ? const Color(0xFF9DD6BF) : const Color(0xFF557D70),
      onSecondary: isDark ? const Color(0xFF193128) : Colors.white,
      error: colors.danger,
      onError: isDark ? const Color(0xFF32191C) : Colors.white,
      surface: colors.surface,
      onSurface: isDark ? const Color(0xFFE8EEF1) : const Color(0xFF253139),
      onSurfaceVariant: colors.muted,
      outline: colors.outline,
      outlineVariant: colors.outlineSoft,
      surfaceTint: primary,
    );
    final textColor = colorScheme.onSurface;
    final mutedColor = colors.muted;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.canvas,
      cardColor: colors.surface,
      extensions: [colors],
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          color: textColor,
          fontSize: 23,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(color: mutedColor, fontSize: 13, height: 1.45),
        labelMedium: TextStyle(
          color: mutedColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.primarySoft,
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 10,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? primary : colors.tertiary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 21,
            color: selected ? primary : colors.tertiary,
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.surfaceRaised,
        contentTextStyle: TextStyle(color: textColor),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
    );
  }
}
