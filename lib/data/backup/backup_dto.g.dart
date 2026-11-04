// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupDto _$BackupDtoFromJson(Map<String, dynamic> json) => _BackupDto(
  formatVersion: (json['formatVersion'] as num).toInt(),
  exportedAt: DateTime.parse(json['exportedAt'] as String),
  currency: json['currency'] as String,
  borrowers: (json['borrowers'] as List<dynamic>)
      .map((e) => BorrowerDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  loans: (json['loans'] as List<dynamic>)
      .map((e) => LoanDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  repayments: (json['repayments'] as List<dynamic>)
      .map((e) => RepaymentDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BackupDtoToJson(_BackupDto instance) =>
    <String, dynamic>{
      'formatVersion': instance.formatVersion,
      'exportedAt': instance.exportedAt.toIso8601String(),
      'currency': instance.currency,
      'borrowers': instance.borrowers,
      'loans': instance.loans,
      'repayments': instance.repayments,
    };

_BorrowerDto _$BorrowerDtoFromJson(Map<String, dynamic> json) => _BorrowerDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  phone: json['phone'] as String?,
  note: json['note'] as String?,
  createdAt: const LocalDayJsonConverter().fromJson(
    json['createdAt'] as String,
  ),
);

Map<String, dynamic> _$BorrowerDtoToJson(_BorrowerDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'note': instance.note,
      'createdAt': const LocalDayJsonConverter().toJson(instance.createdAt),
    };

_LoanDto _$LoanDtoFromJson(Map<String, dynamic> json) => _LoanDto(
  id: (json['id'] as num).toInt(),
  borrowerId: (json['borrowerId'] as num).toInt(),
  amountMinor: (json['amountMinor'] as num).toInt(),
  loanDate: const LocalDayJsonConverter().fromJson(json['loanDate'] as String),
  promisedReturnDate: _$JsonConverterFromJson<String, LocalDay>(
    json['promisedReturnDate'],
    const LocalDayJsonConverter().fromJson,
  ),
  note: json['note'] as String?,
);

Map<String, dynamic> _$LoanDtoToJson(_LoanDto instance) => <String, dynamic>{
  'id': instance.id,
  'borrowerId': instance.borrowerId,
  'amountMinor': instance.amountMinor,
  'loanDate': const LocalDayJsonConverter().toJson(instance.loanDate),
  'promisedReturnDate': _$JsonConverterToJson<String, LocalDay>(
    instance.promisedReturnDate,
    const LocalDayJsonConverter().toJson,
  ),
  'note': instance.note,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_RepaymentDto _$RepaymentDtoFromJson(Map<String, dynamic> json) =>
    _RepaymentDto(
      id: (json['id'] as num).toInt(),
      loanId: (json['loanId'] as num).toInt(),
      amountMinor: (json['amountMinor'] as num).toInt(),
      repaymentDate: const LocalDayJsonConverter().fromJson(
        json['repaymentDate'] as String,
      ),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$RepaymentDtoToJson(
  _RepaymentDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'loanId': instance.loanId,
  'amountMinor': instance.amountMinor,
  'repaymentDate': const LocalDayJsonConverter().toJson(instance.repaymentDate),
  'note': instance.note,
};
