// lib/categories/blocs/currency/currency_state.dart

import 'package:tejamkor/categories/data/models/currency_model.dart';

enum CurrencyStatus { idle, loading, success, error }

class CurrencyState {
  final CurrencyStatus status;
  final UserCurrencyResponse? response;
  final String? errorMessage;
  final int? selectedCurrencyId;

  CurrencyState({
    required this.status,
    this.response,
    this.errorMessage,
    this.selectedCurrencyId,
  });

  factory CurrencyState.initial() {
    return CurrencyState(status: CurrencyStatus.idle);
  }

  CurrencyState copyWith({
    CurrencyStatus? status,
    UserCurrencyResponse? response,
    String? errorMessage,
    int? selectedCurrencyId,
  }) {
    return CurrencyState(
      status: status ?? this.status,
      response: response ?? this.response,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCurrencyId: selectedCurrencyId ?? this.selectedCurrencyId,
    );
  }
}
