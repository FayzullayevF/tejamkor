class CurrencyDetail {
  final int id;
  final String code;
  final String name;
  final String symbol;
  final String rate;

  CurrencyDetail({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.rate,
  });

  factory CurrencyDetail.fromJson(Map<String, dynamic> json) {
    return CurrencyDetail(
      id: json['id'] as int,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      rate: json['rate']?.toString() ?? '',
    );
  }
}

class AccountModel {
  final int id;
  final String name;
  final String type;
  final CurrencyDetail? currencyDetail;
  final String balance;
  final String? cardNumber;
  final String? bankAccountNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AccountModel({
    required this.id,
    required this.name,
    required this.type,
    this.currencyDetail,
    required this.balance,
    this.cardNumber,
    this.bankAccountNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      currencyDetail: json['currency_detail'] != null 
          ? CurrencyDetail.fromJson(json['currency_detail'] as Map<String, dynamic>) 
          : null,
      balance: json['balance']?.toString() ?? '0.0',
      cardNumber: json['card_number'] as String?,
      bankAccountNumber: json['bank_account_number'] as String?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }
}
