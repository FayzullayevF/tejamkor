import 'package:tejamkor/categories/data/models/currency_model.dart';
import 'package:tejamkor/core/data/models/accounts/account_model.dart';

class TejamkorScore {
  final int score;
  final String status;
  final String message;

  TejamkorScore({
    required this.score,
    required this.status,
    required this.message,
  });

  factory TejamkorScore.fromJson(Map<String, dynamic> json) {
    return TejamkorScore(
      score: (json['score'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }
}

class DashboardModel {
  final String greeting;
  final double overallBalance;
  final TejamkorScore tejamkorScore;
  final double totalIncome;
  final double totalExpense;
  final String status;
  final List<AccountModel> accounts;
  final Map<String, dynamic> monthlyCategories;
  final Map<String, dynamic> dailyBudget;
  final Map<String, dynamic> moneyRunway;
  final String currencySymbol;
  final String currencyCode;
  final List<CurrencyModel> currencyRates;

  DashboardModel({
    required this.greeting,
    required this.overallBalance,
    required this.tejamkorScore,
    required this.totalIncome,
    required this.totalExpense,
    required this.status,
    required this.accounts,
    required this.monthlyCategories,
    required this.dailyBudget,
    required this.moneyRunway,
    required this.currencySymbol,
    required this.currencyCode,
    required this.currencyRates,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      greeting: json['greeting'] as String? ?? '',
      overallBalance: (json['overall_balance'] as num?)?.toDouble() ?? 0.0,
      tejamkorScore: json['tejamkor_score'] != null
          ? TejamkorScore.fromJson(json['tejamkor_score'] as Map<String, dynamic>)
          : TejamkorScore(score: 0, status: '', message: ''),
      totalIncome: (json['total_income'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (json['total_expense'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
      accounts: (json['accounts'] as List?)
              ?.map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      monthlyCategories: json['monthly_categories'] as Map<String, dynamic>? ?? {},
      dailyBudget: json['daily_budget'] as Map<String, dynamic>? ?? {},
      moneyRunway: json['money_runway'] as Map<String, dynamic>? ?? {},
      currencySymbol: json['currency_symbol'] as String? ?? "so'm",
      currencyCode: (json['currency_code'] ?? json['currency']) as String? ?? "UZS",
      currencyRates: (json['currency_rates'] as List? ?? 
                      json['currencies'] as List? ?? 
                      json['rates'] as List? ?? 
                      json['exchange_rates'] as List?)
              ?.map((e) => CurrencyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
