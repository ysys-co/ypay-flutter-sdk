library ypay;

import 'wallet.dart';

part 'transaction_type.dart';
part 'transaction_state.dart';

abstract class Transaction {
  final int id;
  final TransactionState state;
  final num fee;
  final num rate;
  final num net;

  TransactionType type;
  num gross = 0;

  Wallet wallet;

  Transaction({
    this.type,
    this.wallet,
    this.gross,
  })  : id = null,
        state = TransactionState.pending,
        fee = 0,
        net = 0,
        rate = 0;

  bool get isCompleted => state == TransactionState.completed;
  bool get isRejected => state == TransactionState.rejected;
  bool get isPending => state == TransactionState.pending;
  bool get isCanceled => state == TransactionState.canceled;
  bool get isReversed => state == TransactionState.reversed;
  bool get isRequested => state == TransactionState.requested;

  set amount(num value) {
    gross = value;
  }

  num get amount => gross;

  Transaction.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        type = TransactionType._(map['transaction_type_id']),
        state = TransactionState._(map['transaction_state_id']),
        gross = map['gross'],
        fee = map['fee'],
        net = map['net'],
        rate = map['rate'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'wallet_id': wallet.id,
        'transaction_type_id': type.id,
        'transaction_state_id': state.id,
        'amount': gross,
      }..removeWhere((key, value) => value == null);

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      state.hashCode ^
      gross.hashCode ^
      fee.hashCode ^
      rate.hashCode ^
      net.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) &&
      other is Transaction &&
      other.id == id &&
      other.type == type &&
      other.state == state &&
      other.gross == gross &&
      other.fee == fee &&
      other.rate == rate &&
      other.net == net;

  @override
  String toString() {
    return 'Transaction(id: $id, type: $type, state: $state, gross: $gross, fee: $fee, rate: $rate, net: $net)';
  }
}
