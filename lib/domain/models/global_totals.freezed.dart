// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_totals.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GlobalTotals {

 Money get totalLent; Money get totalRepaid; int get loanCount;/// Borrowers with a remaining amount due > 0.
 int get borrowersWithRemainingCount; int get overdueLoanCount;/// Sum of the remaining amounts due of the overdue loans.
 Money get overdueAmount;
/// Create a copy of GlobalTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalTotalsCopyWith<GlobalTotals> get copyWith => _$GlobalTotalsCopyWithImpl<GlobalTotals>(this as GlobalTotals, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GlobalTotals;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalTotals&&(identical(other.totalLent, _this.totalLent) || other.totalLent == _this.totalLent)&&(identical(other.totalRepaid, _this.totalRepaid) || other.totalRepaid == _this.totalRepaid)&&(identical(other.loanCount, _this.loanCount) || other.loanCount == _this.loanCount)&&(identical(other.borrowersWithRemainingCount, _this.borrowersWithRemainingCount) || other.borrowersWithRemainingCount == _this.borrowersWithRemainingCount)&&(identical(other.overdueLoanCount, _this.overdueLoanCount) || other.overdueLoanCount == _this.overdueLoanCount)&&(identical(other.overdueAmount, _this.overdueAmount) || other.overdueAmount == _this.overdueAmount));
}


@override
int get hashCode {
  final _this = this as GlobalTotals;
  return Object.hash(runtimeType,_this.totalLent,_this.totalRepaid,_this.loanCount,_this.borrowersWithRemainingCount,_this.overdueLoanCount,_this.overdueAmount);
}

@override
String toString() {
  final _this = this as GlobalTotals;
  return 'GlobalTotals(totalLent: ${_this.totalLent}, totalRepaid: ${_this.totalRepaid}, loanCount: ${_this.loanCount}, borrowersWithRemainingCount: ${_this.borrowersWithRemainingCount}, overdueLoanCount: ${_this.overdueLoanCount}, overdueAmount: ${_this.overdueAmount})';
}


}

/// @nodoc
abstract mixin class $GlobalTotalsCopyWith<$Res>  {
  factory $GlobalTotalsCopyWith(GlobalTotals value, $Res Function(GlobalTotals) _then) = _$GlobalTotalsCopyWithImpl;
@useResult
$Res call({
 Money totalLent, Money totalRepaid, int loanCount, int borrowersWithRemainingCount, int overdueLoanCount, Money overdueAmount
});




}
/// @nodoc
class _$GlobalTotalsCopyWithImpl<$Res>
    implements $GlobalTotalsCopyWith<$Res> {
  _$GlobalTotalsCopyWithImpl(this._self, this._then);

  final GlobalTotals _self;
  final $Res Function(GlobalTotals) _then;

/// Create a copy of GlobalTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalLent = null,Object? totalRepaid = null,Object? loanCount = null,Object? borrowersWithRemainingCount = null,Object? overdueLoanCount = null,Object? overdueAmount = null,}) {
  return _then(GlobalTotals(
totalLent: null == totalLent ? _self.totalLent : totalLent // ignore: cast_nullable_to_non_nullable
as Money,totalRepaid: null == totalRepaid ? _self.totalRepaid : totalRepaid // ignore: cast_nullable_to_non_nullable
as Money,loanCount: null == loanCount ? _self.loanCount : loanCount // ignore: cast_nullable_to_non_nullable
as int,borrowersWithRemainingCount: null == borrowersWithRemainingCount ? _self.borrowersWithRemainingCount : borrowersWithRemainingCount // ignore: cast_nullable_to_non_nullable
as int,overdueLoanCount: null == overdueLoanCount ? _self.overdueLoanCount : overdueLoanCount // ignore: cast_nullable_to_non_nullable
as int,overdueAmount: null == overdueAmount ? _self.overdueAmount : overdueAmount // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalTotals].
extension GlobalTotalsPatterns on GlobalTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalTotals value)  $default,){
final _that = this;
switch (_that) {
case _GlobalTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalTotals value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Money totalLent,  Money totalRepaid,  int loanCount,  int borrowersWithRemainingCount,  int overdueLoanCount,  Money overdueAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalTotals() when $default != null:
return $default(_that.totalLent,_that.totalRepaid,_that.loanCount,_that.borrowersWithRemainingCount,_that.overdueLoanCount,_that.overdueAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Money totalLent,  Money totalRepaid,  int loanCount,  int borrowersWithRemainingCount,  int overdueLoanCount,  Money overdueAmount)  $default,) {final _that = this;
switch (_that) {
case _GlobalTotals():
return $default(_that.totalLent,_that.totalRepaid,_that.loanCount,_that.borrowersWithRemainingCount,_that.overdueLoanCount,_that.overdueAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Money totalLent,  Money totalRepaid,  int loanCount,  int borrowersWithRemainingCount,  int overdueLoanCount,  Money overdueAmount)?  $default,) {final _that = this;
switch (_that) {
case _GlobalTotals() when $default != null:
return $default(_that.totalLent,_that.totalRepaid,_that.loanCount,_that.borrowersWithRemainingCount,_that.overdueLoanCount,_that.overdueAmount);case _:
  return null;

}
}

}

/// @nodoc


class _GlobalTotals extends GlobalTotals {
  const _GlobalTotals({required this.totalLent, required this.totalRepaid, required this.loanCount, required this.borrowersWithRemainingCount, required this.overdueLoanCount, required this.overdueAmount}): super._();


@override final  Money totalLent;
@override final  Money totalRepaid;
@override final  int loanCount;
/// Borrowers with a remaining amount due > 0.
@override final  int borrowersWithRemainingCount;
@override final  int overdueLoanCount;
/// Sum of the remaining amounts due of the overdue loans.
@override final  Money overdueAmount;

/// Create a copy of GlobalTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalTotalsCopyWith<_GlobalTotals> get copyWith => __$GlobalTotalsCopyWithImpl<_GlobalTotals>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalTotals&&(identical(other.totalLent, totalLent) || other.totalLent == totalLent)&&(identical(other.totalRepaid, totalRepaid) || other.totalRepaid == totalRepaid)&&(identical(other.loanCount, loanCount) || other.loanCount == loanCount)&&(identical(other.borrowersWithRemainingCount, borrowersWithRemainingCount) || other.borrowersWithRemainingCount == borrowersWithRemainingCount)&&(identical(other.overdueLoanCount, overdueLoanCount) || other.overdueLoanCount == overdueLoanCount)&&(identical(other.overdueAmount, overdueAmount) || other.overdueAmount == overdueAmount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,totalLent,totalRepaid,loanCount,borrowersWithRemainingCount,overdueLoanCount,overdueAmount);
}

@override
String toString() {
    return 'GlobalTotals(totalLent: $totalLent, totalRepaid: $totalRepaid, loanCount: $loanCount, borrowersWithRemainingCount: $borrowersWithRemainingCount, overdueLoanCount: $overdueLoanCount, overdueAmount: $overdueAmount)';
}


}

/// @nodoc
abstract mixin class _$GlobalTotalsCopyWith<$Res> implements $GlobalTotalsCopyWith<$Res> {
  factory _$GlobalTotalsCopyWith(_GlobalTotals value, $Res Function(_GlobalTotals) _then) = __$GlobalTotalsCopyWithImpl;
@override @useResult
$Res call({
 Money totalLent, Money totalRepaid, int loanCount, int borrowersWithRemainingCount, int overdueLoanCount, Money overdueAmount
});




}
/// @nodoc
class __$GlobalTotalsCopyWithImpl<$Res>
    implements _$GlobalTotalsCopyWith<$Res> {
  __$GlobalTotalsCopyWithImpl(this._self, this._then);

  final _GlobalTotals _self;
  final $Res Function(_GlobalTotals) _then;

/// Create a copy of GlobalTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalLent = null,Object? totalRepaid = null,Object? loanCount = null,Object? borrowersWithRemainingCount = null,Object? overdueLoanCount = null,Object? overdueAmount = null,}) {
  return _then(_GlobalTotals(
totalLent: null == totalLent ? _self.totalLent : totalLent // ignore: cast_nullable_to_non_nullable
as Money,totalRepaid: null == totalRepaid ? _self.totalRepaid : totalRepaid // ignore: cast_nullable_to_non_nullable
as Money,loanCount: null == loanCount ? _self.loanCount : loanCount // ignore: cast_nullable_to_non_nullable
as int,borrowersWithRemainingCount: null == borrowersWithRemainingCount ? _self.borrowersWithRemainingCount : borrowersWithRemainingCount // ignore: cast_nullable_to_non_nullable
as int,overdueLoanCount: null == overdueLoanCount ? _self.overdueLoanCount : overdueLoanCount // ignore: cast_nullable_to_non_nullable
as int,overdueAmount: null == overdueAmount ? _self.overdueAmount : overdueAmount // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

// dart format on
