import 'package:equatable/equatable.dart';
import '../../../core/data/models/transactions/post_transactions.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

// Initial state
class TransactionInitial extends TransactionState {}

// Loading states
class TransactionSubmitting extends TransactionState {}
class TransactionsLoading extends TransactionState {}

// Success states
class TransactionSubmitSuccess extends TransactionState {
  final TransactionModel transaction;
  const TransactionSubmitSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionsLoadSuccess extends TransactionState {
  final List<TransactionModel> transactions;
  const TransactionsLoadSuccess(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class TransactionLoadSuccess extends TransactionState {
  final TransactionModel transaction;
  const TransactionLoadSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionUpdateSuccess extends TransactionState {
  final TransactionModel transaction;
  const TransactionUpdateSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionDeleteSuccess extends TransactionState {}

// Error state
class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}