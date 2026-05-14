import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/categories/data/models/currency_model.dart';
import 'package:tejamkor/home/data/models/dashboard_model.dart';
import 'package:tejamkor/home/data/repos/dashboard_repository.dart';

abstract class DashboardEvent {}

class LoadDashboardEvent extends DashboardEvent {
  final int? month;
  final int? year;
  final String? transactionType;
  final String? currency;

  LoadDashboardEvent({this.month, this.year, this.transactionType, this.currency});
}

class FetchOtherCurrenciesEvent extends DashboardEvent {}

class AddCurrencyToDashboardEvent extends DashboardEvent {
  final CurrencyModel currency;
  AddCurrencyToDashboardEvent(this.currency);
}

class RemoveCurrencyFromDashboardEvent extends DashboardEvent {
  final CurrencyModel currency;
  RemoveCurrencyFromDashboardEvent(this.currency);
}

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardModel dashboard;
  final List<CurrencyModel> dashboardCurrencies;
  final List<CurrencyModel> otherCurrencies;

  DashboardLoaded(
    this.dashboard, {
    this.dashboardCurrencies = const [],
    this.otherCurrencies = const [],
  });
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;

  String? _currentTransactionType;
  int? _currentMonth;
  int? _currentYear;
  String? _currentCurrency;

  DashboardBloc(this.repository) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<FetchOtherCurrenciesEvent>(_onFetchOtherCurrencies);
    on<AddCurrencyToDashboardEvent>(_onAddCurrencyToDashboard);
    on<RemoveCurrencyFromDashboardEvent>(_onRemoveCurrencyFromDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (event.transactionType != null) {
      _currentTransactionType = event.transactionType;
    }
    if (event.month != null) _currentMonth = event.month;
    if (event.year != null) _currentYear = event.year;

    if (event.currency != null) _currentCurrency = event.currency;

    emit(DashboardLoading());
    try {
      final dashboard = await repository.getDashboard(
        month: _currentMonth,
        year: _currentYear,
        transactionType: _currentTransactionType,
        currency: _currentCurrency,
      );
      final dashboardCurrencies = await repository.getDashboardCurrencies();
      
      emit(
        DashboardLoaded(
          dashboard,
          dashboardCurrencies: dashboardCurrencies,
        ),
      );
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onFetchOtherCurrencies(
    FetchOtherCurrenciesEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      try {
        final otherCurrencies = await repository.getOtherCurrencies();
        emit(
          DashboardLoaded(
            currentState.dashboard,
            dashboardCurrencies: currentState.dashboardCurrencies,
            otherCurrencies: otherCurrencies,
          ),
        );
      } catch (e) {
        // Log or handle error
      }
    }
  }

  Future<void> _onAddCurrencyToDashboard(
    AddCurrencyToDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;

      // Real-time update: move from otherCurrencies to dashboardCurrencies
      final updatedDashboardCurrencies =
          List<CurrencyModel>.from(currentState.dashboardCurrencies)
            ..add(event.currency);
      final updatedOtherCurrencies =
          List<CurrencyModel>.from(currentState.otherCurrencies)
            ..removeWhere((c) => c.id == event.currency.id);

      emit(
        DashboardLoaded(
          currentState.dashboard,
          dashboardCurrencies: updatedDashboardCurrencies,
          otherCurrencies: updatedOtherCurrencies,
        ),
      );

      try {
        await repository.addCurrencyToDashboard(event.currency.id);
      } catch (e) {
        // Optional: rollback
      }
    }
  }

  Future<void> _onRemoveCurrencyFromDashboard(
    RemoveCurrencyFromDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;

      // Real-time update: remove from dashboardCurrencies and add back to otherCurrencies
      final updatedDashboardCurrencies =
          List<CurrencyModel>.from(currentState.dashboardCurrencies)
            ..removeWhere((c) => c.id == event.currency.id);

      final updatedOtherCurrencies =
          List<CurrencyModel>.from(currentState.otherCurrencies)
            ..add(event.currency);

      emit(
        DashboardLoaded(
          currentState.dashboard,
          dashboardCurrencies: updatedDashboardCurrencies,
          otherCurrencies: updatedOtherCurrencies,
        ),
      );

      try {
        await repository.removeCurrencyFromDashboard(event.currency.id);
      } catch (e) {
        // Optional: rollback
      }
    }
  }
}
