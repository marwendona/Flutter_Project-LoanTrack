/// Why a borrower name is invalid (RG-01).
enum BorrowerNameError { required, tooLong }

/// Validation rules of a borrower (RG-01, borrower data model).
abstract final class BorrowerValidator {
  static const nameMaxLength = 60;
  static const noteMaxLength = 500;

  /// The name is required and 1–60 characters long once trimmed (RG-01).
  static BorrowerNameError? validateName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return BorrowerNameError.required;
    if (trimmed.length > nameMaxLength) return BorrowerNameError.tooLong;
    return null;
  }

  /// The optional note is at most 500 characters long once trimmed.
  static bool isNoteValid(String note) => note.trim().length <= noteMaxLength;
}

/// Thrown when another borrower already has the same name, ignoring case and
/// leading/trailing spaces (RG-02).
final class DuplicateBorrowerNameException implements Exception {
  const DuplicateBorrowerNameException(this.name);

  final String name;

  @override
  String toString() => 'DuplicateBorrowerNameException: $name';
}
