import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/course_repository.dart';
import '../../../data/models/course_model.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository();
});

final coursesStreamProvider = StreamProvider<List<Course>>((ref) {
  final repository = ref.watch(courseRepositoryProvider);
  return repository.getCourses();
});