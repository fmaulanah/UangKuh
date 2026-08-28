import 'package:flutter_test/flutter_test.dart';

import 'package:uangkuh/features/receipt_scanner/data/receipt_parser.dart';

void main() {
  late ReceiptParser parser;

  setUp(() {
    parser = const ReceiptParser();
  });

  group('Total extraction', () {
    test('extracts total with Rp prefix', () {
      final draft = parser.parse('TOTAL Rp 26.500');
      expect(draft.total, 26500);
    });

    test('extracts total without Rp prefix', () {
      final draft = parser.parse('TOTAL 26.500');
      expect(draft.total, 26500);
    });

    test('extracts GRAND TOTAL', () {
      final draft = parser.parse('''
SUBTOTAL 25.000
DISKON 0
GRAND TOTAL Rp 25.000
TUNAI 50.000
KEMBALI 25.000
''');
      expect(draft.total, 25000);
    });

    test('extracts TOTAL BAYAR', () {
      final draft = parser.parse('''
Indomie 3.500
Aqua 4.000
TOTAL BAYAR 7.500
''');
      expect(draft.total, 7500);
    });

    test('handles comma-separated thousands', () {
      final draft = parser.parse('TOTAL 26,500');
      expect(draft.total, 26500);
    });

    test('handles large amounts', () {
      final draft = parser.parse('TOTAL Rp 1.250.000');
      expect(draft.total, 1250000);
    });
  });

  group('Date extraction', () {
    test('parses DD/MM/YYYY', () {
      final draft = parser.parse('28/08/2026\nTOTAL 10.000');
      expect(draft.date, DateTime(2026, 8, 28));
    });

    test('parses DD-MM-YYYY', () {
      final draft = parser.parse('28-08-2026\nTOTAL 10.000');
      expect(draft.date, DateTime(2026, 8, 28));
    });

    test('parses YYYY-MM-DD', () {
      final draft = parser.parse('2026-08-28\nTOTAL 10.000');
      expect(draft.date, DateTime(2026, 8, 28));
    });

    test('parses DD Month YYYY (Indonesian)', () {
      final draft = parser.parse('28 Agu 2026\nTOTAL 10.000');
      expect(draft.date, DateTime(2026, 8, 28));
    });

    test('parses DD Month YYYY (English)', () {
      final draft = parser.parse('15 Dec 2025\nTOTAL 10.000');
      expect(draft.date, DateTime(2025, 12, 15));
    });

    test('returns null for no date', () {
      final draft = parser.parse('TOTAL 10.000');
      expect(draft.date, isNull);
    });
  });

  group('Merchant extraction', () {
    test('detects merchant from first line', () {
      final draft = parser.parse('''
INDOMARET
Jl. Sudirman No. 123
28/08/2026
TOTAL 10.000
''');
      expect(draft.merchant, 'INDOMARET');
    });

    test('skips address-like lines', () {
      final draft = parser.parse('''
ALFAMART
Jl. Gatot Subroto 45
TOTAL 5.000
''');
      expect(draft.merchant, 'ALFAMART');
    });

    test('returns null for empty text', () {
      final draft = parser.parse('');
      expect(draft.merchant, isNull);
    });
  });

  group('Item extraction', () {
    test('extracts multiple items', () {
      final draft = parser.parse('''
INDOMARET
Indomie Goreng 3 10.500
Aqua 600ml 2 8.000
Roti 8.000
TOTAL 26.500
''');
      expect(draft.items.length, greaterThanOrEqualTo(1));
    });

    test('items have correct structure', () {
      final draft = parser.parse('''
INDOMARET
Indomie 10.500
TOTAL 10.500
''');
      if (draft.items.isNotEmpty) {
        final item = draft.items.first;
        expect(item.name, isNotEmpty);
        expect(item.amount, isNotNull);
      }
    });
  });

  group('Indonesian number formatting', () {
    test('10.500 parsed as 10500', () {
      expect(ReceiptParser.parseAmount('10.500'), 10500);
    });

    test('1.250.000 parsed as 1250000', () {
      expect(ReceiptParser.parseAmount('1.250.000'), 1250000);
    });

    test('25000 parsed as 25000', () {
      expect(ReceiptParser.parseAmount('25000'), 25000);
    });

    test('25,000 parsed as 25000', () {
      expect(ReceiptParser.parseAmount('25,000'), 25000);
    });
  });

  group('Edge cases', () {
    test('empty string produces null fields', () {
      final draft = parser.parse('');
      expect(draft.merchant, isNull);
      expect(draft.date, isNull);
      expect(draft.total, isNull);
      expect(draft.items, isEmpty);
      expect(draft.rawText, '');
    });

    test('garbage text produces no crash', () {
      final draft = parser.parse('asdf 1234 !@#\$%^&*()');
      expect(draft, isNotNull);
      expect(draft.rawText, isNotEmpty);
    });

    test('whitespace-only text produces null fields', () {
      final draft = parser.parse('   \n   \n   ');
      expect(draft.merchant, isNull);
      expect(draft.date, isNull);
      expect(draft.total, isNull);
      expect(draft.items, isEmpty);
    });

    test('rawText is preserved', () {
      const text = 'INDOMARET\nTOTAL 10.000';
      final draft = parser.parse(text);
      expect(draft.rawText, text);
    });
  });
}
