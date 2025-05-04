import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user's UID
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  // Add a new document
  Future<void> addData(String collection, Map<String, dynamic> data) async {
    if (_uid == null) throw Exception('User not authenticated');
    await _firestore.collection(collection).doc(_uid).set(data);
  }

  // Get user-specific document
  Future<DocumentSnapshot> getData(String collection) async {
    if (_uid == null) throw Exception('User not authenticated');
    return await _firestore.collection(collection).doc(_uid).get();
  }

  // Stream real-time data
  Stream<DocumentSnapshot> streamData(String collection) {
    if (_uid == null) throw Exception('User not authenticated');
    return _firestore.collection(collection).doc(_uid).snapshots();
  }

  // Update a field
  Future<void> updateField(String collection, String field, dynamic value) async {
    if (_uid == null) throw Exception('User not authenticated');
    await _firestore.collection(collection).doc(_uid).update({field: value});
  }

  // Delete a document
  Future<void> deleteData(String collection) async {
    if (_uid == null) throw Exception('User not authenticated');
    await _firestore.collection(collection).doc(_uid).delete();
  }
}