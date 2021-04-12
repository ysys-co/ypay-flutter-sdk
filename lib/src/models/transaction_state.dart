part of 'transaction.dart';

class TransactionState {
  final int id;

  const TransactionState._(this.id);

  static const completed = TransactionState._(1);

  static const rejected = TransactionState._(2);

  static const pending = TransactionState._(3);

  static const canceled = TransactionState._(4);

  static const reversed = TransactionState._(5);

  static const requested = TransactionState._(6);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) && other is TransactionState && other.id == id;

  @override
  String toString() {
    return 'TransactionState($id)';
  }
}
