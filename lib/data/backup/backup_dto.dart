import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/date/local_day.dart';

part 'backup_dto.freezed.dart';
part 'backup_dto.g.dart';

/// The backup file content (RG-50), JSON format version [BackupDto.currentFormatVersion].
///
/// Amounts are in minor units, days are ISO 8601 dates (`2026-10-30`) and ids
/// keep the links between borrowers, loans and repayments. Computed values
/// (repaid, remaining, status, totals) are never exported.
@freezed
abstract class BackupDto with _$BackupDto {
  const factory BackupDto({
    required int formatVersion,

    /// Export instant, ISO 8601 in UTC.
    required DateTime exportedAt,

    /// ISO 4217 code of the app currency (RG-40).
    required String currency,
    required List<BorrowerDto> borrowers,
    required List<LoanDto> loans,
    required List<RepaymentDto> repayments,
  }) = _BackupDto;

  factory BackupDto.fromJson(Map<String, dynamic> json) =>
      _$BackupDtoFromJson(json);

  static const currentFormatVersion = 1;
}

@freezed
abstract class BorrowerDto with _$BorrowerDto {
  const factory BorrowerDto({
    required int id,
    required String name,
    String? phone,
    String? note,
    @LocalDayJsonConverter() required LocalDay createdAt,
  }) = _BorrowerDto;

  factory BorrowerDto.fromJson(Map<String, dynamic> json) =>
      _$BorrowerDtoFromJson(json);
}

@freezed
abstract class LoanDto with _$LoanDto {
  const factory LoanDto({
    required int id,
    required int borrowerId,
    required int amountMinor,
    @LocalDayJsonConverter() required LocalDay loanDate,
    @LocalDayJsonConverter() LocalDay? promisedReturnDate,
    String? note,
  }) = _LoanDto;

  factory LoanDto.fromJson(Map<String, dynamic> json) =>
      _$LoanDtoFromJson(json);
}

@freezed
abstract class RepaymentDto with _$RepaymentDto {
  const factory RepaymentDto({
    required int id,
    required int loanId,
    required int amountMinor,
    @LocalDayJsonConverter() required LocalDay repaymentDate,
    String? note,
  }) = _RepaymentDto;

  factory RepaymentDto.fromJson(Map<String, dynamic> json) =>
      _$RepaymentDtoFromJson(json);
}

/// Serializes a [LocalDay] as an ISO 8601 date (`2026-10-30`).
class LocalDayJsonConverter implements JsonConverter<LocalDay, String> {
  const LocalDayJsonConverter();

  static final _isoDate = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

  @override
  LocalDay fromJson(String json) {
    final match = _isoDate.firstMatch(json);
    if (match == null) throw FormatException('Invalid date', json);
    return LocalDay(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    );
  }

  @override
  String toJson(LocalDay day) => day.toString();
}
