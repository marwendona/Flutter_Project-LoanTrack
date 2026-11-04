// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoanSummary {

 Loan get loan;/// Sum of the loan repayments (RG-21).
 Money get repaid;/// Date of the earliest repayment, null if there is none (RG-11, RG-17).
 LocalDay? get firstRepaymentDate;/// Date of the most recent repayment, null if there is none (RG-22).
 LocalDay? get lastRepaymentDate;
/// Create a copy of LoanSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanSummaryCopyWith<LoanSummary> get copyWith => _$LoanSummaryCopyWithImpl<LoanSummary>(this as LoanSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LoanSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanSummary&&(identical(other.loan, _this.loan) || other.loan == _this.loan)&&(identical(other.repaid, _this.repaid) || other.repaid == _this.repaid)&&(identical(other.firstRepaymentDate, _this.firstRepaymentDate) || other.firstRepaymentDate == _this.firstRepaymentDate)&&(identical(other.lastRepaymentDate, _this.lastRepaymentDate) || other.lastRepaymentDate == _this.lastRepaymentDate));
}


@override
int get hashCode {
  final _this = this as LoanSummary;
  return Object.hash(runtimeType,_this.loan,_this.repaid,_this.firstRepaymentDate,_this.lastRepaymentDate);
}

@override
String toString() {
  final _this = this as LoanSummary;
  return 'LoanSummary(loan: ${_this.loan}, repaid: ${_this.repaid}, firstRepaymentDate: ${_this.firstRepaymentDate}, lastRepaymentDate: ${_this.lastRepaymentDate})';
}


}

/// @nodoc
abstract mixin class $LoanSummaryCopyWith<$Res>  {
  factory $LoanSummaryCopyWith(LoanSummary value, $Res Function(LoanSummary) _then) = _$LoanSummaryCopyWithImpl;
@useResult
$Res call({
 Loan loan, Money repaid, LocalDay? firstRepaymentDate, LocalDay? lastRepaymentDate
});


$LoanCopyWith<$Res> get loan;

}
/// @nodoc
class _$LoanSummaryCopyWithImpl<$Res>
    implements $LoanSummaryCopyWith<$Res> {
  _$LoanSummaryCopyWithImpl(this._self, this._then);

  final LoanSummary _self;
  final $Res Function(LoanSummary) _then;

/// Create a copy of LoanSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loan = null,Object? repaid = null,Object? firstRepaymentDate = freezed,Object? lastRepaymentDate = freezed,}) {
  return _then(LoanSummary(
loan: null == loan ? _self.loan : loan // ignore: cast_nullable_to_non_nullable
as Loan,repaid: null == repaid ? _self.repaid : repaid // ignore: cast_nullable_to_non_nullable
as Money,firstRepaymentDate: freezed == firstRepaymentDate ? _self.firstRepaymentDate : firstRepaymentDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,lastRepaymentDate: freezed == lastRepaymentDate ? _self.lastRepaymentDate : lastRepaymentDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,
  ));
}
/// Create a copy of LoanSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoanCopyWith<$Res> get loan {

  return $LoanCopyWith<$Res>(_self.loan, (value) {
    return _then(_self.copyWith(loan: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoanSummary].
extension LoanSummaryPatterns on LoanSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanSummary value)  $default,){
final _that = this;
switch (_that) {
case _LoanSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanSummary value)?  $default,){
final _that = this;
switch (_that) {
case _LoanSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Loan loan,  Money repaid,  LocalDay? firstRepaymentDate,  LocalDay? lastRepaymentDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanSummary() when $default != null:
return $default(_that.loan,_that.repaid,_that.firstRepaymentDate,_that.lastRepaymentDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Loan loan,  Money repaid,  LocalDay? firstRepaymentDate,  LocalDay? lastRepaymentDate)  $default,) {final _that = this;
switch (_that) {
case _LoanSummary():
return $default(_that.loan,_that.repaid,_that.firstRepaymentDate,_that.lastRepaymentDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Loan loan,  Money repaid,  LocalDay? firstRepaymentDate,  LocalDay? lastRepaymentDate)?  $default,) {final _that = this;
switch (_that) {
case _LoanSummary() when $default != null:
return $default(_that.loan,_that.repaid,_that.firstRepaymentDate,_that.lastRepaymentDate);case _:
  return null;

}
}

}

/// @nodoc


class _LoanSummary extends LoanSummary {
  const _LoanSummary({required this.loan, required this.repaid, this.firstRepaymentDate, this.lastRepaymentDate}): super._();


@override final  Loan loan;
/// Sum of the loan repayments (RG-21).
@override final  Money repaid;
/// Date of the earliest repayment, null if there is none (RG-11, RG-17).
@override final  LocalDay? firstRepaymentDate;
/// Date of the most recent repayment, null if there is none (RG-22).
@override final  LocalDay? lastRepaymentDate;

/// Create a copy of LoanSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanSummaryCopyWith<_LoanSummary> get copyWith => __$LoanSummaryCopyWithImpl<_LoanSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanSummary&&(identical(other.loan, loan) || other.loan == loan)&&(identical(other.repaid, repaid) || other.repaid == repaid)&&(identical(other.firstRepaymentDate, firstRepaymentDate) || other.firstRepaymentDate == firstRepaymentDate)&&(identical(other.lastRepaymentDate, lastRepaymentDate) || other.lastRepaymentDate == lastRepaymentDate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,loan,repaid,firstRepaymentDate,lastRepaymentDate);
}

@override
String toString() {
    return 'LoanSummary(loan: $loan, repaid: $repaid, firstRepaymentDate: $firstRepaymentDate, lastRepaymentDate: $lastRepaymentDate)';
}


}

/// @nodoc
abstract mixin class _$LoanSummaryCopyWith<$Res> implements $LoanSummaryCopyWith<$Res> {
  factory _$LoanSummaryCopyWith(_LoanSummary value, $Res Function(_LoanSummary) _then) = __$LoanSummaryCopyWithImpl;
@override @useResult
$Res call({
 Loan loan, Money repaid, LocalDay? firstRepaymentDate, LocalDay? lastRepaymentDate
});


@override $LoanCopyWith<$Res> get loan;

}
/// @nodoc
class __$LoanSummaryCopyWithImpl<$Res>
    implements _$LoanSummaryCopyWith<$Res> {
  __$LoanSummaryCopyWithImpl(this._self, this._then);

  final _LoanSummary _self;
  final $Res Function(_LoanSummary) _then;

/// Create a copy of LoanSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loan = null,Object? repaid = null,Object? firstRepaymentDate = freezed,Object? lastRepaymentDate = freezed,}) {
  return _then(_LoanSummary(
loan: null == loan ? _self.loan : loan // ignore: cast_nullable_to_non_nullable
as Loan,repaid: null == repaid ? _self.repaid : repaid // ignore: cast_nullable_to_non_nullable
as Money,firstRepaymentDate: freezed == firstRepaymentDate ? _self.firstRepaymentDate : firstRepaymentDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,lastRepaymentDate: freezed == lastRepaymentDate ? _self.lastRepaymentDate : lastRepaymentDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,
  ));
}

/// Create a copy of LoanSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoanCopyWith<$Res> get loan {

  return $LoanCopyWith<$Res>(_self.loan, (value) {
    return _then(_self.copyWith(loan: value));
  });
}
}

// dart format on
