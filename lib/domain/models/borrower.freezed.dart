// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'borrower.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Borrower {

 int get id; String get name; String? get phone; String? get note; LocalDay get createdAt;
/// Create a copy of Borrower
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BorrowerCopyWith<Borrower> get copyWith => _$BorrowerCopyWithImpl<Borrower>(this as Borrower, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Borrower;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Borrower&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as Borrower;
  return Object.hash(runtimeType,_this.id,_this.name,_this.phone,_this.note,_this.createdAt);
}

@override
String toString() {
  final _this = this as Borrower;
  return 'Borrower(id: ${_this.id}, name: ${_this.name}, phone: ${_this.phone}, note: ${_this.note}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $BorrowerCopyWith<$Res>  {
  factory $BorrowerCopyWith(Borrower value, $Res Function(Borrower) _then) = _$BorrowerCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? phone, String? note, LocalDay createdAt
});




}
/// @nodoc
class _$BorrowerCopyWithImpl<$Res>
    implements $BorrowerCopyWith<$Res> {
  _$BorrowerCopyWithImpl(this._self, this._then);

  final Borrower _self;
  final $Res Function(Borrower) _then;

/// Create a copy of Borrower
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(Borrower(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as LocalDay,
  ));
}

}


/// Adds pattern-matching-related methods to [Borrower].
extension BorrowerPatterns on Borrower {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Borrower value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Borrower() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Borrower value)  $default,){
final _that = this;
switch (_that) {
case _Borrower():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Borrower value)?  $default,){
final _that = this;
switch (_that) {
case _Borrower() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? phone,  String? note,  LocalDay createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Borrower() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? phone,  String? note,  LocalDay createdAt)  $default,) {final _that = this;
switch (_that) {
case _Borrower():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? phone,  String? note,  LocalDay createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Borrower() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _Borrower implements Borrower {
  const _Borrower({required this.id, required this.name, this.phone, this.note, required this.createdAt});
  

@override final  int id;
@override final  String name;
@override final  String? phone;
@override final  String? note;
@override final  LocalDay createdAt;

/// Create a copy of Borrower
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BorrowerCopyWith<_Borrower> get copyWith => __$BorrowerCopyWithImpl<_Borrower>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Borrower&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,phone,note,createdAt);
}

@override
String toString() {
    return 'Borrower(id: $id, name: $name, phone: $phone, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BorrowerCopyWith<$Res> implements $BorrowerCopyWith<$Res> {
  factory _$BorrowerCopyWith(_Borrower value, $Res Function(_Borrower) _then) = __$BorrowerCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? phone, String? note, LocalDay createdAt
});




}
/// @nodoc
class __$BorrowerCopyWithImpl<$Res>
    implements _$BorrowerCopyWith<$Res> {
  __$BorrowerCopyWithImpl(this._self, this._then);

  final _Borrower _self;
  final $Res Function(_Borrower) _then;

/// Create a copy of Borrower
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = freezed,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_Borrower(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as LocalDay,
  ));
}


}

// dart format on
