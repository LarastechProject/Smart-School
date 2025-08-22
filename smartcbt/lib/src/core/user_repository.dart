import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'services.dart';

final currentAppUserProvider = StreamProvider<AppUser?>((ref) {
  final fbUser = ref.watch(authStateChangesProvider).value;
  if (fbUser == null) return const Stream<AppUser?>.empty();
  final FirebaseFirestore db = ref.watch(firestoreProvider);
  return db.collection('schools').doc('default').collection('users').doc(fbUser.uid).snapshots().map((snap) {
    if (!snap.exists) return null;
    final data = snap.data()!;
    return AppUser(uid: fbUser.uid, schoolId: data['schoolId'] ?? 'default', roles: Map<String, bool>.from(data['roles'] ?? {}));
  });
});