import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/domain/services/borrower_validator.dart';

void main() {
  group('validateName (RG-01)', () {
    test('requires a non blank name', () {
      expect(BorrowerValidator.validateName(''), BorrowerNameError.required);
      expect(BorrowerValidator.validateName('   '), BorrowerNameError.required);
    });

    test('accepts 1 to 60 characters once trimmed', () {
      expect(BorrowerValidator.validateName('A'), isNull);
      expect(BorrowerValidator.validateName('  ${'a' * 60}  '), isNull);
    });

    test('refuses more than 60 characters', () {
      expect(
        BorrowerValidator.validateName('a' * 61),
        BorrowerNameError.tooLong,
      );
    });
  });

  group('isNoteValid', () {
    test('accepts an empty note and up to 500 characters', () {
      expect(BorrowerValidator.isNoteValid(''), isTrue);
      expect(BorrowerValidator.isNoteValid('n' * 500), isTrue);
    });

    test('refuses more than 500 characters', () {
      expect(BorrowerValidator.isNoteValid('n' * 501), isFalse);
    });
  });
}
