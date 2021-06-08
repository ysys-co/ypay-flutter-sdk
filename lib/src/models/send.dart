import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'transaction.dart';
import 'wallet.dart';

class Send extends Transaction {
  String to;
  String description;
  int transactionId;

  Send({
    this.to,
    this.description,
    this.transactionId,
    TransactionType type = TransactionType.p2p,
    int amount,
    Wallet wallet,
  }) : super(type: type, wallet: wallet, gross: amount);

  @override
  Send.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    to = map['to_id'].toString();
    description = map['description'];
    transactionId = (map["transaction"] != null ? map["transaction"]["id"] : null);
  }

  @override
  Map<String, dynamic> toMap() => {
        'to_id': to,
        'description': description,
        'transactionId': transactionId,
        ...super.toMap(),
      };

  @override
  int get hashCode => id.hashCode ^ to.hashCode ^ description.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) && other is Send && other.id == id && other.to == to && other.description == description;

  @override
  String toString() {
    return 'Send(id: $id, to: $to, description: $description, ${super.toString()})';
  }
}
