import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme_mode.dart';
import '../../data/providers.dart';

/// The theme setting of ECR-06, applied to the whole app (CR-030).
final themeControllerProvider = NotifierProvider<ThemeController, AppThemeMode>(
  ThemeController.new,
);

class ThemeController extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() => ref.watch(settingsStoreProvider).themeMode;

  /// Saves [mode] and applies it immediately.
  Future<void> change(AppThemeMode mode) async {
    if (mode == state) return;
    await ref.read(settingsStoreProvider).setThemeMode(mode);
    state = mode;
  }
}
