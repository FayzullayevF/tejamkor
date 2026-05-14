class AccountModel {
  final int id;
  final String name;
  final String type;
  final String balance;
  final String? cardNumber;
  final String? bankAccountNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String currencyCode;

  AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.currencyCode,
    this.cardNumber,
    this.bankAccountNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    String code = 'UZS';
    if (json['currency_code'] != null) {
      code = json['currency_code'].toString();
    } else if (json['currency'] != null) {
      if (json['currency'] is Map) {
        code = json['currency']['code']?.toString() ?? 
               json['currency']['symbol']?.toString() ?? 'UZS';
      } else {
        code = json['currency'].toString();
      }
    } else if (json['currency_symbol'] != null) {
      code = json['currency_symbol'].toString();
    }

    // Fallback: try to extract from name if it ends with a 3-letter code
    String name = json['name'] as String? ?? '';
    if (code == 'UZS' || code == "so'm") {
      final uppercaseName = name.toUpperCase();
      if (uppercaseName.endsWith(' USD')) code = 'USD';
      else if (uppercaseName.endsWith(' EUR')) code = 'EUR';
      else if (uppercaseName.endsWith(' RUB')) code = 'RUB';
      else if (uppercaseName.endsWith(' UZS')) code = 'UZS';
    }

    return AccountModel(
      id: json['id'] as int,
      name: name,
      type: json['type'] as String? ?? '',
      balance: json['balance']?.toString() ?? '0.0',
      currencyCode: code,
      cardNumber: json['card_number'] as String?,
      bankAccountNumber: json['bank_account_number'] as String?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }
}
