import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/firestore_repository_provider.dart';
import '../../auth/providers/app_session_provider.dart';

class HouseholdProfileState {
  const HouseholdProfileState({
    required this.householdId,
    required this.name,
    required this.ownerId,
    required this.isOwner,
    this.inviteCode,
  });

  final String householdId;
  final String name;
  final String ownerId;
  final bool isOwner;
  final String? inviteCode;
}

final householdProfileProvider =
    FutureProvider.autoDispose<HouseholdProfileState?>((ref) async {
  final session = ref.watch(appSessionProvider);
  if (session == null) {
    return null;
  }

  final firestoreRepo = ref.watch(firestoreRepositoryProvider);
  final householdData = await firestoreRepo.getHousehold(
    householdId: session.householdId,
  );

  if (householdData == null) {
    return null;
  }

  final ownerId = householdData['ownerId'] as String? ?? '';
  final isOwner = ownerId.isNotEmpty && ownerId == session.userId;
  final name = householdData['name'] as String? ?? 'Household';
  final rawInviteCode = householdData['inviteCode'] as String?;

  return HouseholdProfileState(
    householdId: session.householdId,
    name: name,
    ownerId: ownerId,
    isOwner: isOwner,
    inviteCode: isOwner ? rawInviteCode : null,
  );
});
