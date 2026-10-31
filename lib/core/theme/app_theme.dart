import 'package:material_ui/material_ui.dart';

import 'status_colors.dart';

/// Material 3 themes. Uses the device (Material You) colors when available,
/// otherwise a scheme generated from [seedColor].
abstract final class AppTheme {
  static const seedColor = Color(0xFF00695C);

  static ThemeData light([ColorScheme? dynamicScheme]) => _build(
    dynamicScheme ?? ColorScheme.fromSeed(seedColor: seedColor),
    StatusColors.light,
  );

  static ThemeData dark([ColorScheme? dynamicScheme]) => _build(
    dynamicScheme ??
        ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark),
    StatusColors.dark,
  );

  static ThemeData _build(ColorScheme colorScheme, StatusColors statusColors) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [statusColors],
    );
  }
}
