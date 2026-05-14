// lib/core/data/models/transactions/post_transactions.dart
import 'package:intl/intl.dart';

class TransactionHistoryResponse {
  final TransactionSummary summary;
  final int count;
  final List<TransactionModel> results;

  TransactionHistoryResponse({
    required this.summary,
    required this.count,
    required this.results,
  });

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponse(
      summary: TransactionSummary.fromJson(json['summary'] ?? {}),
      count: json['count'] as int? ?? 0,
      results: (json['results'] as List? ?? [])
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TransactionSummary {
  final String totalIncome;
  final String totalExpense;
  final String incomeChangePercent;
  final String expenseChangePercent;
  final String currencySymbol;

  TransactionSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.incomeChangePercent,
    required this.expenseChangePercent,
    required this.currencySymbol,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      totalIncome: json['total_income']?.toString() ?? '0',
      totalExpense: json['total_expense']?.toString() ?? '0',
      incomeChangePercent: json['income_change_percent']?.toString() ?? '0',
      expenseChangePercent: json['expense_change_percent']?.toString() ?? '0',
      currencySymbol: json['currency_symbol']?.toString() ?? "so'm",
    );
  }
}

class TransactionModel {
  final int? id;
  final String type;
  final String amount;
  final String note;
  final int categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final int accountId;
  final String accountName;
  final DateTime dateTime;
  final int? currencyId;
  final String? currencySymbol;

  TransactionModel({
    this.id,
    required this.type,
    required this.amount,
    required this.note,
    required this.categoryId,
    this.categoryName = '',
    this.categoryIcon = '',
    this.categoryColor = '',
    required this.accountId,
    this.accountName = '',
    required this.dateTime,
    this.currencyId,
    this.currencySymbol,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as Map<String, dynamic>? ?? {};
    final account = json['account'] as Map<String, dynamic>? ?? {};
    final currency = json['currency'];

    return TransactionModel(
      id: json['id'] as int?,
      type: json['type']?.toString() ?? 'expense',
      amount: json['amount']?.toString() ?? '0',
      note: json['note']?.toString() ?? '',
      categoryId: category['id'] as int? ?? 0,
      categoryName: category['name']?.toString() ?? '',
      categoryIcon: category['icon']?.toString() ?? '',
      categoryColor: category['color']?.toString() ?? '',
      accountId: account['id'] as int? ?? 0,
      accountName: account['name']?.toString() ?? '',
      dateTime: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      currencyId: currency is int
          ? currency
          : (currency is Map ? currency['id'] as int? : null),
      currencySymbol: currency is Map ? currency['symbol']?.toString() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'note': note,
      'category': categoryId,
      'account': accountId,
      'date': dateTime.toIso8601String(),
      if (currencyId != null) 'currency': currencyId,
    };
  }
}