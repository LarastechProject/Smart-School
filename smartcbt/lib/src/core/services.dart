import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<fb.FirebaseAuth>((ref) => fb.FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final authStateChangesProvider = StreamProvider<fb.User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});