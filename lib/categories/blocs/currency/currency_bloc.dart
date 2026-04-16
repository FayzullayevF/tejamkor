import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/categories/data/repositories/currency_repository.dart';
import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository _repository;

  CurrencyBloc(this._repository) : super(CurrencyState.initial()) {
    on<CurrencyFetched>(_onFetched);
    on<CurrencyUpdated>(_onUpdated);
  }

  Future<void> _onFetched(
    CurrencyFetched event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(state.copyWith(status: CurrencyStatus.loading));
    try {
      final response = await _repository.getUserCurrency();
      emit(state.copyWith(
        status: CurrencyStatus.success,
        response: response,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CurrencyStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdated(
    CurrencyUpdated event,
    Emitter<CurrencyState> emit,
  ) async {
    final previousState = state;
    emit(state.copyWith(status: CurrencyStatus.updating));
    try {
      await _repository.updateUserCurrency(event.currencyId);
      emit(state.copyWith(status: CurrencyStatus.updated));
      // Option: refetch the currency logic
      add(CurrencyFetched());
    } catch (e) {
      emit(state.copyWith(
        status: CurrencyStatus.error,
        errorMessage: e.toString(),
      ));
      // After showing error, we can optionally revert to previous state
      emit(previousState);
    }
  }
}
