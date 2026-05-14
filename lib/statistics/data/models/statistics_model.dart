import 'dart:convert';

class StatisticsModel {
  final String filterType;
  final Overall overall;
  final List<CategoryStatistic> categories;
  final DailyAverageData dailyAverage;
  final List<Last7Days> last7Days;
  final String currencySymbol;

  StatisticsModel({
    required this.filterType,
    required this.overall,
    required this.categories,
    required this.dailyAverage,
    required this.last7Days,
    required this.currencySymbol,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      filterType: json['filter_type'] ?? '',
      overall: Overall.fromJson(json['overall'] ?? {}),
      categories: (json['categories'] as List? ?? [])
          .map((i) => CategoryStatistic.fromJson(i))
          .toList(),
      dailyAverage: DailyAverageData.fromJson(json['daily_average'] ?? {}),
      last7Days: (json['last_7_days'] as List? ?? [])
          .map((i) => Last7Days.fromJson(i))
          .toList(),
      currencySymbol: json['currency_symbol'] as String? ?? "so'm",
    );
  }
}

class Overall {
  final double totalAmount;
  final String percentageChange;

  Overall({
    required this.totalAmount,
    required this.percentageChange,
  });

  factory Overall.fromJson(Map<String, dynamic> json) {
    return Overall(
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      percentageChange: json['percentage_change'] ?? '',
    );
  }
}

class CategoryStatistic {
  final int categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final double amount;
  final int transactionCount;
  final double progressPercent;
  final String percentageChange;

  CategoryStatistic({
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.amount,
    required this.transactionCount,
    required this.progressPercent,
    required this.percentageChange,
  });

  factory CategoryStatistic.fromJson(Map<String, dynamic> json) {
    return CategoryStatistic(
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      categoryIcon: json['category_icon'] ?? '',
      categoryColor: json['category_color'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      transactionCount: json['transaction_count'] ?? 0,
      progressPercent: (json['progress_percent'] ?? 0).toDouble(),
      percentageChange: json['percentage_change'] ?? '',
    );
  }
}

class DailyAverageData {
  final double averageAmount;
  final double dailyLimit;

  DailyAverageData({
    required this.averageAmount,
    required this.dailyLimit,
  });

  factory DailyAverageData.fromJson(Map<String, dynamic> json) {
    return DailyAverageData(
      averageAmount: (json['average_amount'] ?? 0).toDouble(),
      dailyLimit: (json['daily_limit'] ?? 0).toDouble(),
    );
  }
}

class Last7Days {
  final String dayName;
  final String date;
  final double amount;

  Last7Days({
    required this.dayName,
    required this.date,
    required this.amount,
  });

  factory Last7Days.fromJson(Map<String, dynamic> json) {
    return Last7Days(
      dayName: json['day_name'] ?? '',
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}
