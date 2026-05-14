import 'package:tejamkor/categories/data/models/currency_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejamkor/core/client.dart';
import 'package:tejamkor/home/data/models/dashboard_model.dart';

class DashboardRepository {
  final ApiClient _apiClient;
  static const String _storageKey = 'dashboard_currency_ids';

  DashboardRepository(this._apiClient);

  Future<DashboardModel> getDashboard({
    int? month,
    int? year,
    String? transactionType,
    String? currency,
  }) async {
    return _apiClient.getDashboard(
      month: month,
      year: year,
      transactionType: transactionType,
      currency: currency,
    );
  }

  Future<List<CurrencyModel>> getDashboardCurrencies() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await _apiClient.getUserCurrency();
    final allAvailable = response.availableCurrencies;
    
    List<String> storedIds = prefs.getStringList(_storageKey) ?? [];
    
    // If empty (first time), initialize with default 4 (UZS, USD, EUR, RUB)
    if (storedIds.isEmpty) {
      final defaults = allAvailable.where((c) => 
        ['UZS', 'USD', 'EUR', 'RUB'].contains(c.code.toUpperCase())
      ).map((c) => c.id.toString()).toList();
      
      if (defaults.isNotEmpty) {
        storedIds = defaults;
        await prefs.setStringList(_storageKey, storedIds);
      }
    }

    // Filter allAvailable to only show those in storedIds
    final dashboardCurrencies = allAvailable.where((c) => 
      storedIds.contains(c.id.toString())
    ).toList();

    return dashboardCurrencies;
  }

  Future<List<CurrencyModel>> getOtherCurrencies() async {
    // Specifically use the requested endpoint
    final allOthers = await _apiClient.getOtherCurrencies();
    final prefs = await SharedPreferences.getInstance();
    final List<String> storedIds = prefs.getStringList(_storageKey) ?? [];
    
    // Return those that are NOT already in our dashboard (local check)
    return allOthers.where((c) => !storedIds.contains(c.id.toString())).toList();
  }

  Future<void> addCurrencyToDashboard(int currencyId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> storedIds = prefs.getStringList(_storageKey) ?? [];
    if (!storedIds.contains(currencyId.toString())) {
      storedIds.add(currencyId.toString());
      await prefs.setStringList(_storageKey, storedIds);
    }
    
    try {
      await _apiClient.addCurrencyToDashboard(currencyId);
    } catch (_) {}
  }

  Future<void> removeCurrencyFromDashboard(int currencyId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> storedIds = prefs.getStringList(_storageKey) ?? [];
    storedIds.remove(currencyId.toString());
    await prefs.setStringList(_storageKey, storedIds);

    try {
      await _apiClient.removeCurrencyFromDashboard(currencyId);
    } catch (_) {}
  }
}
