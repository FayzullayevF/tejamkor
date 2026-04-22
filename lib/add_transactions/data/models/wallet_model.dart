class WalletModel {
  final int id;
  final String name;
  final double balance;
  final String code;
  final String icon;

  WalletModel(this.id, this.name, this.balance, this.code, this.icon);

  WalletModel copyWith({double? balance}) {
    return WalletModel(id, name, balance ?? this.balance, code, icon);
  }
}
