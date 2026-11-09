// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoanBalance {

 Money get amount; Money get repaid; LocalDay? get promisedReturnDate;/// Date of the most recent repayment, null if there is none (RG-22).
 LocalDay? get lastRepaymentDate;
/// Create a copy of LoanBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanBalanceCopyWith<LoanBalance> get copyWith => _$LoanBalanceCopyWithImpl<LoanBalance>(this as LoanBalance, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LoanBalance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanBalance&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.repaid, _this.repaid) || other.repaid == _this.repaid)&&(identical(other.promisedReturnDate, _this.promisedReturnDate) || other.promisedReturnDate == _this.promisedReturnDate)&&(identical(other.lastRepaymentDate, _this.lastRepaymentDate) || other.lastRepaymentDate == _this.lastRepaymentDate));
}


@override
int get hashCode {
  final _this = this as LoanBalance;
  return Object.hash(runtimeType,_this.amount,_this.repaid,_this.promisedReturnDate,_this.lastRepaymentDate);
}

@override
String toString() {
  final _this = this as LoanBalance;
  return 'LoanBalance(amount: ${_this.amount}, repaid: ${_this.repaid}, promisedReturnDate: ${_this.promisedReturnDate}, lastRepaymentDate: ${_this.lastRepaymentDate})';
}


}

/// @nodoc
abstract mixin class $LoanBalanceCopyWith<$Res>  {
  factory $LoanBalanceCopyWith(LoanBalance value, $Res Function(LoanBalance) _then) = _$LoanBalanceCopyWithImpl;
@useResult
$Res call({
 Money amount, Money repaid, LocalDay? promisedReturnDate, LocalDay? lastRepaymentDate
});




}
/// @nodoc
class _$LoanBalanceCopyWithImpl<$Res>
    implements $LoanBalanceCopyWith<$Res> {
  _$LoanBalanceCopyWithImpl(this._self, this._then);

  final LoanBalance _self;
  final $Res Function(LoanBalance) _then;

/// Create a copy of LoanBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? repaid = null,Object? promisedReturnDate = freezed,Object? lastRepaymentDate = freezed,}) {
  return _then(LoanBalance(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,repaid: null == repaid ? _self.repaid : repaid // ignore: cast_nullable_to_non_nullable
as Money,promisedReturnDate: freezed == promisedReturnDate ? _self.promisedReturnDate : promisedReturnDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,lastRepaymentDate: freezed == lastRepaymentDate ? _self.lastRepaymentDate : lastRepaymentDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanBalance].
extension LoanBalancePatterns on LoanBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanBalance value)  $default,){
final _that = this;
switch (_that) {
case _LoanBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanBalance value)?  $default,){
final _that = this;
switch (_that) {
case _LoanBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Money amount,  Money repaid,  LocalDay? promisedReturnDate,  LocalDay? lastRepaymentDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanBalance() when $default != null:
return $default(_that.amount,_that.repaid,_that.promisedReturnDate,_that.lastRepaymentDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Money amount,  Money repaid,  LocalDay? promisedReturnDate,  LocalDay? lastRepaymentDate)  $default,) {final _that = this;
switch (_that) {
case _LoanBalance():
return $default(_that.amount,_that.repaid,_that.promisedReturnDate,_that.lastRepaymentDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Money amount,  Money repaid,  LocalDay? promisedReturnDate,  LocalDay? lastRepaymentDate)?  $default,) {final _that = this;
switch (_that) {
case _LoanBalance() when $default != null:
return $default(_that.amount,_that.repaid,_that.promisedReturnDate,_that.lastRepaymentDate);case _:
  return null;

}
}

}

/// @nodoc


class _LoanBalance extends LoanBalance {
  const _LoanBalance({required this.amount, required this.repaid, this.promisedReturnDate, this.lastRepaymentDate}): super._();


@override final  Money amount;
@override final  Money repaid;
@override final  LocalDay? promisedReturnDate;
/// Date of the most recent repayment, null if there is none (RG-22).
@override final  LocalDay? lastRepaymentDate;

/// Create a copy of LoanBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanBalanceCopyWith<_LoanBalance> get copyWith => __$LoanBalanceCopyWithImpl<_LoanBalance>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanBalance&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.repaid, repaid) || other.repaid == repaid)&&(identical(other.promisedReturnDate, promisedReturnDate) || other.promisedReturnDate == promisedReturnDate)&&(identical(other.lastRepaymentDate, lastRepaymentDate) || other.lastRepaymentDate == lastRepaymentDate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,amount,repaid,promisedReturnDate,lastRepaymentDate);
}

@override
String toString() {
    return 'LoanBalance(amount: $amount, repaid: $repaid, promisedReturnDate: $promisedReturnDate, lastRepaymentDate: $lastRepaymentDate)';
}


}

/// @nodoc
abstract mixin class _$LoanBalanceCopyWith<$Res> implements $LoanBalanceCopyWith<$Res> {
  factory _$LoanBalanceCopyWith(_LoanBalance value, $Res Function(_LoanBalance) _then) = __$LoanBalanceCopyWithImpl;
@override @useResult
$Res call({
 Money amount, Money repaid, LocalDay? promisedReturnDate, LocalDay? lastRepaymentDate
});




}
/// @nodoc
class __$LoanBalanceCopyWithImpl<$Res>
    implements _$LoanBalanceCopyWith<$Res> {
  __$LoanBalanceCopyWithImpl(this._self, this._then);

  final _LoanBalance _self;
  final $Res Function(_LoanBalance) _then;

/// Create a copy of LoanBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? repaid = null,Object? promisedReturnDate = freezed,Object? lastRepaymentDate = freezed,}) {
  return _then(_LoanBalance(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,repaid: null == repaid ? _self.repaid : repaid // ignore: cast_nullable_to_non_nullable
as Money,promisedReturnDate: freezed == promisedReturnDate ? _self.promisedReturnDate : promisedReturnDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,lastRepaymentDate: freezed == lastRepaymentDate ? _self.lastRepaymentDate : lastRepaymentDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,
  ));
}


}

// dart format on
