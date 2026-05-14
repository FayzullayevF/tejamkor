import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tejamkor/categories/blocs/currency/currency_event.dart';

import 'package:tejamkor/core/routing/router.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_bloc.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_event.dart';
import 'package:tejamkor/add_transactions/blocs/add_transactions_state.dart';
import 'package:tejamkor/add_transactions/blocs/accounts/accounts_event.dart';
import 'package:tejamkor/add_transactions/blocs/accounts/accounts_bloc.dart';
import 'package:tejamkor/add_transactions/blocs/accounts/accounts_state.dart';
import 'package:tejamkor/categories/data/models/category_model.dart';
import 'package:tejamkor/categories/data/repositories/category_repository.dart';

import '../data/models/wallet_model.dart';
import '../widgets/transaction_app_bar.dart';
import '../widgets/transaction_type_toggle.dart';
import '../widgets/amount_input_section.dart';
import '../widgets/transaction_info_cards.dart';
import '../widgets/category_selection_grid.dart';
import '../widgets/wallet_selection_card.dart';
import '../widgets/save_transaction_button.dart';
import '../widgets/income_placeholder.dart';
import 'package:tejamkor/widgets/app_snackbar.dart';
import 'package:tejamkor/categories/blocs/currency/currency_bloc.dart';
import 'package:tejamkor/categories/blocs/currency/currency_state.dart';

class AddTransactionView extends StatefulWidget {
  const AddTransactionView({super.key});

  @override
  State<AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  int _selectedIndex = 0;
  double _amount = 0.0;
  DateTime _selectedDate = DateTime.now();
  String _note = "Add note";
  String _transactionType = "expense";
  int _selectedAccount = 1;
  final double maxTransactionAmount = 100000000.0;
  int? _selectedCurrencyId;

  List<CategoryModel> _allCategoriesList = [];
  List<CategoryModel> _filteredCategories = [];
  bool _isLoading = true;
  List<WalletModel> _wallets = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    context.read<AccountsBloc>().add(FetchAccountsEvent());
    context.read<CurrencyBloc>().add(CurrencyFetched());
    _loadBalances();
  }

  Future<void> _fetchCategories() async {
    try {
      final repo = context.read<CategoryRepository>();
      var categories = await repo.getUserCategories();

      if (categories.isEmpty) {
        categories = await repo.getCategories();
      }

      if (mounted) {
        setState(() {
          _allCategoriesList = categories;
          _updateFilteredCategories();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _updateFilteredCategories() {
    _filteredCategories = _allCategoriesList
        .where((c) => c.type == _transactionType)
        .toList();
    _selectedIndex = 0;
  }

  Future<void> _loadBalances() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < _wallets.length; i++) {
        final savedBalance = prefs.getDouble(
          'wallet_balance_${_wallets[i].id}',
        );
        if (savedBalance != null) {
          _wallets[i] = _wallets[i].copyWith(balance: savedBalance);
        }
      }
    });
  }

  Future<void> _saveBalances() async {
    final prefs = await SharedPreferences.getInstance();
    for (var wallet in _wallets) {
      await prefs.setDouble('wallet_balance_${wallet.id}', wallet.balance);
    }
  }

  String _getWalletIcon(String code) {
    switch (code) {
      case 'UZS':
        return "assets/icons/tejamkor_kredit.svg";
      case 'USD':
        return "assets/icons/tejamkor_otkazmalar.svg";
      case 'EUR':
        return "assets/icons/tejamkor_omonatlar.svg";
      default:
        return "assets/icons/tejamkor_kredit.svg";
    }
  }

  void _onSave() {
    if (_amount <= 0) {
      AppSnackbar.showError(context, 'Iltimos, summani kiriting');
      return;
    }
    if (_filteredCategories.isEmpty) {
      AppSnackbar.showError(context, 'Iltimos, kategoriya tanlang');
      return;
    }

    context.read<TransactionBloc>().add(
      SubmitTransactionEvent(
        type: _transactionType,
        amount: _amount,
        note: _note == "Add note" ? "" : _note,
        account: _selectedAccount,
        category: _filteredCategories[_selectedIndex].id,
        dateTime: _selectedDate,
        currencyId: _selectedCurrencyId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color subtitleColor = isDark
        ? Colors.white54
        : const Color(0xFF7C7777);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xffF3F3F3),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TransactionBloc, TransactionState>(
            listener: (context, state) {
              if (state is TransactionSubmitSuccess) {
                setState(() {
                  final walletIdx = _wallets.indexWhere(
                    (w) => w.id == _selectedAccount,
                  );
                  if (walletIdx != -1) {
                    double newBalance;
                    if (_transactionType == 'income') {
                      newBalance = _wallets[walletIdx].balance + _amount;
                    } else {
                      newBalance = _wallets[walletIdx].balance - _amount;
                    }
                    _wallets[walletIdx] = _wallets[walletIdx].copyWith(
                      balance: newBalance,
                    );
                    _saveBalances();
                  }
                  _amount = 0.0;
                });
                AppSnackbar.showSuccess(
                  context,
                  'Tranzaksiya muvaffaqiyatli qo\'shildi!',
                );
                context.read<TransactionBloc>().add(
                  ResetTransactionStateEvent(),
                );

                context.go(Routers.transactionHistory);
              } else if (state is TransactionError) {
                AppSnackbar.showError(context, 'Xatolik: ${state.message}');
              }
            },
          ),
          BlocListener<AccountsBloc, AccountsState>(
            listener: (context, state) {
              if (state is AccountsLoaded) {
                setState(() {
                  _wallets = state.accounts.map((acc) {
                    final code = acc.currencyCode;
                    return WalletModel(
                      acc.id,
                      acc.name,
                      double.tryParse(acc.balance) ?? 0.0,
                      code,
                      _getWalletIcon(code),
                    );
                  }).toList();
                  if (_wallets.isNotEmpty &&
                      !_wallets.any((w) => w.id == _selectedAccount)) {
                    _selectedAccount = _wallets.first.id;
                  }
                  _loadBalances();
                });
              }
            },
          ),
        ],
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20.h),
                  TransactionAppBar(
                    textColor: textColor,
                    onBack: () => context.go(Routers.home),
                  ),
                  SizedBox(height: 24.h),
                  TransactionTypeToggle(
                    transactionType: _transactionType,
                    onTypeChanged: (type) {
                      setState(() {
                        _transactionType = type;
                        _updateFilteredCategories();
                      });
                    },
                  ),
                  SizedBox(height: 32.h),
                  BlocBuilder<CurrencyBloc, CurrencyState>(
                    builder: (context, currencyState) {
                      final response = currencyState.response;
                      final available = response?.availableCurrencies ?? [];
                      final currentSymbol =
                          response?.currencyDetail.symbol ?? "so'm";
                      if (_selectedCurrencyId == null && response != null) {
                        _selectedCurrencyId = response.currency;
                      }

                      return AmountInputSection(
                        amount: _amount,
                        currencySymbol: currentSymbol,
                        textColor: textColor,
                        maxTransactionAmount: maxTransactionAmount,
                        onAmountChanged: (val) => setState(() => _amount = val),
                        availableCurrencies: available,
                        selectedCurrencyId: _selectedCurrencyId ?? 0,
                        onCurrencyChanged: (id) =>
                            setState(() => _selectedCurrencyId = id),
                      );
                    },
                  ),
                  SizedBox(height: 32.h),
                  TransactionInfoCards(
                    selectedDate: _selectedDate,
                    note: _note,
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    onDateChanged: (date) =>
                        setState(() => _selectedDate = date),
                    onNoteChanged: (note) => setState(() => _note = note),
                  ),
                  SizedBox(height: 32.h),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF006673),
                      ),
                    )
                  else
                    CategorySelectionGrid(
                      categories: _filteredCategories,
                      selectedIndex: _selectedIndex,
                      cardColor: cardColor,
                      textColor: textColor,
                      onCategorySelected: (idx) =>
                          setState(() => _selectedIndex = idx),
                      onSeeAll: () async {
                        final selected = await context.push<CategoryModel>(
                          Routers.transactionCategories,
                        );
                        if (selected != null) {
                          setState(() {
                            if (!_allCategoriesList.any(
                              (c) => c.id == selected.id,
                            )) {
                              _allCategoriesList.insert(0, selected);
                            }
                            _transactionType = selected.type;
                            _updateFilteredCategories();
                            _selectedIndex = _filteredCategories.indexWhere(
                              (c) => c.id == selected.id,
                            );
                          });
                        }
                      },
                    ),
                  SizedBox(height: 32.h),
                  WalletSelectionCard(
                    wallets: _wallets,
                    selectedAccountId: _selectedAccount,
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    isDark: isDark,
                    onAccountSelected: (id) {
                      setState(() {
                        _selectedAccount = id;
                      });
                    },
                  ),
                  SizedBox(height: 32.h),
                  BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, state) {
                      return SaveTransactionButton(
                        isSubmitting: state is TransactionSubmitting,
                        onSave: _onSave,
                      );
                    },
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
