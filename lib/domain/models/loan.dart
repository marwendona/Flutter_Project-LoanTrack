import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/date/local_day.dart';
import '../../core/money/money.dart';

part 'loan.freezed.dart';

@freezed
abstract class Loan with _$Loan {
  const factory Loan({
    required int id,
    required int borrowerId,
    required Money amount,
    required LocalDay loanDate,
    LocalDay? promisedReturnDate,
    String? note,
  }) = _Loan;
}
