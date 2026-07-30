class MonthlySummary {
  const MonthlySummary({
    required this.income,
    required this.expense,
  });

  final int income;
  final int expense;

  int get net => income - expense;
}
