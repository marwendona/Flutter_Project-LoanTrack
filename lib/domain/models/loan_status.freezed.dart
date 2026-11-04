// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoanStatus {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LoanStatus()';
}


}

/// @nodoc
class $LoanStatusCopyWith<$Res>  {
$LoanStatusCopyWith(LoanStatus _, $Res Function(LoanStatus) __);
}


/// Adds pattern-matching-related methods to [LoanStatus].
extension LoanStatusPatterns on LoanStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoanOngoing value)?  ongoing,TResult Function( LoanPartiallyRepaid value)?  partiallyRepaid,TResult Function( LoanRepaid value)?  repaid,TResult Function( LoanOverdue value)?  overdue,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoanOngoing() when ongoing != null:
return ongoing(_that);case LoanPartiallyRepaid() when partiallyRepaid != null:
return partiallyRepaid(_that);case LoanRepaid() when repaid != null:
return repaid(_that);case LoanOverdue() when overdue != null:
return overdue(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoanOngoing value)  ongoing,required TResult Function( LoanPartiallyRepaid value)  partiallyRepaid,required TResult Function( LoanRepaid value)  repaid,required TResult Function( LoanOverdue value)  overdue,}){
final _that = this;
switch (_that) {
case LoanOngoing():
return ongoing(_that);case LoanPartiallyRepaid():
return partiallyRepaid(_that);case LoanRepaid():
return repaid(_that);case LoanOverdue():
return overdue(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoanOngoing value)?  ongoing,TResult? Function( LoanPartiallyRepaid value)?  partiallyRepaid,TResult? Function( LoanRepaid value)?  repaid,TResult? Function( LoanOverdue value)?  overdue,}){
final _that = this;
switch (_that) {
case LoanOngoing() when ongoing != null:
return ongoing(_that);case LoanPartiallyRepaid() when partiallyRepaid != null:
return partiallyRepaid(_that);case LoanRepaid() when repaid != null:
return repaid(_that);case LoanOverdue() when overdue != null:
return overdue(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  ongoing,TResult Function()?  partiallyRepaid,TResult Function( LocalDay? repaidOn)?  repaid,TResult Function( int days)?  overdue,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoanOngoing() when ongoing != null:
return ongoing();case LoanPartiallyRepaid() when partiallyRepaid != null:
return partiallyRepaid();case LoanRepaid() when repaid != null:
return repaid(_that.repaidOn);case LoanOverdue() when overdue != null:
return overdue(_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  ongoing,required TResult Function()  partiallyRepaid,required TResult Function( LocalDay? repaidOn)  repaid,required TResult Function( int days)  overdue,}) {final _that = this;
switch (_that) {
case LoanOngoing():
return ongoing();case LoanPartiallyRepaid():
return partiallyRepaid();case LoanRepaid():
return repaid(_that.repaidOn);case LoanOverdue():
return overdue(_that.days);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  ongoing,TResult? Function()?  partiallyRepaid,TResult? Function( LocalDay? repaidOn)?  repaid,TResult? Function( int days)?  overdue,}) {final _that = this;
switch (_that) {
case LoanOngoing() when ongoing != null:
return ongoing();case LoanPartiallyRepaid() when partiallyRepaid != null:
return partiallyRepaid();case LoanRepaid() when repaid != null:
return repaid(_that.repaidOn);case LoanOverdue() when overdue != null:
return overdue(_that.days);case _:
  return null;

}
}

}

/// @nodoc


class LoanOngoing implements LoanStatus {
  const LoanOngoing();







@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanOngoing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LoanStatus.ongoing()';
}


}




/// @nodoc


class LoanPartiallyRepaid implements LoanStatus {
  const LoanPartiallyRepaid();







@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanPartiallyRepaid);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LoanStatus.partiallyRepaid()';
}


}




/// @nodoc


class LoanRepaid implements LoanStatus {
  const LoanRepaid({this.repaidOn});


 final  LocalDay? repaidOn;

/// Create a copy of LoanStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanRepaidCopyWith<LoanRepaid> get copyWith => _$LoanRepaidCopyWithImpl<LoanRepaid>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanRepaid&&(identical(other.repaidOn, repaidOn) || other.repaidOn == repaidOn));
}


@override
int get hashCode {
    return Object.hash(runtimeType,repaidOn);
}

@override
String toString() {
    return 'LoanStatus.repaid(repaidOn: $repaidOn)';
}


}

/// @nodoc
abstract mixin class $LoanRepaidCopyWith<$Res> implements $LoanStatusCopyWith<$Res> {
  factory $LoanRepaidCopyWith(LoanRepaid value, $Res Function(LoanRepaid) _then) = _$LoanRepaidCopyWithImpl;
@useResult
$Res call({
 LocalDay? repaidOn
});




}
/// @nodoc
class _$LoanRepaidCopyWithImpl<$Res>
    implements $LoanRepaidCopyWith<$Res> {
  _$LoanRepaidCopyWithImpl(this._self, this._then);

  final LoanRepaid _self;
  final $Res Function(LoanRepaid) _then;

/// Create a copy of LoanStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? repaidOn = freezed,}) {
  return _then(LoanRepaid(
repaidOn: freezed == repaidOn ? _self.repaidOn : repaidOn // ignore: cast_nullable_to_non_nullable
as LocalDay?,
  ));
}


}

/// @nodoc


class LoanOverdue implements LoanStatus {
  const LoanOverdue({required this.days});


 final  int days;

/// Create a copy of LoanStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanOverdueCopyWith<LoanOverdue> get copyWith => _$LoanOverdueCopyWithImpl<LoanOverdue>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanOverdue&&(identical(other.days, days) || other.days == days));
}


@override
int get hashCode {
    return Object.hash(runtimeType,days);
}

@override
String toString() {
    return 'LoanStatus.overdue(days: $days)';
}


}

/// @nodoc
abstract mixin class $LoanOverdueCopyWith<$Res> implements $LoanStatusCopyWith<$Res> {
  factory $LoanOverdueCopyWith(LoanOverdue value, $Res Function(LoanOverdue) _then) = _$LoanOverdueCopyWithImpl;
@useResult
$Res call({
 int days
});




}
/// @nodoc
class _$LoanOverdueCopyWithImpl<$Res>
    implements $LoanOverdueCopyWith<$Res> {
  _$LoanOverdueCopyWithImpl(this._self, this._then);

  final LoanOverdue _self;
  final $Res Function(LoanOverdue) _then;

/// Create a copy of LoanStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? days = null,}) {
  return _then(LoanOverdue(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
