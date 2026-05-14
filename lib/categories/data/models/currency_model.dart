// lib/categories/data/models/currency_model.dart

class CurrencyModel {
  final int id;
  final String code;
  final String name;
  final String symbol;
  final String rate;
  final bool isDefault;

  CurrencyModel({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.rate,
    required this.isDefault,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      rate: json['rate']?.toString() ?? '0.0',
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'symbol': symbol,
      'rate': rate,
      'is_default': isDefault,
    };
  }
}

class UserCurrencyResponse {
  final int currency;
  final CurrencyModel currencyDetail;
  final List<CurrencyModel> availableCurrencies;

  UserCurrencyResponse({
    required this.currency,
    required this.currencyDetail,
    required this.availableCurrencies,
  });

  factory UserCurrencyResponse.fromJson(Map<String, dynamic> json) {
    return UserCurrencyResponse(
      currency: (json['currency'] as num?)?.toInt() ?? 0,
      currencyDetail: CurrencyModel.fromJson(
        json['currency_detail'] as Map<String, dynamic>? ?? {},
      ),
      availableCurrencies: (json['available_currencies'] as List? ?? [])
          .map((e) => CurrencyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'currency_detail': currencyDetail.toJson(),
      'available_currencies':
          availableCurrencies.map((e) => e.toJson()).toList(),
    };
  }
}
