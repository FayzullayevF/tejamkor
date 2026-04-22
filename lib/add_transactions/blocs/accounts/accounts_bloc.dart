import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejamkor/core/data/repos/account_repository.dart';
import 'accounts_event.dart';
import 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final AccountRepository repository;

  AccountsBloc({required this.repository}) : super(AccountsInitial()) {
    on<FetchAccountsEvent>(_onFetchAccounts);
  }

  Future<void> _onFetchAccounts(FetchAccountsEvent event, Emitter<AccountsState> emit) async {
    emit(AccountsLoading());
    try {
      final accounts = await repository.getAccounts();
      emit(AccountsLoaded(accounts));
    } catch (e) {
      emit(AccountsError(e.toString()));
    }
  }
}
