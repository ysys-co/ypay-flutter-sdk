import 'package:ypay/src/models/wallet.dart';

class User {
  final String id;
  final String name;
  final List<Wallet> wallets;

  User.fromMap(Map<String, dynamic> map)
      : id = map['phonenumber'],
        name = map['name'],
        wallets = Wallet.fromList(map['wallets']);
}
