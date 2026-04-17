// lib/transactions/repositories/transaction_repository.dart
import '../../client.dart';
import '../models/transactions/post_transactions.dart';

class TransactionRepository {
  final ApiClient _apiClient;

  TransactionRepository(this._apiClient);

  // Create transaction
  Future<TransactionModel> createTransaction({
    required String type,
    required double amount,
    required String note,
    required int currency,
    required int account,
    required int category,
    required DateTime dateTime,
  }) async {
    final transaction = TransactionModel(
      type: type,
      amount: amount.toStringAsFixed(0),
      note: note == "Add note" ? "" : note,
      currency: currency,
      account: account,
      category: category,
      dateTime: dateTime,
    );

    return await _apiClient.createTransaction(transaction);
  }

  // Get all transactions (agar kerak bo'lsa)
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final response = await _apiClient.dio.get('/api/transactions/transactions/');

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Error loading transactions: $e');
    }
  }

  // Get transaction by id
  Future<TransactionModel> getTransactionById(int id) async {
    try {
      final response = await _apiClient.dio.get('/api/transactions/transactions/$id/');

      if (response.statusCode == 200) {
        return TransactionModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load transaction');
      }
    } catch (e) {
      throw Exception('Error loading transaction: $e');
    }
  }

  // Update transaction
  Future<TransactionModel> updateTransaction(int id, TransactionModel transaction) async {
    try {
      final response = await _apiClient.dio.put(
        '/api/transactions/transactions/$id/',
        data: transaction.toJson(),
      );

      if (response.statusCode == 200) {
        return TransactionModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update transaction');
      }
    } catch (e) {
      throw Exception('Error updating transaction: $e');
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(int id) async {
    try {
      final response = await _apiClient.dio.delete('/api/transactions/transactions/$id/');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete transaction');
      }
    } catch (e) {
      throw Exception('Error deleting transaction: $e');
    }
  }
}