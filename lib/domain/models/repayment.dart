import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/date/local_day.dart';
import '../../core/money/money.dart';

part 'repayment.freezed.dart';

@freezed
abstract class Repayment with _$Repayment {
  const factory Repayment({
    required int id,
    required int loanId,
    required Money amount,
    required LocalDay repaymentDate,
    String? note,
  }) = _Repayment;
}
