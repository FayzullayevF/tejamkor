// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CurrencyState {

 CurrencyStatus get status; UserCurrencyResponse? get response; String? get errorMessage;
/// Create a copy of CurrencyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrencyStateCopyWith<CurrencyState> get copyWith => _$CurrencyStateCopyWithImpl<CurrencyState>(this as CurrencyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrencyState&&(identical(other.status, status) || other.status == status)&&(identical(other.response, response) || other.response == response)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,response,errorMessage);

@override
String toString() {
  return 'CurrencyState(status: $status, response: $response, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $CurrencyStateCopyWith<$Res>  {
  factory $CurrencyStateCopyWith(CurrencyState value, $Res Function(CurrencyState) _then) = _$CurrencyStateCopyWithImpl;
@useResult
$Res call({
 CurrencyStatus status, UserCurrencyResponse? response, String? errorMessage
});




}
/// @nodoc
class _$CurrencyStateCopyWithImpl<$Res>
    implements $CurrencyStateCopyWith<$Res> {
  _$CurrencyStateCopyWithImpl(this._self, this._then);

  final CurrencyState _self;
  final $Res Function(CurrencyState) _then;

/// Create a copy of CurrencyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? response = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CurrencyStatus,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as UserCurrencyResponse?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrencyState].
extension CurrencyStatePatterns on CurrencyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrencyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrencyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrencyState value)  $default,){
final _that = this;
switch (_that) {
case _CurrencyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrencyState value)?  $default,){
final _that = this;
switch (_that) {
case _CurrencyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CurrencyStatus status,  UserCurrencyResponse? response,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrencyState() when $default != null:
return $default(_that.status,_that.response,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CurrencyStatus status,  UserCurrencyResponse? response,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _CurrencyState():
return $default(_that.status,_that.response,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CurrencyStatus status,  UserCurrencyResponse? response,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _CurrencyState() when $default != null:
return $default(_that.status,_that.response,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _CurrencyState implements CurrencyState {
  const _CurrencyState({required this.status, this.response, this.errorMessage});
  

@override final  CurrencyStatus status;
@override final  UserCurrencyResponse? response;
@override final  String? errorMessage;

/// Create a copy of CurrencyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrencyStateCopyWith<_CurrencyState> get copyWith => __$CurrencyStateCopyWithImpl<_CurrencyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrencyState&&(identical(other.status, status) || other.status == status)&&(identical(other.response, response) || other.response == response)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,response,errorMessage);

@override
String toString() {
  return 'CurrencyState(status: $status, response: $response, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$CurrencyStateCopyWith<$Res> implements $CurrencyStateCopyWith<$Res> {
  factory _$CurrencyStateCopyWith(_CurrencyState value, $Res Function(_CurrencyState) _then) = __$CurrencyStateCopyWithImpl;
@override @useResult
$Res call({
 CurrencyStatus status, UserCurrencyResponse? response, String? errorMessage
});




}
/// @nodoc
class __$CurrencyStateCopyWithImpl<$Res>
    implements _$CurrencyStateCopyWith<$Res> {
  __$CurrencyStateCopyWithImpl(this._self, this._then);

  final _CurrencyState _self;
  final $Res Function(_CurrencyState) _then;

/// Create a copy of CurrencyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? response = freezed,Object? errorMessage = freezed,}) {
  return _then(_CurrencyState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CurrencyStatus,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as UserCurrencyResponse?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
