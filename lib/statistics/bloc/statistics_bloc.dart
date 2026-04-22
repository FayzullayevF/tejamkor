import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/statistics_repository.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final StatisticsRepository _repository;

  StatisticsBloc(this._repository) : super(StatisticsInitial()) {
    on<LoadStatistics>((event, emit) async {
      emit(StatisticsLoading());
      try {
        final statistics = await _repository.getStatistics(filterType: event.filterType);
        emit(StatisticsLoaded(statistics));
      } catch (e) {
        emit(StatisticsError(e.toString()));
      }
    });
  }
}
