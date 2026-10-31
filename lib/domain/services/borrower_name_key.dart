/// Normalized borrower name used to detect duplicates (RG-02): ignores
/// leading/trailing spaces and case.
String borrowerNameKey(String name) => name.trim().toLowerCase();
