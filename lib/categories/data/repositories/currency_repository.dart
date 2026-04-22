import 'package:tejamkor/core/client.dart';
import 'package:tejamkor/categories/data/models/currency_model.dart';

class CurrencyRepository {
  final ApiClient _apiClient;

  CurrencyRepository(this._apiClient);

  Future<List<CurrencyModel>> getCurrencies() async {
    return await _apiClient.getCurrencies();
  }

  Future<UserCurrencyResponse> getUserCurrency() async {
    return await _apiClient.getUserCurrency();
  }

  Future<void> updateUserCurrency(CurrencyModel currency) async {
    await _apiClient.updateUserCurrency(currency);
  }
}
