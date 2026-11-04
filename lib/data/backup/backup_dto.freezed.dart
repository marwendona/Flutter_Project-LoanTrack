// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupDto {

 int get formatVersion;/// Export instant, ISO 8601 in UTC.
 DateTime get exportedAt;/// ISO 4217 code of the app currency (RG-40).
 String get currency; List<BorrowerDto> get borrowers; List<LoanDto> get loans; List<RepaymentDto> get repayments;
/// Create a copy of BackupDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupDtoCopyWith<BackupDto> get copyWith => _$BackupDtoCopyWithImpl<BackupDto>(this as BackupDto, _$identity);

  /// Serializes this BackupDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BackupDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupDto&&(identical(other.formatVersion, _this.formatVersion) || other.formatVersion == _this.formatVersion)&&(identical(other.exportedAt, _this.exportedAt) || other.exportedAt == _this.exportedAt)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&const DeepCollectionEquality().equals(other.borrowers, _this.borrowers)&&const DeepCollectionEquality().equals(other.loans, _this.loans)&&const DeepCollectionEquality().equals(other.repayments, _this.repayments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BackupDto;
  return Object.hash(runtimeType,_this.formatVersion,_this.exportedAt,_this.currency,const DeepCollectionEquality().hash(_this.borrowers),const DeepCollectionEquality().hash(_this.loans),const DeepCollectionEquality().hash(_this.repayments));
}

@override
String toString() {
  final _this = this as BackupDto;
  return 'BackupDto(formatVersion: ${_this.formatVersion}, exportedAt: ${_this.exportedAt}, currency: ${_this.currency}, borrowers: ${_this.borrowers}, loans: ${_this.loans}, repayments: ${_this.repayments})';
}


}

/// @nodoc
abstract mixin class $BackupDtoCopyWith<$Res>  {
  factory $BackupDtoCopyWith(BackupDto value, $Res Function(BackupDto) _then) = _$BackupDtoCopyWithImpl;
@useResult
$Res call({
 int formatVersion, DateTime exportedAt, String currency, List<BorrowerDto> borrowers, List<LoanDto> loans, List<RepaymentDto> repayments
});




}
/// @nodoc
class _$BackupDtoCopyWithImpl<$Res>
    implements $BackupDtoCopyWith<$Res> {
  _$BackupDtoCopyWithImpl(this._self, this._then);

  final BackupDto _self;
  final $Res Function(BackupDto) _then;

/// Create a copy of BackupDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formatVersion = null,Object? exportedAt = null,Object? currency = null,Object? borrowers = null,Object? loans = null,Object? repayments = null,}) {
  return _then(BackupDto(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,borrowers: null == borrowers ? _self.borrowers : borrowers // ignore: cast_nullable_to_non_nullable
as List<BorrowerDto>,loans: null == loans ? _self.loans : loans // ignore: cast_nullable_to_non_nullable
as List<LoanDto>,repayments: null == repayments ? _self.repayments : repayments // ignore: cast_nullable_to_non_nullable
as List<RepaymentDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupDto].
extension BackupDtoPatterns on BackupDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupDto value)  $default,){
final _that = this;
switch (_that) {
case _BackupDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupDto value)?  $default,){
final _that = this;
switch (_that) {
case _BackupDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int formatVersion,  DateTime exportedAt,  String currency,  List<BorrowerDto> borrowers,  List<LoanDto> loans,  List<RepaymentDto> repayments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupDto() when $default != null:
return $default(_that.formatVersion,_that.exportedAt,_that.currency,_that.borrowers,_that.loans,_that.repayments);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int formatVersion,  DateTime exportedAt,  String currency,  List<BorrowerDto> borrowers,  List<LoanDto> loans,  List<RepaymentDto> repayments)  $default,) {final _that = this;
switch (_that) {
case _BackupDto():
return $default(_that.formatVersion,_that.exportedAt,_that.currency,_that.borrowers,_that.loans,_that.repayments);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int formatVersion,  DateTime exportedAt,  String currency,  List<BorrowerDto> borrowers,  List<LoanDto> loans,  List<RepaymentDto> repayments)?  $default,) {final _that = this;
switch (_that) {
case _BackupDto() when $default != null:
return $default(_that.formatVersion,_that.exportedAt,_that.currency,_that.borrowers,_that.loans,_that.repayments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupDto implements BackupDto {
  const _BackupDto({required this.formatVersion, required this.exportedAt, required this.currency, required  List<BorrowerDto> borrowers, required  List<LoanDto> loans, required  List<RepaymentDto> repayments}): _borrowers = borrowers,_loans = loans,_repayments = repayments;
  factory _BackupDto.fromJson(Map<String, dynamic> json) => _$BackupDtoFromJson(json);

@override final  int formatVersion;
/// Export instant, ISO 8601 in UTC.
@override final  DateTime exportedAt;
/// ISO 4217 code of the app currency (RG-40).
@override final  String currency;
 final  List<BorrowerDto> _borrowers;
@override List<BorrowerDto> get borrowers {
  if (_borrowers is EqualUnmodifiableListView) return _borrowers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_borrowers);
}

 final  List<LoanDto> _loans;
@override List<LoanDto> get loans {
  if (_loans is EqualUnmodifiableListView) return _loans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_loans);
}

 final  List<RepaymentDto> _repayments;
@override List<RepaymentDto> get repayments {
  if (_repayments is EqualUnmodifiableListView) return _repayments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_repayments);
}


/// Create a copy of BackupDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupDtoCopyWith<_BackupDto> get copyWith => __$BackupDtoCopyWithImpl<_BackupDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupDto&&(identical(other.formatVersion, formatVersion) || other.formatVersion == formatVersion)&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&(identical(other.currency, currency) || other.currency == currency)&&const DeepCollectionEquality().equals(other.borrowers, _borrowers)&&const DeepCollectionEquality().equals(other.loans, _loans)&&const DeepCollectionEquality().equals(other.repayments, _repayments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,formatVersion,exportedAt,currency,const DeepCollectionEquality().hash(_borrowers),const DeepCollectionEquality().hash(_loans),const DeepCollectionEquality().hash(_repayments));
}

@override
String toString() {
    return 'BackupDto(formatVersion: $formatVersion, exportedAt: $exportedAt, currency: $currency, borrowers: $borrowers, loans: $loans, repayments: $repayments)';
}


}

/// @nodoc
abstract mixin class _$BackupDtoCopyWith<$Res> implements $BackupDtoCopyWith<$Res> {
  factory _$BackupDtoCopyWith(_BackupDto value, $Res Function(_BackupDto) _then) = __$BackupDtoCopyWithImpl;
@override @useResult
$Res call({
 int formatVersion, DateTime exportedAt, String currency, List<BorrowerDto> borrowers, List<LoanDto> loans, List<RepaymentDto> repayments
});




}
/// @nodoc
class __$BackupDtoCopyWithImpl<$Res>
    implements _$BackupDtoCopyWith<$Res> {
  __$BackupDtoCopyWithImpl(this._self, this._then);

  final _BackupDto _self;
  final $Res Function(_BackupDto) _then;

/// Create a copy of BackupDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formatVersion = null,Object? exportedAt = null,Object? currency = null,Object? borrowers = null,Object? loans = null,Object? repayments = null,}) {
  return _then(_BackupDto(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,borrowers: null == borrowers ? _self._borrowers : borrowers // ignore: cast_nullable_to_non_nullable
as List<BorrowerDto>,loans: null == loans ? _self._loans : loans // ignore: cast_nullable_to_non_nullable
as List<LoanDto>,repayments: null == repayments ? _self._repayments : repayments // ignore: cast_nullable_to_non_nullable
as List<RepaymentDto>,
  ));
}


}


/// @nodoc
mixin _$BorrowerDto {

 int get id; String get name; String? get phone; String? get note;@LocalDayJsonConverter() LocalDay get createdAt;
/// Create a copy of BorrowerDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BorrowerDtoCopyWith<BorrowerDto> get copyWith => _$BorrowerDtoCopyWithImpl<BorrowerDto>(this as BorrowerDto, _$identity);

  /// Serializes this BorrowerDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BorrowerDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BorrowerDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BorrowerDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.phone,_this.note,_this.createdAt);
}

@override
String toString() {
  final _this = this as BorrowerDto;
  return 'BorrowerDto(id: ${_this.id}, name: ${_this.name}, phone: ${_this.phone}, note: ${_this.note}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $BorrowerDtoCopyWith<$Res>  {
  factory $BorrowerDtoCopyWith(BorrowerDto value, $Res Function(BorrowerDto) _then) = _$BorrowerDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? phone, String? note,@LocalDayJsonConverter() LocalDay createdAt
});




}
/// @nodoc
class _$BorrowerDtoCopyWithImpl<$Res>
    implements $BorrowerDtoCopyWith<$Res> {
  _$BorrowerDtoCopyWithImpl(this._self, this._then);

  final BorrowerDto _self;
  final $Res Function(BorrowerDto) _then;

/// Create a copy of BorrowerDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(BorrowerDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as LocalDay,
  ));
}

}


/// Adds pattern-matching-related methods to [BorrowerDto].
extension BorrowerDtoPatterns on BorrowerDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BorrowerDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BorrowerDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BorrowerDto value)  $default,){
final _that = this;
switch (_that) {
case _BorrowerDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BorrowerDto value)?  $default,){
final _that = this;
switch (_that) {
case _BorrowerDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? phone,  String? note, @LocalDayJsonConverter()  LocalDay createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BorrowerDto() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.note,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? phone,  String? note, @LocalDayJsonConverter()  LocalDay createdAt)  $default,) {final _that = this;
switch (_that) {
case _BorrowerDto():
return $default(_that.id,_that.name,_that.phone,_that.note,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? phone,  String? note, @LocalDayJsonConverter()  LocalDay createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BorrowerDto() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BorrowerDto implements BorrowerDto {
  const _BorrowerDto({required this.id, required this.name, this.phone, this.note, @LocalDayJsonConverter() required this.createdAt});
  factory _BorrowerDto.fromJson(Map<String, dynamic> json) => _$BorrowerDtoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? phone;
@override final  String? note;
@override@LocalDayJsonConverter() final  LocalDay createdAt;

/// Create a copy of BorrowerDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BorrowerDtoCopyWith<_BorrowerDto> get copyWith => __$BorrowerDtoCopyWithImpl<_BorrowerDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BorrowerDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BorrowerDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,phone,note,createdAt);
}

@override
String toString() {
    return 'BorrowerDto(id: $id, name: $name, phone: $phone, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BorrowerDtoCopyWith<$Res> implements $BorrowerDtoCopyWith<$Res> {
  factory _$BorrowerDtoCopyWith(_BorrowerDto value, $Res Function(_BorrowerDto) _then) = __$BorrowerDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? phone, String? note,@LocalDayJsonConverter() LocalDay createdAt
});




}
/// @nodoc
class __$BorrowerDtoCopyWithImpl<$Res>
    implements _$BorrowerDtoCopyWith<$Res> {
  __$BorrowerDtoCopyWithImpl(this._self, this._then);

  final _BorrowerDto _self;
  final $Res Function(_BorrowerDto) _then;

/// Create a copy of BorrowerDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_BorrowerDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as LocalDay,
  ));
}


}


/// @nodoc
mixin _$LoanDto {

 int get id; int get borrowerId; int get amountMinor;@LocalDayJsonConverter() LocalDay get loanDate;@LocalDayJsonConverter() LocalDay? get promisedReturnDate; String? get note;
/// Create a copy of LoanDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanDtoCopyWith<LoanDto> get copyWith => _$LoanDtoCopyWithImpl<LoanDto>(this as LoanDto, _$identity);

  /// Serializes this LoanDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LoanDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.borrowerId, _this.borrowerId) || other.borrowerId == _this.borrowerId)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.loanDate, _this.loanDate) || other.loanDate == _this.loanDate)&&(identical(other.promisedReturnDate, _this.promisedReturnDate) || other.promisedReturnDate == _this.promisedReturnDate)&&(identical(other.note, _this.note) || other.note == _this.note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LoanDto;
  return Object.hash(runtimeType,_this.id,_this.borrowerId,_this.amountMinor,_this.loanDate,_this.promisedReturnDate,_this.note);
}

@override
String toString() {
  final _this = this as LoanDto;
  return 'LoanDto(id: ${_this.id}, borrowerId: ${_this.borrowerId}, amountMinor: ${_this.amountMinor}, loanDate: ${_this.loanDate}, promisedReturnDate: ${_this.promisedReturnDate}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $LoanDtoCopyWith<$Res>  {
  factory $LoanDtoCopyWith(LoanDto value, $Res Function(LoanDto) _then) = _$LoanDtoCopyWithImpl;
@useResult
$Res call({
 int id, int borrowerId, int amountMinor,@LocalDayJsonConverter() LocalDay loanDate,@LocalDayJsonConverter() LocalDay? promisedReturnDate, String? note
});




}
/// @nodoc
class _$LoanDtoCopyWithImpl<$Res>
    implements $LoanDtoCopyWith<$Res> {
  _$LoanDtoCopyWithImpl(this._self, this._then);

  final LoanDto _self;
  final $Res Function(LoanDto) _then;

/// Create a copy of LoanDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? borrowerId = null,Object? amountMinor = null,Object? loanDate = null,Object? promisedReturnDate = freezed,Object? note = freezed,}) {
  return _then(LoanDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as int,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,loanDate: null == loanDate ? _self.loanDate : loanDate // ignore: cast_nullable_to_non_nullable
as LocalDay,promisedReturnDate: freezed == promisedReturnDate ? _self.promisedReturnDate : promisedReturnDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanDto].
extension LoanDtoPatterns on LoanDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanDto value)  $default,){
final _that = this;
switch (_that) {
case _LoanDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanDto value)?  $default,){
final _that = this;
switch (_that) {
case _LoanDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int borrowerId,  int amountMinor, @LocalDayJsonConverter()  LocalDay loanDate, @LocalDayJsonConverter()  LocalDay? promisedReturnDate,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanDto() when $default != null:
return $default(_that.id,_that.borrowerId,_that.amountMinor,_that.loanDate,_that.promisedReturnDate,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int borrowerId,  int amountMinor, @LocalDayJsonConverter()  LocalDay loanDate, @LocalDayJsonConverter()  LocalDay? promisedReturnDate,  String? note)  $default,) {final _that = this;
switch (_that) {
case _LoanDto():
return $default(_that.id,_that.borrowerId,_that.amountMinor,_that.loanDate,_that.promisedReturnDate,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int borrowerId,  int amountMinor, @LocalDayJsonConverter()  LocalDay loanDate, @LocalDayJsonConverter()  LocalDay? promisedReturnDate,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _LoanDto() when $default != null:
return $default(_that.id,_that.borrowerId,_that.amountMinor,_that.loanDate,_that.promisedReturnDate,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoanDto implements LoanDto {
  const _LoanDto({required this.id, required this.borrowerId, required this.amountMinor, @LocalDayJsonConverter() required this.loanDate, @LocalDayJsonConverter() this.promisedReturnDate, this.note});
  factory _LoanDto.fromJson(Map<String, dynamic> json) => _$LoanDtoFromJson(json);

@override final  int id;
@override final  int borrowerId;
@override final  int amountMinor;
@override@LocalDayJsonConverter() final  LocalDay loanDate;
@override@LocalDayJsonConverter() final  LocalDay? promisedReturnDate;
@override final  String? note;

/// Create a copy of LoanDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanDtoCopyWith<_LoanDto> get copyWith => __$LoanDtoCopyWithImpl<_LoanDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanDto&&(identical(other.id, id) || other.id == id)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.loanDate, loanDate) || other.loanDate == loanDate)&&(identical(other.promisedReturnDate, promisedReturnDate) || other.promisedReturnDate == promisedReturnDate)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,borrowerId,amountMinor,loanDate,promisedReturnDate,note);
}

@override
String toString() {
    return 'LoanDto(id: $id, borrowerId: $borrowerId, amountMinor: $amountMinor, loanDate: $loanDate, promisedReturnDate: $promisedReturnDate, note: $note)';
}


}

/// @nodoc
abstract mixin class _$LoanDtoCopyWith<$Res> implements $LoanDtoCopyWith<$Res> {
  factory _$LoanDtoCopyWith(_LoanDto value, $Res Function(_LoanDto) _then) = __$LoanDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, int borrowerId, int amountMinor,@LocalDayJsonConverter() LocalDay loanDate,@LocalDayJsonConverter() LocalDay? promisedReturnDate, String? note
});




}
/// @nodoc
class __$LoanDtoCopyWithImpl<$Res>
    implements _$LoanDtoCopyWith<$Res> {
  __$LoanDtoCopyWithImpl(this._self, this._then);

  final _LoanDto _self;
  final $Res Function(_LoanDto) _then;

/// Create a copy of LoanDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? borrowerId = null,Object? amountMinor = null,Object? loanDate = null,Object? promisedReturnDate = freezed,Object? note = freezed,}) {
  return _then(_LoanDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as int,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,loanDate: null == loanDate ? _self.loanDate : loanDate // ignore: cast_nullable_to_non_nullable
as LocalDay,promisedReturnDate: freezed == promisedReturnDate ? _self.promisedReturnDate : promisedReturnDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RepaymentDto {

 int get id; int get loanId; int get amountMinor;@LocalDayJsonConverter() LocalDay get repaymentDate; String? get note;
/// Create a copy of RepaymentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RepaymentDtoCopyWith<RepaymentDto> get copyWith => _$RepaymentDtoCopyWithImpl<RepaymentDto>(this as RepaymentDto, _$identity);

  /// Serializes this RepaymentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RepaymentDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RepaymentDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.loanId, _this.loanId) || other.loanId == _this.loanId)&&(identical(other.amountMinor, _this.amountMinor) || other.amountMinor == _this.amountMinor)&&(identical(other.repaymentDate, _this.repaymentDate) || other.repaymentDate == _this.repaymentDate)&&(identical(other.note, _this.note) || other.note == _this.note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RepaymentDto;
  return Object.hash(runtimeType,_this.id,_this.loanId,_this.amountMinor,_this.repaymentDate,_this.note);
}

@override
String toString() {
  final _this = this as RepaymentDto;
  return 'RepaymentDto(id: ${_this.id}, loanId: ${_this.loanId}, amountMinor: ${_this.amountMinor}, repaymentDate: ${_this.repaymentDate}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $RepaymentDtoCopyWith<$Res>  {
  factory $RepaymentDtoCopyWith(RepaymentDto value, $Res Function(RepaymentDto) _then) = _$RepaymentDtoCopyWithImpl;
@useResult
$Res call({
 int id, int loanId, int amountMinor,@LocalDayJsonConverter() LocalDay repaymentDate, String? note
});




}
/// @nodoc
class _$RepaymentDtoCopyWithImpl<$Res>
    implements $RepaymentDtoCopyWith<$Res> {
  _$RepaymentDtoCopyWithImpl(this._self, this._then);

  final RepaymentDto _self;
  final $Res Function(RepaymentDto) _then;

/// Create a copy of RepaymentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? loanId = null,Object? amountMinor = null,Object? repaymentDate = null,Object? note = freezed,}) {
  return _then(RepaymentDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,repaymentDate: null == repaymentDate ? _self.repaymentDate : repaymentDate // ignore: cast_nullable_to_non_nullable
as LocalDay,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RepaymentDto].
extension RepaymentDtoPatterns on RepaymentDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RepaymentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RepaymentDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RepaymentDto value)  $default,){
final _that = this;
switch (_that) {
case _RepaymentDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RepaymentDto value)?  $default,){
final _that = this;
switch (_that) {
case _RepaymentDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int loanId,  int amountMinor, @LocalDayJsonConverter()  LocalDay repaymentDate,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RepaymentDto() when $default != null:
return $default(_that.id,_that.loanId,_that.amountMinor,_that.repaymentDate,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int loanId,  int amountMinor, @LocalDayJsonConverter()  LocalDay repaymentDate,  String? note)  $default,) {final _that = this;
switch (_that) {
case _RepaymentDto():
return $default(_that.id,_that.loanId,_that.amountMinor,_that.repaymentDate,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int loanId,  int amountMinor, @LocalDayJsonConverter()  LocalDay repaymentDate,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _RepaymentDto() when $default != null:
return $default(_that.id,_that.loanId,_that.amountMinor,_that.repaymentDate,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RepaymentDto implements RepaymentDto {
  const _RepaymentDto({required this.id, required this.loanId, required this.amountMinor, @LocalDayJsonConverter() required this.repaymentDate, this.note});
  factory _RepaymentDto.fromJson(Map<String, dynamic> json) => _$RepaymentDtoFromJson(json);

@override final  int id;
@override final  int loanId;
@override final  int amountMinor;
@override@LocalDayJsonConverter() final  LocalDay repaymentDate;
@override final  String? note;

/// Create a copy of RepaymentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RepaymentDtoCopyWith<_RepaymentDto> get copyWith => __$RepaymentDtoCopyWithImpl<_RepaymentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RepaymentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RepaymentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.repaymentDate, repaymentDate) || other.repaymentDate == repaymentDate)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,loanId,amountMinor,repaymentDate,note);
}

@override
String toString() {
    return 'RepaymentDto(id: $id, loanId: $loanId, amountMinor: $amountMinor, repaymentDate: $repaymentDate, note: $note)';
}


}

/// @nodoc
abstract mixin class _$RepaymentDtoCopyWith<$Res> implements $RepaymentDtoCopyWith<$Res> {
  factory _$RepaymentDtoCopyWith(_RepaymentDto value, $Res Function(_RepaymentDto) _then) = __$RepaymentDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, int loanId, int amountMinor,@LocalDayJsonConverter() LocalDay repaymentDate, String? note
});




}
/// @nodoc
class __$RepaymentDtoCopyWithImpl<$Res>
    implements _$RepaymentDtoCopyWith<$Res> {
  __$RepaymentDtoCopyWithImpl(this._self, this._then);

  final _RepaymentDto _self;
  final $Res Function(_RepaymentDto) _then;

/// Create a copy of RepaymentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? loanId = null,Object? amountMinor = null,Object? repaymentDate = null,Object? note = freezed,}) {
  return _then(_RepaymentDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,repaymentDate: null == repaymentDate ? _self.repaymentDate : repaymentDate // ignore: cast_nullable_to_non_nullable
as LocalDay,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
