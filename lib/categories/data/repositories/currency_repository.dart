import 'package:tejamkor/core/client.dart';
import 'package:tejamkor/categories/data/models/currency_model.dart';

class CurrencyRepository {
  final ApiClient apiClient;

  CurrencyRepository({required this.apiClient});

  Future<UserCurrencyResponse> getUserCurrency() async {
    return await apiClient.getUserCurrency();
  }

  Future<UserCurrencyResponse> updateUserCurrency(int currencyId) async {
    return await apiClient.updateUserCurrency(currencyId);
  }
}
