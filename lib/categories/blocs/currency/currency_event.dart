abstract class CurrencyEvent {}

class CurrencyFetched extends CurrencyEvent {}

class CurrencySelected extends CurrencyEvent {
  final int currencyId;
  CurrencySelected(this.currencyId);
}

class CurrencyUpdated extends CurrencyEvent {
  final int currencyId;
  CurrencyUpdated(this.currencyId);
}
