// lib/transactions/blocs/transaction/transaction_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/data/repos/add_transactions.dart';
import 'add_transactions_event.dart';
import 'add_transactions_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;

  TransactionBloc(this._repository) : super(TransactionInitial()) {
    on<SubmitTransactionEvent>(_onSubmitTransaction);
    on<GetAllTransactionsEvent>(_onGetAllTransactions);
    on<GetTransactionByIdEvent>(_onGetTransactionById);
    on<UpdateTransactionEvent>(_onUpdateTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<ResetTransactionStateEvent>(_onResetState);
  }

  // Submit new transaction
  Future<void> _onSubmitTransaction(
      SubmitTransactionEvent event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionSubmitting());

    try {
      final transaction = await _repository.createTransaction(
        type: event.type,
        amount: event.amount,
        note: event.note,
        currency: event.currency,
        account: event.account,
        category: event.category,
        dateTime: event.dateTime,
      );

      emit(TransactionSubmitSuccess(transaction));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  // Get all transactions
  Future<void> _onGetAllTransactions(
      GetAllTransactionsEvent event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionsLoading());

    try {
      final transactions = await _repository.getAllTransactions();
      emit(TransactionsLoadSuccess(transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  // Get transaction by id
  Future<void> _onGetTransactionById(
      GetTransactionByIdEvent event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionsLoading());

    try {
      final transaction = await _repository.getTransactionById(event.id);
      emit(TransactionLoadSuccess(transaction));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  // Update transaction
  Future<void> _onUpdateTransaction(
      UpdateTransactionEvent event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionSubmitting());

    try {
      final transaction = await _repository.updateTransaction(
          event.id,
          event.transaction
      );
      emit(TransactionUpdateSuccess(transaction));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  // Delete transaction
  Future<void> _onDeleteTransaction(
      DeleteTransactionEvent event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionSubmitting());

    try {
      await _repository.deleteTransaction(event.id);
      emit(TransactionDeleteSuccess());
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  // Reset state
  void _onResetState(
      ResetTransactionStateEvent event,
      Emitter<TransactionState> emit,
      ) {
    emit(TransactionInitial());
  }
}