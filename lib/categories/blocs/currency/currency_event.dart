abstract class CurrencyEvent {}

class CurrencyFetched extends CurrencyEvent {}

class CurrencyUpdated extends CurrencyEvent {
  final int currencyId;

  CurrencyUpdated(this.currencyId);
}
