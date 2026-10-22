import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../data/models/progress_model.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository();
});

final progressStreamProvider = StreamProvider<List<Progress>>((ref) {
  final repository = ref.watch(progressRepositoryProvider);
  return repository.getUserProgress();
});