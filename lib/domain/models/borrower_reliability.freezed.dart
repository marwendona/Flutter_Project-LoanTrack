// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'borrower_reliability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BorrowerReliability {

/// Number of loans on time or late (RG-60).
 int get evaluatedLoanCount;/// N: number of late loans.
 int get lateLoanCount;/// L: number of late loans whose delay is long (RG-61).
 int get longDelayCount; ReliabilityColor get color;
/// Create a copy of BorrowerReliability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BorrowerReliabilityCopyWith<BorrowerReliability> get copyWith => _$BorrowerReliabilityCopyWithImpl<BorrowerReliability>(this as BorrowerReliability, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BorrowerReliability;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BorrowerReliability&&(identical(other.evaluatedLoanCount, _this.evaluatedLoanCount) || other.evaluatedLoanCount == _this.evaluatedLoanCount)&&(identical(other.lateLoanCount, _this.lateLoanCount) || other.lateLoanCount == _this.lateLoanCount)&&(identical(other.longDelayCount, _this.longDelayCount) || other.longDelayCount == _this.longDelayCount)&&(identical(other.color, _this.color) || other.color == _this.color));
}


@override
int get hashCode {
  final _this = this as BorrowerReliability;
  return Object.hash(runtimeType,_this.evaluatedLoanCount,_this.lateLoanCount,_this.longDelayCount,_this.color);
}

@override
String toString() {
  final _this = this as BorrowerReliability;
  return 'BorrowerReliability(evaluatedLoanCount: ${_this.evaluatedLoanCount}, lateLoanCount: ${_this.lateLoanCount}, longDelayCount: ${_this.longDelayCount}, color: ${_this.color})';
}


}

/// @nodoc
abstract mixin class $BorrowerReliabilityCopyWith<$Res>  {
  factory $BorrowerReliabilityCopyWith(BorrowerReliability value, $Res Function(BorrowerReliability) _then) = _$BorrowerReliabilityCopyWithImpl;
@useResult
$Res call({
 int evaluatedLoanCount, int lateLoanCount, int longDelayCount, ReliabilityColor color
});




}
/// @nodoc
class _$BorrowerReliabilityCopyWithImpl<$Res>
    implements $BorrowerReliabilityCopyWith<$Res> {
  _$BorrowerReliabilityCopyWithImpl(this._self, this._then);

  final BorrowerReliability _self;
  final $Res Function(BorrowerReliability) _then;

/// Create a copy of BorrowerReliability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? evaluatedLoanCount = null,Object? lateLoanCount = null,Object? longDelayCount = null,Object? color = null,}) {
  return _then(BorrowerReliability(
evaluatedLoanCount: null == evaluatedLoanCount ? _self.evaluatedLoanCount : evaluatedLoanCount // ignore: cast_nullable_to_non_nullable
as int,lateLoanCount: null == lateLoanCount ? _self.lateLoanCount : lateLoanCount // ignore: cast_nullable_to_non_nullable
as int,longDelayCount: null == longDelayCount ? _self.longDelayCount : longDelayCount // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as ReliabilityColor,
  ));
}

}


/// Adds pattern-matching-related methods to [BorrowerReliability].
extension BorrowerReliabilityPatterns on BorrowerReliability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BorrowerReliability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BorrowerReliability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BorrowerReliability value)  $default,){
final _that = this;
switch (_that) {
case _BorrowerReliability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BorrowerReliability value)?  $default,){
final _that = this;
switch (_that) {
case _BorrowerReliability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int evaluatedLoanCount,  int lateLoanCount,  int longDelayCount,  ReliabilityColor color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BorrowerReliability() when $default != null:
return $default(_that.evaluatedLoanCount,_that.lateLoanCount,_that.longDelayCount,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int evaluatedLoanCount,  int lateLoanCount,  int longDelayCount,  ReliabilityColor color)  $default,) {final _that = this;
switch (_that) {
case _BorrowerReliability():
return $default(_that.evaluatedLoanCount,_that.lateLoanCount,_that.longDelayCount,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int evaluatedLoanCount,  int lateLoanCount,  int longDelayCount,  ReliabilityColor color)?  $default,) {final _that = this;
switch (_that) {
case _BorrowerReliability() when $default != null:
return $default(_that.evaluatedLoanCount,_that.lateLoanCount,_that.longDelayCount,_that.color);case _:
  return null;

}
}

}

/// @nodoc


class _BorrowerReliability extends BorrowerReliability {
  const _BorrowerReliability({required this.evaluatedLoanCount, required this.lateLoanCount, required this.longDelayCount, required this.color}): super._();


/// Number of loans on time or late (RG-60).
@override final  int evaluatedLoanCount;
/// N: number of late loans.
@override final  int lateLoanCount;
/// L: number of late loans whose delay is long (RG-61).
@override final  int longDelayCount;
@override final  ReliabilityColor color;

/// Create a copy of BorrowerReliability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BorrowerReliabilityCopyWith<_BorrowerReliability> get copyWith => __$BorrowerReliabilityCopyWithImpl<_BorrowerReliability>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BorrowerReliability&&(identical(other.evaluatedLoanCount, evaluatedLoanCount) || other.evaluatedLoanCount == evaluatedLoanCount)&&(identical(other.lateLoanCount, lateLoanCount) || other.lateLoanCount == lateLoanCount)&&(identical(other.longDelayCount, longDelayCount) || other.longDelayCount == longDelayCount)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode {
    return Object.hash(runtimeType,evaluatedLoanCount,lateLoanCount,longDelayCount,color);
}

@override
String toString() {
    return 'BorrowerReliability(evaluatedLoanCount: $evaluatedLoanCount, lateLoanCount: $lateLoanCount, longDelayCount: $longDelayCount, color: $color)';
}


}

/// @nodoc
abstract mixin class _$BorrowerReliabilityCopyWith<$Res> implements $BorrowerReliabilityCopyWith<$Res> {
  factory _$BorrowerReliabilityCopyWith(_BorrowerReliability value, $Res Function(_BorrowerReliability) _then) = __$BorrowerReliabilityCopyWithImpl;
@override @useResult
$Res call({
 int evaluatedLoanCount, int lateLoanCount, int longDelayCount, ReliabilityColor color
});




}
/// @nodoc
class __$BorrowerReliabilityCopyWithImpl<$Res>
    implements _$BorrowerReliabilityCopyWith<$Res> {
  __$BorrowerReliabilityCopyWithImpl(this._self, this._then);

  final _BorrowerReliability _self;
  final $Res Function(_BorrowerReliability) _then;

/// Create a copy of BorrowerReliability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? evaluatedLoanCount = null,Object? lateLoanCount = null,Object? longDelayCount = null,Object? color = null,}) {
  return _then(_BorrowerReliability(
evaluatedLoanCount: null == evaluatedLoanCount ? _self.evaluatedLoanCount : evaluatedLoanCount // ignore: cast_nullable_to_non_nullable
as int,lateLoanCount: null == lateLoanCount ? _self.lateLoanCount : lateLoanCount // ignore: cast_nullable_to_non_nullable
as int,longDelayCount: null == longDelayCount ? _self.longDelayCount : longDelayCount // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as ReliabilityColor,
  ));
}


}

// dart format on
