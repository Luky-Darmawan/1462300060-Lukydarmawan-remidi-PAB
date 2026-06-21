import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/article.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _favoritesRef {
    final uid = _uid;
    if (uid == null) {
      throw StateError('User belum login');
    }
    return _firestore.collection('users').doc(uid).collection('favorites');
  }

  /// Stream realtime daftar favorit milik user yang sedang login
  Stream<List<Map<String, dynamic>>> getFavoritesStream() {
    if (_uid == null) return const Stream.empty();
    return _favoritesRef
        .orderBy('publishedAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => {...d.data(), 'docId': d.id}).toList());
  }

  /// Cek apakah artikel tertentu sudah difavoritkan (untuk Detail Page)
  Stream<bool> isFavorite(int articleId) {
    if (_uid == null) return Stream.value(false);
    return _favoritesRef.doc(articleId.toString()).snapshots().map(
          (doc) => doc.exists,
        );
  }

  /// Tambah artikel ke favorites
  Future<void> addFavorite(Article article) async {
    if (_uid == null) return;
    final data = article.toFavoriteMap();
    await _favoritesRef.doc(article.id.toString()).set(data);
  }

  /// Hapus artikel dari favorites
  Future<void> removeFavorite(int articleId) async {
    if (_uid == null) return;
    await _favoritesRef.doc(articleId.toString()).delete();
  }

  // ---------------- Profile ----------------

  Future<Map<String, dynamic>?> getUserProfile() async {
    if (_uid == null) return null;
    final doc = await _firestore.collection('users').doc(_uid).get();
    return doc.data();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userProfileStream() {
    return _firestore.collection('users').doc(_uid ?? 'unknown').snapshots();
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_uid == null) return;
    await _firestore.collection('users').doc(_uid).update(data);
  }

  // ---------------- Notifications ----------------

  Stream<List<Map<String, dynamic>>> getNotificationsStream() {
    return _firestore
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => {...d.data(), 'docId': d.id}).toList());
  }
}
