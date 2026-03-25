import 'package:freezed_annotation/freezed_annotation.dart';
part 'sign_up_state.freezed.dart';

enum SignUpStatus {idle,loading,success,error}
@freezed
abstract class SignUpState with _$SignUpState{
const factory SignUpState({required SignUpStatus? status, String? errorMessage}) = _SignUpState;
factory SignUpState.initial(){
  return SignUpState(status: SignUpStatus.idle,errorMessage: null);
}
}