import '../../../core/database/app_database.dart';

class AccountListItem {
  const AccountListItem({
    required this.account,
    required this.currentBalance,
  });

  final Account account;
  final int currentBalance;
}
