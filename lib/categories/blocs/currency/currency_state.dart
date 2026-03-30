import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tejamkor/categories/data/models/currency_model.dart';

part 'currency_state.freezed.dart';

enum CurrencyStatus { idle, loading, success, error }

@freezed
abstract class CurrencyState with _$CurrencyState {
  const factory CurrencyState({
    required CurrencyStatus status,
    UserCurrencyResponse? response,
    String? errorMessage,
  }) = _CurrencyState;

  factory CurrencyState.initial() {
    return const CurrencyState(
      status: CurrencyStatus.idle,
      response: null,
      errorMessage: null,
    );
  }
}
