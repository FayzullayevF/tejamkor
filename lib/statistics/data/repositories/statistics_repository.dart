import '../models/statistics_model.dart';
import '../sources/statistics_api_source.dart';

class StatisticsRepository {
  final StatisticsApiSource _apiSource;

  StatisticsRepository(this._apiSource);

  Future<StatisticsModel> getStatistics({String? filterType}) {
    return _apiSource.getStatistics(filterType: filterType);
  }
}
