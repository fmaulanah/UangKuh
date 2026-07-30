import '../../domain/expense_type.dart';
import '../../domain/transaction_type.dart';

class TransactionListItem {
  const TransactionListItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.transactionDate,
    this.expenseType,
    this.sourceAccountName,
    this.destinationAccountName,
    this.categoryName,
    this.description,
  });

  final String id;
  final TransactionType type;
  final String title;
  final String subtitle;
  final int amount;
  final DateTime transactionDate;

  final ExpenseType? expenseType;
  final String? sourceAccountName;
  final String? destinationAccountName;
  final String? categoryName;
  final String? description;
}
