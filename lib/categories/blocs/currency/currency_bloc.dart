import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/categories/data/repositories/currency_repository.dart';
import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository _repo;

  CurrencyBloc({required CurrencyRepository repo})
      : _repo = repo,
        super(CurrencyState.initial()) {
    on<CurrencyFetched>(_onFetched);
    on<CurrencySelected>(_onSelected);
    on<CurrencyUpdated>(_onUpdated);
  }

  Future<void> _onFetched(
      CurrencyFetched event, Emitter<CurrencyState> emit) async {
    emit(state.copyWith(status: CurrencyStatus.loading, errorMessage: null));
    try {
      final response = await _repo.getUserCurrency();
      emit(state.copyWith(
        status: CurrencyStatus.success,
        response: response,
        selectedCurrencyId: response.currency,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CurrencyStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSelected(CurrencySelected event, Emitter<CurrencyState> emit) {
    emit(state.copyWith(selectedCurrencyId: event.currencyId));
  }

  Future<void> _onUpdated(
      CurrencyUpdated event, Emitter<CurrencyState> emit) async {
    emit(state.copyWith(status: CurrencyStatus.loading, errorMessage: null));
    try {
      final response = await _repo.updateUserCurrency(event.currencyId);
      emit(state.copyWith(
        status: CurrencyStatus.success,
        response: response,
        selectedCurrencyId: response.currency,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CurrencyStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
