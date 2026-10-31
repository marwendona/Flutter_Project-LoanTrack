// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repayment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Repayment {

 int get id; int get loanId; Money get amount; LocalDay get repaymentDate; String? get note;
/// Create a copy of Repayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RepaymentCopyWith<Repayment> get copyWith => _$RepaymentCopyWithImpl<Repayment>(this as Repayment, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Repayment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Repayment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.loanId, _this.loanId) || other.loanId == _this.loanId)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.repaymentDate, _this.repaymentDate) || other.repaymentDate == _this.repaymentDate)&&(identical(other.note, _this.note) || other.note == _this.note));
}


@override
int get hashCode {
  final _this = this as Repayment;
  return Object.hash(runtimeType,_this.id,_this.loanId,_this.amount,_this.repaymentDate,_this.note);
}

@override
String toString() {
  final _this = this as Repayment;
  return 'Repayment(id: ${_this.id}, loanId: ${_this.loanId}, amount: ${_this.amount}, repaymentDate: ${_this.repaymentDate}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $RepaymentCopyWith<$Res>  {
  factory $RepaymentCopyWith(Repayment value, $Res Function(Repayment) _then) = _$RepaymentCopyWithImpl;
@useResult
$Res call({
 int id, int loanId, Money amount, LocalDay repaymentDate, String? note
});




}
/// @nodoc
class _$RepaymentCopyWithImpl<$Res>
    implements $RepaymentCopyWith<$Res> {
  _$RepaymentCopyWithImpl(this._self, this._then);

  final Repayment _self;
  final $Res Function(Repayment) _then;

/// Create a copy of Repayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? loanId = null,Object? amount = null,Object? repaymentDate = null,Object? note = freezed,}) {
  return _then(Repayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,repaymentDate: null == repaymentDate ? _self.repaymentDate : repaymentDate // ignore: cast_nullable_to_non_nullable
as LocalDay,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Repayment].
extension RepaymentPatterns on Repayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Repayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Repayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Repayment value)  $default,){
final _that = this;
switch (_that) {
case _Repayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Repayment value)?  $default,){
final _that = this;
switch (_that) {
case _Repayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int loanId,  Money amount,  LocalDay repaymentDate,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Repayment() when $default != null:
return $default(_that.id,_that.loanId,_that.amount,_that.repaymentDate,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int loanId,  Money amount,  LocalDay repaymentDate,  String? note)  $default,) {final _that = this;
switch (_that) {
case _Repayment():
return $default(_that.id,_that.loanId,_that.amount,_that.repaymentDate,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int loanId,  Money amount,  LocalDay repaymentDate,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _Repayment() when $default != null:
return $default(_that.id,_that.loanId,_that.amount,_that.repaymentDate,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _Repayment implements Repayment {
  const _Repayment({required this.id, required this.loanId, required this.amount, required this.repaymentDate, this.note});
  

@override final  int id;
@override final  int loanId;
@override final  Money amount;
@override final  LocalDay repaymentDate;
@override final  String? note;

/// Create a copy of Repayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RepaymentCopyWith<_Repayment> get copyWith => __$RepaymentCopyWithImpl<_Repayment>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Repayment&&(identical(other.id, id) || other.id == id)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.repaymentDate, repaymentDate) || other.repaymentDate == repaymentDate)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,loanId,amount,repaymentDate,note);
}

@override
String toString() {
    return 'Repayment(id: $id, loanId: $loanId, amount: $amount, repaymentDate: $repaymentDate, note: $note)';
}


}

/// @nodoc
abstract mixin class _$RepaymentCopyWith<$Res> implements $RepaymentCopyWith<$Res> {
  factory _$RepaymentCopyWith(_Repayment value, $Res Function(_Repayment) _then) = __$RepaymentCopyWithImpl;
@override @useResult
$Res call({
 int id, int loanId, Money amount, LocalDay repaymentDate, String? note
});




}
/// @nodoc
class __$RepaymentCopyWithImpl<$Res>
    implements _$RepaymentCopyWith<$Res> {
  __$RepaymentCopyWithImpl(this._self, this._then);

  final _Repayment _self;
  final $Res Function(_Repayment) _then;

/// Create a copy of Repayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? loanId = null,Object? amount = null,Object? repaymentDate = null,Object? note = freezed,}) {
  return _then(_Repayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,repaymentDate: null == repaymentDate ? _self.repaymentDate : repaymentDate // ignore: cast_nullable_to_non_nullable
as LocalDay,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
