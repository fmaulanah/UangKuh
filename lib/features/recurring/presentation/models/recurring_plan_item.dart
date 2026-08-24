import '../../../../core/database/app_database.dart';
import '../../domain/recurring_payment_status.dart';

class RecurringPlanItem {
  const RecurringPlanItem({
    required this.recurringExpense,
    required this.payment,
  });

  final RecurringExpense recurringExpense;
  final RecurringPayment? payment;

  bool get isPaid => payment?.status == RecurringPaymentStatus.paid;
}

