import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/announcement_repository.dart';
import '../../../data/models/announcement_model.dart';

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return AnnouncementRepository();
});

final announcementsProvider = FutureProvider<List<Announcement>>((ref) async {
  final repository = ref.watch(announcementRepositoryProvider);
  return repository.getAnnouncements();
});
