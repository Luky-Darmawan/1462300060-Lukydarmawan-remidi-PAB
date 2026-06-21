import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'local_storage_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Registrasi pengguna baru + simpan profil ke Firestore
  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.updateDisplayName(name);

    // Simpan data profil dasar ke collection "users"
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'name': name,
      'email': email,
      'photoUrl': '',
      'instagram': '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  /// Login pengguna
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await LocalStorageService.setLoggedIn(true);
    await LocalStorageService.setUid(credential.user?.uid ?? '');
    return credential;
  }

  /// Reset password via email
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Logout: hapus session lokal & sign out dari Firebase
  Future<void> logout() async {
    await _auth.signOut();
    await LocalStorageService.clearSession();
  }
}
