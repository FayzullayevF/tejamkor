abstract class StatisticsEvent {}

class LoadStatistics extends StatisticsEvent {
  final String? filterType;
  LoadStatistics({this.filterType});
}
