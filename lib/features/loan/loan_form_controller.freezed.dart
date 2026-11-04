// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoanFormState {

 Currency get currency;/// Today, captured when the form opens (RG-11).
 LocalDay get today; LocalDay get loanDate; LocalDay? get promisedReturnDate; String get amountInput; String get note;/// The amount was edited: its error can be shown.
 bool get isAmountDirty; bool get isSaving;/// The last save failed for an unexpected reason.
 bool get hasSaveFailed;
/// Create a copy of LoanFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanFormStateCopyWith<LoanFormState> get copyWith => _$LoanFormStateCopyWithImpl<LoanFormState>(this as LoanFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LoanFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanFormState&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.loanDate, _this.loanDate) || other.loanDate == _this.loanDate)&&(identical(other.promisedReturnDate, _this.promisedReturnDate) || other.promisedReturnDate == _this.promisedReturnDate)&&(identical(other.amountInput, _this.amountInput) || other.amountInput == _this.amountInput)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.isAmountDirty, _this.isAmountDirty) || other.isAmountDirty == _this.isAmountDirty)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.hasSaveFailed, _this.hasSaveFailed) || other.hasSaveFailed == _this.hasSaveFailed));
}


@override
int get hashCode {
  final _this = this as LoanFormState;
  return Object.hash(runtimeType,_this.currency,_this.today,_this.loanDate,_this.promisedReturnDate,_this.amountInput,_this.note,_this.isAmountDirty,_this.isSaving,_this.hasSaveFailed);
}

@override
String toString() {
  final _this = this as LoanFormState;
  return 'LoanFormState(currency: ${_this.currency}, today: ${_this.today}, loanDate: ${_this.loanDate}, promisedReturnDate: ${_this.promisedReturnDate}, amountInput: ${_this.amountInput}, note: ${_this.note}, isAmountDirty: ${_this.isAmountDirty}, isSaving: ${_this.isSaving}, hasSaveFailed: ${_this.hasSaveFailed})';
}


}

/// @nodoc
abstract mixin class $LoanFormStateCopyWith<$Res>  {
  factory $LoanFormStateCopyWith(LoanFormState value, $Res Function(LoanFormState) _then) = _$LoanFormStateCopyWithImpl;
@useResult
$Res call({
 Currency currency, LocalDay today, LocalDay loanDate, LocalDay? promisedReturnDate, String amountInput, String note, bool isAmountDirty, bool isSaving, bool hasSaveFailed
});




}
/// @nodoc
class _$LoanFormStateCopyWithImpl<$Res>
    implements $LoanFormStateCopyWith<$Res> {
  _$LoanFormStateCopyWithImpl(this._self, this._then);

  final LoanFormState _self;
  final $Res Function(LoanFormState) _then;

/// Create a copy of LoanFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? today = null,Object? loanDate = null,Object? promisedReturnDate = freezed,Object? amountInput = null,Object? note = null,Object? isAmountDirty = null,Object? isSaving = null,Object? hasSaveFailed = null,}) {
  return _then(LoanFormState(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as LocalDay,loanDate: null == loanDate ? _self.loanDate : loanDate // ignore: cast_nullable_to_non_nullable
as LocalDay,promisedReturnDate: freezed == promisedReturnDate ? _self.promisedReturnDate : promisedReturnDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,amountInput: null == amountInput ? _self.amountInput : amountInput // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,isAmountDirty: null == isAmountDirty ? _self.isAmountDirty : isAmountDirty // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,hasSaveFailed: null == hasSaveFailed ? _self.hasSaveFailed : hasSaveFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanFormState].
extension LoanFormStatePatterns on LoanFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanFormState value)  $default,){
final _that = this;
switch (_that) {
case _LoanFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanFormState value)?  $default,){
final _that = this;
switch (_that) {
case _LoanFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Currency currency,  LocalDay today,  LocalDay loanDate,  LocalDay? promisedReturnDate,  String amountInput,  String note,  bool isAmountDirty,  bool isSaving,  bool hasSaveFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanFormState() when $default != null:
return $default(_that.currency,_that.today,_that.loanDate,_that.promisedReturnDate,_that.amountInput,_that.note,_that.isAmountDirty,_that.isSaving,_that.hasSaveFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Currency currency,  LocalDay today,  LocalDay loanDate,  LocalDay? promisedReturnDate,  String amountInput,  String note,  bool isAmountDirty,  bool isSaving,  bool hasSaveFailed)  $default,) {final _that = this;
switch (_that) {
case _LoanFormState():
return $default(_that.currency,_that.today,_that.loanDate,_that.promisedReturnDate,_that.amountInput,_that.note,_that.isAmountDirty,_that.isSaving,_that.hasSaveFailed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Currency currency,  LocalDay today,  LocalDay loanDate,  LocalDay? promisedReturnDate,  String amountInput,  String note,  bool isAmountDirty,  bool isSaving,  bool hasSaveFailed)?  $default,) {final _that = this;
switch (_that) {
case _LoanFormState() when $default != null:
return $default(_that.currency,_that.today,_that.loanDate,_that.promisedReturnDate,_that.amountInput,_that.note,_that.isAmountDirty,_that.isSaving,_that.hasSaveFailed);case _:
  return null;

}
}

}

/// @nodoc


class _LoanFormState extends LoanFormState {
  const _LoanFormState({required this.currency, required this.today, required this.loanDate, this.promisedReturnDate, this.amountInput = '', this.note = '', this.isAmountDirty = false, this.isSaving = false, this.hasSaveFailed = false}): super._();


@override final  Currency currency;
/// Today, captured when the form opens (RG-11).
@override final  LocalDay today;
@override final  LocalDay loanDate;
@override final  LocalDay? promisedReturnDate;
@override@JsonKey() final  String amountInput;
@override@JsonKey() final  String note;
/// The amount was edited: its error can be shown.
@override@JsonKey() final  bool isAmountDirty;
@override@JsonKey() final  bool isSaving;
/// The last save failed for an unexpected reason.
@override@JsonKey() final  bool hasSaveFailed;

/// Create a copy of LoanFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanFormStateCopyWith<_LoanFormState> get copyWith => __$LoanFormStateCopyWithImpl<_LoanFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanFormState&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.today, today) || other.today == today)&&(identical(other.loanDate, loanDate) || other.loanDate == loanDate)&&(identical(other.promisedReturnDate, promisedReturnDate) || other.promisedReturnDate == promisedReturnDate)&&(identical(other.amountInput, amountInput) || other.amountInput == amountInput)&&(identical(other.note, note) || other.note == note)&&(identical(other.isAmountDirty, isAmountDirty) || other.isAmountDirty == isAmountDirty)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.hasSaveFailed, hasSaveFailed) || other.hasSaveFailed == hasSaveFailed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currency,today,loanDate,promisedReturnDate,amountInput,note,isAmountDirty,isSaving,hasSaveFailed);
}

@override
String toString() {
    return 'LoanFormState(currency: $currency, today: $today, loanDate: $loanDate, promisedReturnDate: $promisedReturnDate, amountInput: $amountInput, note: $note, isAmountDirty: $isAmountDirty, isSaving: $isSaving, hasSaveFailed: $hasSaveFailed)';
}


}

/// @nodoc
abstract mixin class _$LoanFormStateCopyWith<$Res> implements $LoanFormStateCopyWith<$Res> {
  factory _$LoanFormStateCopyWith(_LoanFormState value, $Res Function(_LoanFormState) _then) = __$LoanFormStateCopyWithImpl;
@override @useResult
$Res call({
 Currency currency, LocalDay today, LocalDay loanDate, LocalDay? promisedReturnDate, String amountInput, String note, bool isAmountDirty, bool isSaving, bool hasSaveFailed
});




}
/// @nodoc
class __$LoanFormStateCopyWithImpl<$Res>
    implements _$LoanFormStateCopyWith<$Res> {
  __$LoanFormStateCopyWithImpl(this._self, this._then);

  final _LoanFormState _self;
  final $Res Function(_LoanFormState) _then;

/// Create a copy of LoanFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? today = null,Object? loanDate = null,Object? promisedReturnDate = freezed,Object? amountInput = null,Object? note = null,Object? isAmountDirty = null,Object? isSaving = null,Object? hasSaveFailed = null,}) {
  return _then(_LoanFormState(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as LocalDay,loanDate: null == loanDate ? _self.loanDate : loanDate // ignore: cast_nullable_to_non_nullable
as LocalDay,promisedReturnDate: freezed == promisedReturnDate ? _self.promisedReturnDate : promisedReturnDate // ignore: cast_nullable_to_non_nullable
as LocalDay?,amountInput: null == amountInput ? _self.amountInput : amountInput // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,isAmountDirty: null == isAmountDirty ? _self.isAmountDirty : isAmountDirty // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,hasSaveFailed: null == hasSaveFailed ? _self.hasSaveFailed : hasSaveFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
