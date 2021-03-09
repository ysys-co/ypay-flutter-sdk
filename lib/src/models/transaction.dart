import 'wallet.dart';

enum TransactionState {
  completed,
  rejected,
  pending,
  canceled,
  reversed,
  requested,
  unknown,
}

abstract class Transaction {
  int id;
  num gross = 0;
  num fee = 0;
  num rate = 0;
  num net = 0;

  int walletId;

  TransactionState state;

  Transaction({
    num amount,
    Wallet wallet,
  })  : state = TransactionState.pending,
        gross = amount,
        walletId = wallet?.id;

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
        state = (map.containsKey('transaction_state_id') &&
                TransactionState.values.length >= map['transaction_state_id'])
            ? TransactionState.values[map['transaction_state_id'] - 1]
            : TransactionState.unknown,
        gross = map['gross'],
        fee = map['fee'],
        net = map['net'],
        rate = map['rate'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'transaction_state_id': state.index + 1,
        'amount': gross,
      }..removeWhere((key, value) => value == null);
}
