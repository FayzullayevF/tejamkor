// lib/core/data/models/transactions/post_transactions.dart
class TransactionModel {
  final String type;
  final String amount;
  final String note;
  final int currency;
  final int account;
  final int category;
  final DateTime dateTime;

  TransactionModel({
    required this.type,
    required this.amount,
    required this.note,
    required this.currency,
    required this.account,
    required this.category,
    required this.dateTime,
  });

  // JSON dan Model ga
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      type: json['type'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      note: json['note'] ?? '',
      currency: json['currency'] ?? 0,
      account: json['account'] ?? 0,
      category: json['category'] ?? 0,
      dateTime: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
    );
  }

  // Model dan JSON ga
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'currency': currency,
      'account': account,
      'category': category,
      'date': dateTime.toIso8601String(),
      'note': note,
    };
  }

  // CopyWith method
  TransactionModel copyWith({
    String? type,
    String? amount,
    String? note,
    int? currency,
    int? account,
    int? category,
    DateTime? dateTime,
  }) {
    return TransactionModel(
      type: type ?? this.type,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      currency: currency ?? this.currency,
      account: account ?? this.account,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}