// lib/transactions/blocs/transaction/transaction_event.dart
import 'package:equatable/equatable.dart';
import '../../../core/data/models/transactions/post_transactions.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

// Submit new transaction
class SubmitTransactionEvent extends TransactionEvent {
  final String type;
  final double amount;
  final String note;
  final int currency;
  final int account;
  final int category;
  final DateTime dateTime;

  const SubmitTransactionEvent({
    required this.type,
    required this.amount,
    required this.note,
    required this.currency,
    required this.account,
    required this.category,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [
    type, amount, note, currency, account, category, dateTime
  ];
}

// Get all transactions
class GetAllTransactionsEvent extends TransactionEvent {}

// Get transaction by id
class GetTransactionByIdEvent extends TransactionEvent {
  final int id;
  const GetTransactionByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

// Update transaction
class UpdateTransactionEvent extends TransactionEvent {
  final int id;
  final TransactionModel transaction;
  const UpdateTransactionEvent(this.id, this.transaction);

  @override
  List<Object?> get props => [id, transaction];
}

// Delete transaction
class DeleteTransactionEvent extends TransactionEvent {
  final int id;
  const DeleteTransactionEvent(this.id);

  @override
  List<Object?> get props => [id];
}

// Reset state
class ResetTransactionStateEvent extends TransactionEvent {}