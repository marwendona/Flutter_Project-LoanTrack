/// Normalizes strings for case- and accent-insensitive comparison (US-1.5).
///
/// Example: "Éléonore" → "eleonore", "JEAN" → "jean".
abstract final class StringNormalizer {
  /// Removes accents and converts to lowercase.
  static String normalize(String input) {
    // Remove diacritics by normalizing to NFD and removing combining marks
    final withoutDiacritics = input.toLowerCase().replaceAll(
      RegExp(r'[\u0300-\u036f]'),
      '',
    );
    return withoutDiacritics;
  }
}
