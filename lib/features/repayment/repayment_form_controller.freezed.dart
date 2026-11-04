// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repayment_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RepaymentFormState {

 Currency get currency;/// Today, captured when the sheet opens (RG-17).
 LocalDay get today;/// Date of the repaid loan: lower bound of the repayment date (RG-17).
 LocalDay get loanDate;/// Upper bound of the amount (RG-16): the remaining amount due of the
/// loan, plus the initial amount of the edited repayment.
 Money get maxAmount; LocalDay get repaymentDate; String get amountInput; String get note;/// The sheet edits an existing repayment.
 bool get isEditing;/// The amount was edited: its error can be shown.
 bool get isAmountDirty; bool get isSaving;/// The last save failed for an unexpected reason.
 bool get hasSaveFailed;
/// Create a copy of RepaymentFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RepaymentFormStateCopyWith<RepaymentFormState> get copyWith => _$RepaymentFormStateCopyWithImpl<RepaymentFormState>(this as RepaymentFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RepaymentFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RepaymentFormState&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.loanDate, _this.loanDate) || other.loanDate == _this.loanDate)&&(identical(other.maxAmount, _this.maxAmount) || other.maxAmount == _this.maxAmount)&&(identical(other.repaymentDate, _this.repaymentDate) || other.repaymentDate == _this.repaymentDate)&&(identical(other.amountInput, _this.amountInput) || other.amountInput == _this.amountInput)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.isEditing, _this.isEditing) || other.isEditing == _this.isEditing)&&(identical(other.isAmountDirty, _this.isAmountDirty) || other.isAmountDirty == _this.isAmountDirty)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.hasSaveFailed, _this.hasSaveFailed) || other.hasSaveFailed == _this.hasSaveFailed));
}


@override
int get hashCode {
  final _this = this as RepaymentFormState;
  return Object.hash(runtimeType,_this.currency,_this.today,_this.loanDate,_this.maxAmount,_this.repaymentDate,_this.amountInput,_this.note,_this.isEditing,_this.isAmountDirty,_this.isSaving,_this.hasSaveFailed);
}

@override
String toString() {
  final _this = this as RepaymentFormState;
  return 'RepaymentFormState(currency: ${_this.currency}, today: ${_this.today}, loanDate: ${_this.loanDate}, maxAmount: ${_this.maxAmount}, repaymentDate: ${_this.repaymentDate}, amountInput: ${_this.amountInput}, note: ${_this.note}, isEditing: ${_this.isEditing}, isAmountDirty: ${_this.isAmountDirty}, isSaving: ${_this.isSaving}, hasSaveFailed: ${_this.hasSaveFailed})';
}


}

/// @nodoc
abstract mixin class $RepaymentFormStateCopyWith<$Res>  {
  factory $RepaymentFormStateCopyWith(RepaymentFormState value, $Res Function(RepaymentFormState) _then) = _$RepaymentFormStateCopyWithImpl;
@useResult
$Res call({
 Currency currency, LocalDay today, LocalDay loanDate, Money maxAmount, LocalDay repaymentDate, String amountInput, String note, bool isEditing, bool isAmountDirty, bool isSaving, bool hasSaveFailed
});




}
/// @nodoc
class _$RepaymentFormStateCopyWithImpl<$Res>
    implements $RepaymentFormStateCopyWith<$Res> {
  _$RepaymentFormStateCopyWithImpl(this._self, this._then);

  final RepaymentFormState _self;
  final $Res Function(RepaymentFormState) _then;

/// Create a copy of RepaymentFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? today = null,Object? loanDate = null,Object? maxAmount = null,Object? repaymentDate = null,Object? amountInput = null,Object? note = null,Object? isEditing = null,Object? isAmountDirty = null,Object? isSaving = null,Object? hasSaveFailed = null,}) {
  return _then(RepaymentFormState(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as LocalDay,loanDate: null == loanDate ? _self.loanDate : loanDate // ignore: cast_nullable_to_non_nullable
as LocalDay,maxAmount: null == maxAmount ? _self.maxAmount : maxAmount // ignore: cast_nullable_to_non_nullable
as Money,repaymentDate: null == repaymentDate ? _self.repaymentDate : repaymentDate // ignore: cast_nullable_to_non_nullable
as LocalDay,amountInput: null == amountInput ? _self.amountInput : amountInput // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,isAmountDirty: null == isAmountDirty ? _self.isAmountDirty : isAmountDirty // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,hasSaveFailed: null == hasSaveFailed ? _self.hasSaveFailed : hasSaveFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RepaymentFormState].
extension RepaymentFormStatePatterns on RepaymentFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RepaymentFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RepaymentFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RepaymentFormState value)  $default,){
final _that = this;
switch (_that) {
case _RepaymentFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RepaymentFormState value)?  $default,){
final _that = this;
switch (_that) {
case _RepaymentFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Currency currency,  LocalDay today,  LocalDay loanDate,  Money maxAmount,  LocalDay repaymentDate,  String amountInput,  String note,  bool isEditing,  bool isAmountDirty,  bool isSaving,  bool hasSaveFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RepaymentFormState() when $default != null:
return $default(_that.currency,_that.today,_that.loanDate,_that.maxAmount,_that.repaymentDate,_that.amountInput,_that.note,_that.isEditing,_that.isAmountDirty,_that.isSaving,_that.hasSaveFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Currency currency,  LocalDay today,  LocalDay loanDate,  Money maxAmount,  LocalDay repaymentDate,  String amountInput,  String note,  bool isEditing,  bool isAmountDirty,  bool isSaving,  bool hasSaveFailed)  $default,) {final _that = this;
switch (_that) {
case _RepaymentFormState():
return $default(_that.currency,_that.today,_that.loanDate,_that.maxAmount,_that.repaymentDate,_that.amountInput,_that.note,_that.isEditing,_that.isAmountDirty,_that.isSaving,_that.hasSaveFailed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Currency currency,  LocalDay today,  LocalDay loanDate,  Money maxAmount,  LocalDay repaymentDate,  String amountInput,  String note,  bool isEditing,  bool isAmountDirty,  bool isSaving,  bool hasSaveFailed)?  $default,) {final _that = this;
switch (_that) {
case _RepaymentFormState() when $default != null:
return $default(_that.currency,_that.today,_that.loanDate,_that.maxAmount,_that.repaymentDate,_that.amountInput,_that.note,_that.isEditing,_that.isAmountDirty,_that.isSaving,_that.hasSaveFailed);case _:
  return null;

}
}

}

/// @nodoc


class _RepaymentFormState extends RepaymentFormState {
  const _RepaymentFormState({required this.currency, required this.today, required this.loanDate, required this.maxAmount, required this.repaymentDate, this.amountInput = '', this.note = '', this.isEditing = false, this.isAmountDirty = false, this.isSaving = false, this.hasSaveFailed = false}): super._();


@override final  Currency currency;
/// Today, captured when the sheet opens (RG-17).
@override final  LocalDay today;
/// Date of the repaid loan: lower bound of the repayment date (RG-17).
@override final  LocalDay loanDate;
/// Upper bound of the amount (RG-16): the remaining amount due of the
/// loan, plus the initial amount of the edited repayment.
@override final  Money maxAmount;
@override final  LocalDay repaymentDate;
@override@JsonKey() final  String amountInput;
@override@JsonKey() final  String note;
/// The sheet edits an existing repayment.
@override@JsonKey() final  bool isEditing;
/// The amount was edited: its error can be shown.
@override@JsonKey() final  bool isAmountDirty;
@override@JsonKey() final  bool isSaving;
/// The last save failed for an unexpected reason.
@override@JsonKey() final  bool hasSaveFailed;

/// Create a copy of RepaymentFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RepaymentFormStateCopyWith<_RepaymentFormState> get copyWith => __$RepaymentFormStateCopyWithImpl<_RepaymentFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RepaymentFormState&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.today, today) || other.today == today)&&(identical(other.loanDate, loanDate) || other.loanDate == loanDate)&&(identical(other.maxAmount, maxAmount) || other.maxAmount == maxAmount)&&(identical(other.repaymentDate, repaymentDate) || other.repaymentDate == repaymentDate)&&(identical(other.amountInput, amountInput) || other.amountInput == amountInput)&&(identical(other.note, note) || other.note == note)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing)&&(identical(other.isAmountDirty, isAmountDirty) || other.isAmountDirty == isAmountDirty)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.hasSaveFailed, hasSaveFailed) || other.hasSaveFailed == hasSaveFailed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currency,today,loanDate,maxAmount,repaymentDate,amountInput,note,isEditing,isAmountDirty,isSaving,hasSaveFailed);
}

@override
String toString() {
    return 'RepaymentFormState(currency: $currency, today: $today, loanDate: $loanDate, maxAmount: $maxAmount, repaymentDate: $repaymentDate, amountInput: $amountInput, note: $note, isEditing: $isEditing, isAmountDirty: $isAmountDirty, isSaving: $isSaving, hasSaveFailed: $hasSaveFailed)';
}


}

/// @nodoc
abstract mixin class _$RepaymentFormStateCopyWith<$Res> implements $RepaymentFormStateCopyWith<$Res> {
  factory _$RepaymentFormStateCopyWith(_RepaymentFormState value, $Res Function(_RepaymentFormState) _then) = __$RepaymentFormStateCopyWithImpl;
@override @useResult
$Res call({
 Currency currency, LocalDay today, LocalDay loanDate, Money maxAmount, LocalDay repaymentDate, String amountInput, String note, bool isEditing, bool isAmountDirty, bool isSaving, bool hasSaveFailed
});




}
/// @nodoc
class __$RepaymentFormStateCopyWithImpl<$Res>
    implements _$RepaymentFormStateCopyWith<$Res> {
  __$RepaymentFormStateCopyWithImpl(this._self, this._then);

  final _RepaymentFormState _self;
  final $Res Function(_RepaymentFormState) _then;

/// Create a copy of RepaymentFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? today = null,Object? loanDate = null,Object? maxAmount = null,Object? repaymentDate = null,Object? amountInput = null,Object? note = null,Object? isEditing = null,Object? isAmountDirty = null,Object? isSaving = null,Object? hasSaveFailed = null,}) {
  return _then(_RepaymentFormState(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as LocalDay,loanDate: null == loanDate ? _self.loanDate : loanDate // ignore: cast_nullable_to_non_nullable
as LocalDay,maxAmount: null == maxAmount ? _self.maxAmount : maxAmount // ignore: cast_nullable_to_non_nullable
as Money,repaymentDate: null == repaymentDate ? _self.repaymentDate : repaymentDate // ignore: cast_nullable_to_non_nullable
as LocalDay,amountInput: null == amountInput ? _self.amountInput : amountInput // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,isAmountDirty: null == isAmountDirty ? _self.isAmountDirty : isAmountDirty // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,hasSaveFailed: null == hasSaveFailed ? _self.hasSaveFailed : hasSaveFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
