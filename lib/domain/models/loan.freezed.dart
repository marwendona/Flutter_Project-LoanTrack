// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Loan {

 int get id; int get borrowerId; Money get amount; LocalDay get loanDate; LocalDay? get promisedReturnDate; String? get note;
/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanCopyWith<Loan> get copyWith => _$LoanCopyWithImpl<Loan>(this as Loan, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Loan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loan&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.borrowerId, _this.borrowerId) || other.borrowerId == _this.borrowerId)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.loanDate, _this.loanDate) || other.loanDate == _this.loanDate)&&(identical(other.promisedReturnDate, _this.promisedReturnDate) || other.promisedReturnDate == _this.promisedReturnDate)&&(identical(other.note, _this.note) || other.note == _this.note));
}


@override
int get hashCode {
  final _this = this as Loan;
  return Object.hash(runtimeType,_this.id,_this.borrowerId,_this.amount,_this.loanDate,_this.promisedReturnDate,_this.note);
}

@override
String toString() {
  final _this = this as Loan;
  return 'Loan(id: ${_this.id}, borrowerId: ${_this.borrowerId}, amount: ${_this.amount}, loanDate: ${_this.loanDate}, promisedReturnDate: ${_this.promisedReturnDate}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $LoanCopyWith<$Res>  {
  factory $LoanCopyWith(Loan value, $Res Function(Loan) _then) = _$LoanCopyWithImpl;
@useResult
$Res call({
 int id, int borrowerId, Money amount, LocalDay loanDate, LocalDay? promisedReturnDate, String? note
});




}
/// @nodoc
class _$LoanCopyWithImpl<$Res>
    implements $LoanCopyWith<$Res> {
  _$LoanCopyWithImpl(this._self, this._then);

  final Loan _self;
  final $Res Function(Loan) _then;

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? borrowerId = null,Object? amount = null,Object? loanDate = null,Object? promisedReturnDate = freezed,Object? note = freezed,}) {
  return _then(Loan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,loanDate: null == loanDate ? _self.loanDate : loanDate // ignore: cast_nullable_to_non_nullable
as LocalDay,promisedReturnDate: freezed == promisedReturnDate ? _self.promisedReturnDate : promisedReturnDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Loan].
extension LoanPatterns on Loan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Loan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Loan value)  $default,){
final _that = this;
switch (_that) {
case _Loan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Loan value)?  $default,){
final _that = this;
switch (_that) {
case _Loan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int borrowerId,  Money amount,  LocalDay loanDate,  LocalDay? promisedReturnDate,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that.id,_that.borrowerId,_that.amount,_that.loanDate,_that.promisedReturnDate,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int borrowerId,  Money amount,  LocalDay loanDate,  LocalDay? promisedReturnDate,  String? note)  $default,) {final _that = this;
switch (_that) {
case _Loan():
return $default(_that.id,_that.borrowerId,_that.amount,_that.loanDate,_that.promisedReturnDate,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int borrowerId,  Money amount,  LocalDay loanDate,  LocalDay? promisedReturnDate,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that.id,_that.borrowerId,_that.amount,_that.loanDate,_that.promisedReturnDate,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _Loan implements Loan {
  const _Loan({required this.id, required this.borrowerId, required this.amount, required this.loanDate, this.promisedReturnDate, this.note});
  

@override final  int id;
@override final  int borrowerId;
@override final  Money amount;
@override final  LocalDay loanDate;
@override final  LocalDay? promisedReturnDate;
@override final  String? note;

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanCopyWith<_Loan> get copyWith => __$LoanCopyWithImpl<_Loan>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loan&&(identical(other.id, id) || other.id == id)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.loanDate, loanDate) || other.loanDate == loanDate)&&(identical(other.promisedReturnDate, promisedReturnDate) || other.promisedReturnDate == promisedReturnDate)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,borrowerId,amount,loanDate,promisedReturnDate,note);
}

@override
String toString() {
    return 'Loan(id: $id, borrowerId: $borrowerId, amount: $amount, loanDate: $loanDate, promisedReturnDate: $promisedReturnDate, note: $note)';
}


}

/// @nodoc
abstract mixin class _$LoanCopyWith<$Res> implements $LoanCopyWith<$Res> {
  factory _$LoanCopyWith(_Loan value, $Res Function(_Loan) _then) = __$LoanCopyWithImpl;
@override @useResult
$Res call({
 int id, int borrowerId, Money amount, LocalDay loanDate, LocalDay? promisedReturnDate, String? note
});




}
/// @nodoc
class __$LoanCopyWithImpl<$Res>
    implements _$LoanCopyWith<$Res> {
  __$LoanCopyWithImpl(this._self, this._then);

  final _Loan _self;
  final $Res Function(_Loan) _then;

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? borrowerId = null,Object? amount = null,Object? loanDate = null,Object? promisedReturnDate = freezed,Object? note = freezed,}) {
  return _then(_Loan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,loanDate: null == loanDate ? _self.loanDate : loanDate // ignore: cast_nullable_to_non_nullable
as LocalDay,promisedReturnDate: freezed == promisedReturnDate ? _self.promisedReturnDate : promisedReturnDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
