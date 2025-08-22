import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  AuthController(this._auth, this._db);
  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _db;

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password, {required String schoolId}) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final uid = cred.user!.uid;
    await _db.collection('schools').doc(schoolId).collection('users').doc(uid).set({
      'schoolId': schoolId,
      'roles': { 'student': true },
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signOut() => _auth.signOut();
}

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref.watch(firebaseAuthProvider), ref.watch(firestoreProvider));
});