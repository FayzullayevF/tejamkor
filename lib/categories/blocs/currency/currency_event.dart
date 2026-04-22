import 'package:tejamkor/categories/data/models/currency_model.dart';

abstract class CurrencyEvent {}

class CurrencyFetched extends CurrencyEvent {}

class CurrencyUpdated extends CurrencyEvent {
  final CurrencyModel currency;

  CurrencyUpdated(this.currency);
}
