import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/progress_model.dart';

class ProgressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveProgress(Progress progress) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(progress.courseId)
        .set(progress.toMap());
  }

  Stream<List<Progress>> getUserProgress() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('progress')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Progress.fromFirestore(doc.data())).toList());
  }
}