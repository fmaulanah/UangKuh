import '../domain/receipt_draft.dart';
import '../domain/receipt_item.dart';

class ReceiptParser {
  const ReceiptParser();

  ReceiptDraft parse(String rawText) {
    if (rawText.trim().isEmpty) {
      return ReceiptDraft(rawText: rawText);
    }

    final lines = rawText
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    if (lines.isEmpty) {
      return ReceiptDraft(rawText: rawText);
    }

    final total = _extractTotal(lines);
    final date = _extractDate(lines);
    final merchant = _extractMerchant(lines);
    final items = _extractItems(lines);

    return ReceiptDraft(
      merchant: merchant,
      date: date,
      total: total,
      items: items,
      rawText: rawText,
    );
  }

  // ---------------------------------------------------------------------------
  // Total Extraction
  // ---------------------------------------------------------------------------
  int? _extractTotal(List<String> lines) {
    final totalKeywords = [
      RegExp(r'(?:GRAND\s*TOTAL|TOTAL\s*BAYAR|TOTAL\s*AKHIR|TOTAL\s*BELANJA|TOTAL\s*HARGA|TOTAL\s*TAGIHAN|TOTAL)', caseSensitive: false),
      RegExp(r'(?:SUBTOTAL|SUB\s*TOTAL|TAGIHAN|BAYAR|JUMLAH|HARGA\s*TOTAL)', caseSensitive: false),
    ];

    for (final pattern in totalKeywords) {
      for (var i = lines.length - 1; i >= 0; i--) {
        final line = lines[i];
        if (pattern.hasMatch(line)) {
          final cleanLine = line.replaceAll(RegExp(r'diskon|kembali|cash|tunai|debit|qris|change', caseSensitive: false), '');
          final amount = _findAmountInLine(cleanLine);
          if (amount != null && amount > 0) {
            return amount;
          }
          if (i + 1 < lines.length) {
            final nextLineAmount = _findAmountInLine(lines[i + 1]);
            if (nextLineAmount != null && nextLineAmount > 0) {
              return nextLineAmount;
            }
          }
        }
      }
    }

    // Fallback: look for largest amount near bottom
    int? maxAmount;
    final startIndex = lines.length > 5 ? lines.length - 5 : 0;
    for (var i = lines.length - 1; i >= startIndex; i--) {
      final amount = _findAmountInLine(lines[i]);
      if (amount != null) {
        if (maxAmount == null || amount > maxAmount) {
          maxAmount = amount;
        }
      }
    }

    return maxAmount;
  }

  // ---------------------------------------------------------------------------
  // Date Extraction
  // ---------------------------------------------------------------------------
  DateTime? _extractDate(List<String> lines) {
    // DD/MM/YYYY, DD-MM-YYYY, YYYY-MM-DD, DD.MM.YYYY, DD MMM YYYY
    final datePatterns = [
      RegExp(r'(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{4})'),
      RegExp(r'(\d{4})[\/\-\.](\d{1,2})[\/\-\.](\d{1,2})'),
      RegExp(
        r'(\d{1,2})\s+(Jan|Feb|Mar|Apr|Mei|May|Jun|Jul|Agu|Aug|Sep|Okt|Oct|Nov|Des|Dec)[a-z]*\s+(\d{4})',
        caseSensitive: false,
      ),
    ];

    for (final line in lines) {
      // Check DD/MM/YYYY
      final match1 = datePatterns[0].firstMatch(line);
      if (match1 != null) {
        final d = int.tryParse(match1.group(1)!);
        final m = int.tryParse(match1.group(2)!);
        final y = int.tryParse(match1.group(3)!);
        if (d != null && m != null && y != null && _isValidDate(y, m, d)) {
          return DateTime(y, m, d);
        }
      }

      // Check YYYY/MM/DD
      final match2 = datePatterns[1].firstMatch(line);
      if (match2 != null) {
        final y = int.tryParse(match2.group(1)!);
        final m = int.tryParse(match2.group(2)!);
        final d = int.tryParse(match2.group(3)!);
        if (d != null && m != null && y != null && _isValidDate(y, m, d)) {
          return DateTime(y, m, d);
        }
      }

      // Check DD Month YYYY
      final match3 = datePatterns[2].firstMatch(line);
      if (match3 != null) {
        final d = int.tryParse(match3.group(1)!);
        final monthStr = match3.group(2)!.toLowerCase();
        final y = int.tryParse(match3.group(3)!);
        final m = _monthStringToNumber(monthStr);
        if (d != null && m != null && y != null && _isValidDate(y, m, d)) {
          return DateTime(y, m, d);
        }
      }
    }

    return null;
  }

  bool _isValidDate(int y, int m, int d) {
    if (y < 2000 || y > 2100) return false;
    if (m < 1 || m > 12) return false;
    if (d < 1 || d > 31) return false;
    return true;
  }

  int? _monthStringToNumber(String monthStr) {
    if (monthStr.startsWith('jan')) return 1;
    if (monthStr.startsWith('feb')) return 2;
    if (monthStr.startsWith('mar')) return 3;
    if (monthStr.startsWith('apr')) return 4;
    if (monthStr.startsWith('mei') || monthStr.startsWith('may')) return 5;
    if (monthStr.startsWith('jun')) return 6;
    if (monthStr.startsWith('jul')) return 7;
    if (monthStr.startsWith('agu') || monthStr.startsWith('aug')) return 8;
    if (monthStr.startsWith('sep')) return 9;
    if (monthStr.startsWith('okt') || monthStr.startsWith('oct')) return 10;
    if (monthStr.startsWith('nov')) return 11;
    if (monthStr.startsWith('des') || monthStr.startsWith('dec')) return 12;
    return null;
  }

  // ---------------------------------------------------------------------------
  // Merchant Extraction
  // ---------------------------------------------------------------------------
  String? _extractMerchant(List<String> lines) {
    final ignoreWords = RegExp(
      r'(?:struk|receipt|nota|kasir|cashier|selamat datang|welcome|jl\.|jalan|no\.|telp|phone|npwp|tanggal|date|waktu|time)',
      caseSensitive: false,
    );

    for (var i = 0; i < lines.length && i < 4; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      if (line.length < 3) continue;
      if (RegExp(r'^\d+$').hasMatch(line)) continue;
      if (ignoreWords.hasMatch(line)) continue;
      if (_findAmountInLine(line) != null && !RegExp(r'[a-zA-Z]{4,}').hasMatch(line)) continue;

      return line;
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Item Extraction
  // ---------------------------------------------------------------------------
  List<ReceiptItem> _extractItems(List<String> lines) {
    final items = <ReceiptItem>[];

    final summaryKeywords = RegExp(
      r'(?:total|subtotal|tunai|cash|kembali|change|diskon|discount|ppn|pajak|tax|debit|kredit|qris|kartu|card|terima kasih|thank you|item)',
      caseSensitive: false,
    );

    // Look for lines that have a name + optional qty + amount
    // Pattern example: "Indomie Goreng 3 10.500" or "Aqua 600ml 2 8.000" or "Roti 8.000"
    for (final line in lines) {
      if (summaryKeywords.hasMatch(line)) continue;

      final amount = _findAmountInLine(line);
      if (amount == null || amount <= 0) continue;

      // Extract parts before the amount
      final cleanLine = line.replaceAll(RegExp(r'Rp\.?\s*', caseSensitive: false), ' ');
      // Match pattern: name [qty] amount
      final itemMatch = RegExp(r'^(.+?)(?:\s+(\d+)\s*(?:x|pcs|buahkan)?)?\s+([0-9\.,]+)$', caseSensitive: false).firstMatch(cleanLine);

      if (itemMatch != null) {
        final name = itemMatch.group(1)?.trim();
        final qtyStr = itemMatch.group(2);
        final qty = qtyStr != null ? int.tryParse(qtyStr) : null;

        if (name != null && name.length >= 2 && !summaryKeywords.hasMatch(name)) {
          // Verify name isn't just digits/dates
          if (RegExp(r'[a-zA-Z]').hasMatch(name)) {
            items.add(ReceiptItem(
              name: name,
              quantity: qty ?? 1,
              amount: amount,
            ));
          }
        }
      }
    }

    return items;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  int? _findAmountInLine(String line) {
    // Look for patterns like "Rp 25.000", "25.000", "25,000", "Rp25000", "25000"
    // Match amounts, prioritizing Rp prefixed or formatted numbers with dot/comma separators
    final formattedPatterns = [
      RegExp(r'Rp\.?\s*([0-9]{1,3}(?:[\.,][0-9]{3})*(?:[\.,][0-9]{2})?)', caseSensitive: false),
      RegExp(r'([0-9]{1,3}(?:[\.,][0-9]{3})+(?:[\.,][0-9]{2})?)'),
      RegExp(r'Rp\.?\s*([0-9]+)', caseSensitive: false),
      RegExp(r'\b([0-9]{3,9})\b'),
    ];

    for (final pattern in formattedPatterns) {
      final matches = pattern.allMatches(line);
      for (final match in matches) {
        final matchStr = match.group(1);
        if (matchStr != null) {
          final parsed = parseAmount(matchStr);
          if (parsed != null && parsed > 0) {
            return parsed;
          }
        }
      }
    }

    return null;
  }

  static int? parseAmount(String rawAmount) {
    var cleaned = rawAmount.replaceAll(RegExp(r'[^0-9\.,]'), '').trim();
    if (cleaned.isEmpty) return null;

    // Handle Indonesian dot as thousand separator and comma as decimal: "25.000" -> 25000, "25.000,00" -> 25000
    // Or standard comma as thousand separator: "25,000" -> 25000, "25,000.00" -> 25000
    if (cleaned.contains('.') && cleaned.contains(',')) {
      if (cleaned.lastIndexOf(',') > cleaned.lastIndexOf('.')) {
        // e.g. 25.000,00
        cleaned = cleaned.substring(0, cleaned.lastIndexOf(',')).replaceAll('.', '');
      } else {
        // e.g. 25,000.00
        cleaned = cleaned.substring(0, cleaned.lastIndexOf('.')).replaceAll(',', '');
      }
    } else if (cleaned.contains('.')) {
      final parts = cleaned.split('.');
      if (parts.length > 1 && parts.last.length == 3) {
        // e.g. 25.000 or 1.250.000 -> thousand separators
        cleaned = cleaned.replaceAll('.', '');
      } else if (parts.length > 2) {
        // multiple dots: 1.000.000
        cleaned = cleaned.replaceAll('.', '');
      } else if (parts.length == 2 && parts.last.length == 2) {
        // e.g. 25000.00 -> decimal
        cleaned = parts.first;
      } else {
        cleaned = cleaned.replaceAll('.', '');
      }
    } else if (cleaned.contains(',')) {
      final parts = cleaned.split(',');
      if (parts.length > 1 && parts.last.length == 3) {
        // e.g. 25,000 or 1,250,000 -> thousand separators
        cleaned = cleaned.replaceAll(',', '');
      } else if (parts.length > 2) {
        // multiple commas
        cleaned = cleaned.replaceAll(',', '');
      } else if (parts.length == 2 && parts.last.length == 2) {
        // e.g. 25000,00 -> decimal
        cleaned = parts.first;
      } else {
        cleaned = cleaned.replaceAll(',', '');
      }
    }

    return int.tryParse(cleaned);
  }
}
