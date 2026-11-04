import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/core/date/local_day.dart';
import 'package:loantrack/data/backup/backup_dto.dart';
import 'package:loantrack/data/backup/backup_validator.dart';

void main() {
  final ali = BorrowerDto(id: 1, name: 'Ali', createdAt: LocalDay(2026, 9, 1));
  final sana = BorrowerDto(
    id: 2,
    name: 'Sana',
    createdAt: LocalDay(2026, 9, 1),
  );
  final loan = LoanDto(
    id: 1,
    borrowerId: 1,
    amountMinor: 1000000,
    loanDate: LocalDay(2026, 10, 1),
    promisedReturnDate: LocalDay(2026, 12, 31),
  );
  final repayment = RepaymentDto(
    id: 1,
    loanId: 1,
    amountMinor: 400000,
    repaymentDate: LocalDay(2026, 10, 15),
  );
  final valid = BackupDto(
    formatVersion: 1,
    exportedAt: DateTime.utc(2026, 11, 4),
    currency: 'TND',
    borrowers: [ali, sana],
    loans: [loan],
    repayments: [repayment],
  );

  Matcher refused([InvalidBackupReason reason = InvalidBackupReason.invalid]) =>
      throwsA(
        isA<InvalidBackupException>().having((e) => e.reason, 'reason', reason),
      );

  test('accepts a consistent backup', () {
    expect(() => BackupValidator.validate(valid), returnsNormally);
  });

  test('accepts an empty backup', () {
    expect(
      () => BackupValidator.validate(
        valid.copyWith(borrowers: [], loans: [], repayments: []),
      ),
      returnsNormally,
    );
  });

  test('accepts repayments totalling exactly the loan amount (RG-16)', () {
    expect(
      () => BackupValidator.validate(
        valid.copyWith(
          repayments: [
            repayment,
            repayment.copyWith(id: 2, amountMinor: 600000),
          ],
        ),
      ),
      returnsNormally,
    );
  });

  test('refuses an unknown format version', () {
    expect(
      () => BackupValidator.validate(valid.copyWith(formatVersion: 2)),
      refused(InvalidBackupReason.unsupportedVersion),
    );
  });

  test('refuses a currency that is not offered (RG-40)', () {
    expect(
      () => BackupValidator.validate(valid.copyWith(currency: 'XYZ')),
      refused(),
    );
  });

  group('borrowers', () {
    test('refuses duplicate ids', () {
      expect(
        () => BackupValidator.validate(
          valid.copyWith(borrowers: [ali, sana.copyWith(id: 1)]),
        ),
        refused(),
      );
    });

    test('refuses an empty or too long name (RG-01)', () {
      for (final name in ['  ', 'x' * 61]) {
        expect(
          () => BackupValidator.validate(
            valid.copyWith(
              borrowers: [
                ali,
                sana.copyWith(name: name),
              ],
            ),
          ),
          refused(),
          reason: name,
        );
      }
    });

    test('refuses duplicate names ignoring case and spaces (RG-02)', () {
      expect(
        () => BackupValidator.validate(
          valid.copyWith(
            borrowers: [
              ali,
              sana.copyWith(name: ' ALI '),
            ],
          ),
        ),
        refused(),
      );
    });

    test('refuses a note over 500 characters', () {
      expect(
        () => BackupValidator.validate(
          valid.copyWith(
            borrowers: [
              ali,
              sana.copyWith(note: 'x' * 501),
            ],
          ),
        ),
        refused(),
      );
    });
  });

  group('loans', () {
    test('refuses duplicate ids', () {
      expect(
        () => BackupValidator.validate(
          valid.copyWith(loans: [loan, loan.copyWith(borrowerId: 2)]),
        ),
        refused(),
      );
    });

    test('refuses an unknown borrower', () {
      expect(
        () => BackupValidator.validate(
          valid.copyWith(loans: [loan.copyWith(borrowerId: 3)]),
        ),
        refused(),
      );
    });

    test('refuses a zero, negative or too large amount (RG-10)', () {
      for (final amount in [0, -1, 999999999 * 1000 + 1]) {
        expect(
          () => BackupValidator.validate(
            valid.copyWith(
              loans: [loan.copyWith(amountMinor: amount)],
              repayments: [],
            ),
          ),
          refused(),
          reason: '$amount',
        );
      }
    });

    test('refuses a promised return date before the loan date (RG-12)', () {
      expect(
        () => BackupValidator.validate(
          valid.copyWith(
            loans: [loan.copyWith(promisedReturnDate: LocalDay(2026, 9, 30))],
          ),
        ),
        refused(),
      );
    });

    test('refuses a note over 500 characters', () {
      expect(
        () => BackupValidator.validate(
          valid.copyWith(loans: [loan.copyWith(note: 'x' * 501)]),
        ),
        refused(),
      );
    });
  });

  group('repayments', () {
    test('refuses duplicate ids', () {
      expect(
        () => BackupValidator.validate(
          valid.copyWith(
            repayments: [repayment, repayment.copyWith(amountMinor: 1)],
          ),
        ),
        refused(),
      );
    });

    test('refuses an unknown loan', () {
      expect(
        () => BackupValidator.validate(
          valid.copyWith(repayments: [repayment.copyWith(loanId: 2)]),
        ),
        refused(),
      );
    });

    test('refuses a zero or negative amount (RG-16)', () {
      for (final amount in [0, -1]) {
        expect(
          () => BackupValidator.validate(
            valid.copyWith(
              repayments: [repayment.copyWith(amountMinor: amount)],
            ),
          ),
          refused(),
          reason: '$amount',
        );
      }
    });

    test('refuses repayments exceeding the loan amount (RG-16)', () {
      expect(
        () => BackupValidator.validate(
          valid.copyWith(
            repayments: [
              repayment,
              repayment.copyWith(id: 2, amountMinor: 600001),
            ],
          ),
        ),
        refused(),
      );
    });

    test('refuses a repayment before the loan date (RG-17)', () {
      expect(
        () => BackupValidator.validate(
          valid.copyWith(
            repayments: [
              repayment.copyWith(repaymentDate: LocalDay(2026, 9, 30)),
            ],
          ),
        ),
        refused(),
      );
    });

    test('refuses a note over 200 characters', () {
      expect(
        () => BackupValidator.validate(
          valid.copyWith(repayments: [repayment.copyWith(note: 'x' * 201)]),
        ),
        refused(),
      );
    });
  });
}
