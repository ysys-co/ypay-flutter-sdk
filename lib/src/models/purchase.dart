import 'transaction.dart';
import 'wallet.dart';

export 'package:ypay/src/services/purchase_service.dart';

class Purchase extends Transaction {
  String description;
  int code;

  Purchase({this.description, this.code, int amount, Wallet wallet})
      : super(amount: amount, wallet: wallet);

  Purchase.fromMap(Map<String, dynamic> map)
      : description = map['description'],
        code = map['code'],
        super.fromMap(map);

  Map<String, dynamic> toMap() => {
        'description': description,
        'code': code,
        ...super.toMap(),
      };
}
