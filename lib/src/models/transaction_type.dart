part of 'transaction.dart';

class TransactionType {
  final int? id;

  const TransactionType._(this.id);

  /// Person to person (P2P)
  static const p2p = TransactionType._(1);

  /// Person to merchant (P2M)
  static const p2m = TransactionType._(2);

  /// Merchant to merchant (M2M)
  static const m2m = TransactionType._(4);

  /// Request to person (R2P)
  static const r2p = TransactionType._(29);

  /// Person to corporate (P2C)
  static const p2c = TransactionType._(38);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) && other is TransactionType && other.id == id;

  @override
  String toString() {
    return 'TransactionType($id)';
  }
}
