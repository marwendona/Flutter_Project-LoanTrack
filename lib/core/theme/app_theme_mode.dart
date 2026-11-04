/// The theme chosen in the settings (ECR-06, CR-030).
enum AppThemeMode {
  /// Follows the phone setting (default).
  system,
  light,
  dark;

  /// The mode saved under [name], [system] when [name] is null or unknown.
  static AppThemeMode fromName(String? name) =>
      values.asNameMap()[name] ?? AppThemeMode.system;
}
