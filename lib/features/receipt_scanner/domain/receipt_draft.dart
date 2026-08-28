import 'receipt_item.dart';

class ReceiptDraft {
  const ReceiptDraft({
    this.merchant,
    this.date,
    this.total,
    this.items = const [],
    required this.rawText,
  });

  final String? merchant;
  final DateTime? date;
  final int? total;
  final List<ReceiptItem> items;
  final String rawText;

  ReceiptDraft copyWith({
    String? merchant,
    DateTime? date,
    int? total,
    List<ReceiptItem>? items,
    String? rawText,
  }) {
    return ReceiptDraft(
      merchant: merchant ?? this.merchant,
      date: date ?? this.date,
      total: total ?? this.total,
      items: items ?? this.items,
      rawText: rawText ?? this.rawText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReceiptDraft &&
        other.merchant == merchant &&
        other.date == date &&
        other.total == total &&
        other.rawText == rawText;
  }

  @override
  int get hashCode => Object.hash(merchant, date, total, rawText);

  @override
  String toString() =>
      'ReceiptDraft(merchant: $merchant, date: $date, total: $total, items: ${items.length}, rawTextLength: ${rawText.length})';
}
