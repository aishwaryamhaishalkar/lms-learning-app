import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';

class CourseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Course>> getCourses() {
    return _firestore.collection('courses').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Course.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }
}