// lib/core/di/injection.dart
import '../add_transactions/blocs/add_transactions_bloc.dart';
import 'client.dart';
import 'data/repos/add_transactions.dart';

// Global instances
final apiClient = ApiClient();
final transactionRepository = TransactionRepository(apiClient);
final transactionBloc = TransactionBloc(transactionRepository);