import 'transaction.dart';
import 'wallet.dart';

class Purchase extends Transaction {
  String? description;
  int? code;

  Purchase({
    this.code,
    this.description,
    TransactionType type = TransactionType.p2m,
    int? amount,
    Wallet? wallet,
  }) : super(type: type, wallet: wallet, gross: amount);

  @override
  Purchase.fromMap(Map<String, dynamic> map)
      : description = map['description'],
        code = map['code'],
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() => {
        'description': description,
        'code': code,
        ...super.toMap(),
      };

  @override
  int get hashCode => id.hashCode ^ code.hashCode ^ description.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) &&
      other is Purchase &&
      other.id == id &&
      other.code == code &&
      other.description == description;

  @override
  String toString() {
    return 'Purchase(id: $id, code: $code, description: $description, ${super.toString()})';
  }
}
