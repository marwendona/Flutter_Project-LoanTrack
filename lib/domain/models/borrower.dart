import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/date/local_day.dart';

part 'borrower.freezed.dart';

@freezed
abstract class Borrower with _$Borrower {
  const factory Borrower({
    required int id,
    required String name,
    String? phone,
    String? note,
    required LocalDay createdAt,
  }) = _Borrower;
}
