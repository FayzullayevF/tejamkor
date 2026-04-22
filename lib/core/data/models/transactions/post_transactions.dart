// lib/core/data/models/transactions/post_transactions.dart
class TransactionModel {
  final int? id;
  final String type;
  final String amount;
  final String note;
  final int currency;
  final String? currencySymbol; // Yangi qo'shildi
  final int account;
  final int category;
  final String? categoryName; // API dan kelgan kategoriya nomi
  final DateTime dateTime;

  TransactionModel({
    this.id,
    required this.type,
    required this.amount,
    required this.note,
    required this.currency,
    this.currencySymbol,
    required this.account,
    required this.category,
    this.categoryName,
    required this.dateTime,
  });

  // JSON dan Model ga
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    // category maydon: id yoki map bo'lishi mumkin
    int categoryId = 0;
    String? catName;
    if (json['category'] is Map) {
      final catMap = json['category'] as Map<String, dynamic>;
      categoryId = catMap['id'] as int? ?? 0;
      catName = catMap['name']?.toString();
    } else {
      categoryId = json['category'] as int? ?? 0;
    }

    String? curSymbol;
    if (json['currency'] is Map) {
      curSymbol = json['currency']['symbol']?.toString() ?? json['currency']['code']?.toString();
    }

    return TransactionModel(
      id: json['id'] as int?,
      type: json['type']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0',
      note: json['note']?.toString() ?? '',
      currency: json['currency'] is Map
          ? (json['currency']['id'] as int? ?? 0)
          : (json['currency'] as int? ?? 0),
      currencySymbol: curSymbol,
      account: json['account'] is Map
          ? (json['account']['id'] as int? ?? 0)
          : (json['account'] as int? ?? 0),
      category: categoryId,
      categoryName: catName,
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
    int? id,
    String? type,
    String? amount,
    String? note,
    int? currency,
    String? currencySymbol,
    int? account,
    int? category,
    String? categoryName,
    DateTime? dateTime,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      account: account ?? this.account,
      category: category ?? this.category,
      categoryName: categoryName ?? this.categoryName,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}