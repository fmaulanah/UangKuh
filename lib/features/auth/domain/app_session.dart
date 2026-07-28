class AppSession {
  const AppSession({
    required this.userId,
    required this.householdId,
    required this.email,
    required this.displayName,
  });

  final String userId;
  final String householdId;
  final String email;
  final String displayName;
}
