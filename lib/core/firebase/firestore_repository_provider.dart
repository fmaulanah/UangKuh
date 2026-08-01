import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_firestore_repository.dart';
import 'firestore_provider.dart';
import 'firestore_repository.dart';

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);

  return FirebaseFirestoreRepository(firestore);
});
