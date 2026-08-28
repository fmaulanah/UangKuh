class ReceiptItem {
  const ReceiptItem({
    required this.name,
    this.quantity,
    this.amount,
  });

  final String name;
  final int? quantity;
  final int? amount;

  ReceiptItem copyWith({
    String? name,
    int? quantity,
    int? amount,
  }) {
    return ReceiptItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReceiptItem &&
        other.name == name &&
        other.quantity == quantity &&
        other.amount == amount;
  }

  @override
  int get hashCode => Object.hash(name, quantity, amount);

  @override
  String toString() =>
      'ReceiptItem(name: $name, quantity: $quantity, amount: $amount)';
}
