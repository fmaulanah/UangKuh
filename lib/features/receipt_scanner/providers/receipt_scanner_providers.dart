import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/receipt_ocr_service.dart';
import '../data/receipt_parser.dart';

final receiptOcrServiceProvider = Provider<ReceiptOcrService>((ref) {
  final service = ReceiptOcrService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

final receiptParserProvider = Provider<ReceiptParser>((ref) {
  return const ReceiptParser();
});
