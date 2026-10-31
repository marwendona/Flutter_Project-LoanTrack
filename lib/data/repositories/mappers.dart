import '../../core/money/money.dart';
import '../../domain/models/borrower.dart';
import '../../domain/models/loan.dart';
import '../../domain/models/repayment.dart';
import '../database/app_database.dart';

extension BorrowerRowMapper on BorrowerRow {
  Borrower toDomain() => Borrower(
    id: id,
    name: name,
    phone: phone,
    note: note,
    createdAt: createdAt,
  );
}

extension LoanRowMapper on LoanRow {
  Loan toDomain() => Loan(
    id: id,
    borrowerId: borrowerId,
    amount: Money(amountMinor),
    loanDate: loanDate,
    promisedReturnDate: promisedReturnDate,
    note: note,
  );
}

extension RepaymentRowMapper on RepaymentRow {
  Repayment toDomain() => Repayment(
    id: id,
    loanId: loanId,
    amount: Money(amountMinor),
    repaymentDate: repaymentDate,
    note: note,
  );
}
