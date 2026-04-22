import 'package:tejamkor/core/client.dart';
import 'package:tejamkor/core/data/models/accounts/account_model.dart';

class AccountRepository {
  final ApiClient _apiClient;

  AccountRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<AccountModel>> getAccounts() async {
    return await _apiClient.getAccounts();
  }
}
