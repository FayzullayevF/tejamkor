class CurrencyModel {
  final int id;
  final String code;
  final String name;
  final String symbol;
  final String rate;

  CurrencyModel({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.rate,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      rate: json['rate']?.toString() ?? '',
    );
  }
}

class UserCurrencyResponse {
  final int currencyId;
  final CurrencyModel? currencyDetail;
  final List<CurrencyModel> availableCurrencies;

  UserCurrencyResponse({
    required this.currencyId,
    this.currencyDetail,
    required this.availableCurrencies,
  });

  factory UserCurrencyResponse.fromJson(Map<String, dynamic> json) {
    return UserCurrencyResponse(
      currencyId: json['currency'] as int? ?? 0,
      currencyDetail: json['currency_detail'] != null 
          ? CurrencyModel.fromJson(json['currency_detail']) 
          : null,
      availableCurrencies: (json['available_currencies'] as List? ?? [])
          .map((e) => CurrencyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
