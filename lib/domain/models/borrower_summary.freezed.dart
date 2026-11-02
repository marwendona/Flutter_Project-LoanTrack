// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'borrower_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BorrowerSummary {

 Borrower get borrower; Money get totalLent; Money get totalRepaid; int get loanCount;/// Loans not fully repaid (remaining due > 0).
 int get activeLoanCount; int get overdueLoanCount;
/// Create a copy of BorrowerSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BorrowerSummaryCopyWith<BorrowerSummary> get copyWith => _$BorrowerSummaryCopyWithImpl<BorrowerSummary>(this as BorrowerSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BorrowerSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BorrowerSummary&&(identical(other.borrower, _this.borrower) || other.borrower == _this.borrower)&&(identical(other.totalLent, _this.totalLent) || other.totalLent == _this.totalLent)&&(identical(other.totalRepaid, _this.totalRepaid) || other.totalRepaid == _this.totalRepaid)&&(identical(other.loanCount, _this.loanCount) || other.loanCount == _this.loanCount)&&(identical(other.activeLoanCount, _this.activeLoanCount) || other.activeLoanCount == _this.activeLoanCount)&&(identical(other.overdueLoanCount, _this.overdueLoanCount) || other.overdueLoanCount == _this.overdueLoanCount));
}


@override
int get hashCode {
  final _this = this as BorrowerSummary;
  return Object.hash(runtimeType,_this.borrower,_this.totalLent,_this.totalRepaid,_this.loanCount,_this.activeLoanCount,_this.overdueLoanCount);
}

@override
String toString() {
  final _this = this as BorrowerSummary;
  return 'BorrowerSummary(borrower: ${_this.borrower}, totalLent: ${_this.totalLent}, totalRepaid: ${_this.totalRepaid}, loanCount: ${_this.loanCount}, activeLoanCount: ${_this.activeLoanCount}, overdueLoanCount: ${_this.overdueLoanCount})';
}


}

/// @nodoc
abstract mixin class $BorrowerSummaryCopyWith<$Res>  {
  factory $BorrowerSummaryCopyWith(BorrowerSummary value, $Res Function(BorrowerSummary) _then) = _$BorrowerSummaryCopyWithImpl;
@useResult
$Res call({
 Borrower borrower, Money totalLent, Money totalRepaid, int loanCount, int activeLoanCount, int overdueLoanCount
});


$BorrowerCopyWith<$Res> get borrower;

}
/// @nodoc
class _$BorrowerSummaryCopyWithImpl<$Res>
    implements $BorrowerSummaryCopyWith<$Res> {
  _$BorrowerSummaryCopyWithImpl(this._self, this._then);

  final BorrowerSummary _self;
  final $Res Function(BorrowerSummary) _then;

/// Create a copy of BorrowerSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? borrower = null,Object? totalLent = null,Object? totalRepaid = null,Object? loanCount = null,Object? activeLoanCount = null,Object? overdueLoanCount = null,}) {
  return _then(BorrowerSummary(
borrower: null == borrower ? _self.borrower : borrower // ignore: cast_nullable_to_non_nullable
as Borrower,totalLent: null == totalLent ? _self.totalLent : totalLent // ignore: cast_nullable_to_non_nullable
as Money,totalRepaid: null == totalRepaid ? _self.totalRepaid : totalRepaid // ignore: cast_nullable_to_non_nullable
as Money,loanCount: null == loanCount ? _self.loanCount : loanCount // ignore: cast_nullable_to_non_nullable
as int,activeLoanCount: null == activeLoanCount ? _self.activeLoanCount : activeLoanCount // ignore: cast_nullable_to_non_nullable
as int,overdueLoanCount: null == overdueLoanCount ? _self.overdueLoanCount : overdueLoanCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of BorrowerSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BorrowerCopyWith<$Res> get borrower {

  return $BorrowerCopyWith<$Res>(_self.borrower, (value) {
    return _then(_self.copyWith(borrower: value));
  });
}
}


/// Adds pattern-matching-related methods to [BorrowerSummary].
extension BorrowerSummaryPatterns on BorrowerSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BorrowerSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BorrowerSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BorrowerSummary value)  $default,){
final _that = this;
switch (_that) {
case _BorrowerSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BorrowerSummary value)?  $default,){
final _that = this;
switch (_that) {
case _BorrowerSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Borrower borrower,  Money totalLent,  Money totalRepaid,  int loanCount,  int activeLoanCount,  int overdueLoanCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BorrowerSummary() when $default != null:
return $default(_that.borrower,_that.totalLent,_that.totalRepaid,_that.loanCount,_that.activeLoanCount,_that.overdueLoanCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Borrower borrower,  Money totalLent,  Money totalRepaid,  int loanCount,  int activeLoanCount,  int overdueLoanCount)  $default,) {final _that = this;
switch (_that) {
case _BorrowerSummary():
return $default(_that.borrower,_that.totalLent,_that.totalRepaid,_that.loanCount,_that.activeLoanCount,_that.overdueLoanCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Borrower borrower,  Money totalLent,  Money totalRepaid,  int loanCount,  int activeLoanCount,  int overdueLoanCount)?  $default,) {final _that = this;
switch (_that) {
case _BorrowerSummary() when $default != null:
return $default(_that.borrower,_that.totalLent,_that.totalRepaid,_that.loanCount,_that.activeLoanCount,_that.overdueLoanCount);case _:
  return null;

}
}

}

/// @nodoc


class _BorrowerSummary extends BorrowerSummary {
  const _BorrowerSummary({required this.borrower, required this.totalLent, required this.totalRepaid, required this.loanCount, required this.activeLoanCount, required this.overdueLoanCount}): super._();


@override final  Borrower borrower;
@override final  Money totalLent;
@override final  Money totalRepaid;
@override final  int loanCount;
/// Loans not fully repaid (remaining due > 0).
@override final  int activeLoanCount;
@override final  int overdueLoanCount;

/// Create a copy of BorrowerSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BorrowerSummaryCopyWith<_BorrowerSummary> get copyWith => __$BorrowerSummaryCopyWithImpl<_BorrowerSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BorrowerSummary&&(identical(other.borrower, borrower) || other.borrower == borrower)&&(identical(other.totalLent, totalLent) || other.totalLent == totalLent)&&(identical(other.totalRepaid, totalRepaid) || other.totalRepaid == totalRepaid)&&(identical(other.loanCount, loanCount) || other.loanCount == loanCount)&&(identical(other.activeLoanCount, activeLoanCount) || other.activeLoanCount == activeLoanCount)&&(identical(other.overdueLoanCount, overdueLoanCount) || other.overdueLoanCount == overdueLoanCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,borrower,totalLent,totalRepaid,loanCount,activeLoanCount,overdueLoanCount);
}

@override
String toString() {
    return 'BorrowerSummary(borrower: $borrower, totalLent: $totalLent, totalRepaid: $totalRepaid, loanCount: $loanCount, activeLoanCount: $activeLoanCount, overdueLoanCount: $overdueLoanCount)';
}


}

/// @nodoc
abstract mixin class _$BorrowerSummaryCopyWith<$Res> implements $BorrowerSummaryCopyWith<$Res> {
  factory _$BorrowerSummaryCopyWith(_BorrowerSummary value, $Res Function(_BorrowerSummary) _then) = __$BorrowerSummaryCopyWithImpl;
@override @useResult
$Res call({
 Borrower borrower, Money totalLent, Money totalRepaid, int loanCount, int activeLoanCount, int overdueLoanCount
});


@override $BorrowerCopyWith<$Res> get borrower;

}
/// @nodoc
class __$BorrowerSummaryCopyWithImpl<$Res>
    implements _$BorrowerSummaryCopyWith<$Res> {
  __$BorrowerSummaryCopyWithImpl(this._self, this._then);

  final _BorrowerSummary _self;
  final $Res Function(_BorrowerSummary) _then;

/// Create a copy of BorrowerSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? borrower = null,Object? totalLent = null,Object? totalRepaid = null,Object? loanCount = null,Object? activeLoanCount = null,Object? overdueLoanCount = null,}) {
  return _then(_BorrowerSummary(
borrower: null == borrower ? _self.borrower : borrower // ignore: cast_nullable_to_non_nullable
as Borrower,totalLent: null == totalLent ? _self.totalLent : totalLent // ignore: cast_nullable_to_non_nullable
as Money,totalRepaid: null == totalRepaid ? _self.totalRepaid : totalRepaid // ignore: cast_nullable_to_non_nullable
as Money,loanCount: null == loanCount ? _self.loanCount : loanCount // ignore: cast_nullable_to_non_nullable
as int,activeLoanCount: null == activeLoanCount ? _self.activeLoanCount : activeLoanCount // ignore: cast_nullable_to_non_nullable
as int,overdueLoanCount: null == overdueLoanCount ? _self.overdueLoanCount : overdueLoanCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of BorrowerSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BorrowerCopyWith<$Res> get borrower {

  return $BorrowerCopyWith<$Res>(_self.borrower, (value) {
    return _then(_self.copyWith(borrower: value));
  });
}
}

// dart format on
