import 'package:tejamkor/core/client.dart';
import 'package:tejamkor/categories/data/models/currency_model.dart';

class CurrencyRepository {
  final ApiClient _apiClient;

  CurrencyRepository(this._apiClient);

  Future<UserCurrencyResponse> getUserCurrency() async {
    return await _apiClient.getUserCurrency();
  }

  Future<void> updateUserCurrency(int currencyId) async {
    await _apiClient.updateUserCurrency(currencyId);
  }
}
