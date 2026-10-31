import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/core/theme/status_colors.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('light and dark themes are Material 3 with status colors', () {
    final light = AppTheme.light();
    final dark = AppTheme.dark();

    expect(light.useMaterial3, isTrue);
    expect(light.colorScheme.brightness, Brightness.light);
    expect(dark.colorScheme.brightness, Brightness.dark);
    expect(light.extension<StatusColors>(), StatusColors.light);
    expect(dark.extension<StatusColors>(), StatusColors.dark);
  });

  test('uses the dynamic color scheme when provided', () {
    final dynamicScheme = ColorScheme.fromSeed(seedColor: Colors.purple);
    expect(AppTheme.light(dynamicScheme).colorScheme, dynamicScheme);
  });
}
