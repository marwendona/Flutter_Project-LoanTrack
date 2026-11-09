import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/theme/app_theme.dart';
import 'package:loantrack/core/theme/reliability_colors.dart';
import 'package:loantrack/core/theme/status_colors.dart';
import 'package:loantrack/domain/models/reliability_color.dart';
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

  test('reliability colors are fixed, one per color (US-7.2)', () {
    final dynamicScheme = ColorScheme.fromSeed(seedColor: Colors.purple);
    expect(
      AppTheme.light(dynamicScheme).extension<ReliabilityColors>(),
      ReliabilityColors.light,
    );
    expect(
      AppTheme.dark(dynamicScheme).extension<ReliabilityColors>(),
      ReliabilityColors.dark,
    );
    for (final colors in [ReliabilityColors.light, ReliabilityColors.dark]) {
      expect(colors.colors.keys, unorderedEquals(ReliabilityColor.values));
      // Each color has its own shade.
      expect(colors.colors.values.toSet(), hasLength(8));
    }
  });

  test('the black dot has a light outline in dark mode only', () {
    expect(ReliabilityColors.light.outlineOf(ReliabilityColor.black), isNull);
    expect(ReliabilityColors.dark.outlineOf(ReliabilityColor.black), isNotNull);
    expect(ReliabilityColors.dark.outlineOf(ReliabilityColor.red), isNull);
  });

  test('uses the dynamic color scheme when provided', () {
    final dynamicScheme = ColorScheme.fromSeed(seedColor: Colors.purple);
    expect(AppTheme.light(dynamicScheme).colorScheme, dynamicScheme);
  });
}
