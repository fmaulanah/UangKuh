String formatRupiah(int amount) {
  final isNegative = amount < 0;
  final digits = amount.abs().toString();

  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write('.');
    }

    buffer.write(digits[i]);
  }

  final formatted = buffer.toString();

  return isNegative ? '-Rp $formatted' : 'Rp $formatted';
}
