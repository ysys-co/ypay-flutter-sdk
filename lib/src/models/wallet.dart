class Wallet {
  final int? id;
  final num? amount;

  Wallet.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        amount = map['amount'];

  static List<Wallet> fromList(List<dynamic> items) =>
      items.map((item) => Wallet.fromMap(item)).toList();
}
