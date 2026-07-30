import '../../../../core/database/app_database.dart';

class RecurringPlanItem {
  const RecurringPlanItem({
    required this.recurringExpense,
    required this.payment,
  });

  final RecurringExpense recurringExpense;
  final RecurringPayment? payment;

  bool get isPaid => payment != null;
}
