import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/course_provider.dart';
import '../providers/announcement_provider.dart';
import '../providers/progress_provider.dart';
import '../../auth/providers/auth_provider.dart';
import 'course_detail_screen.dart';
import '../../auth/screens/login_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesStreamProvider);
    final announcementsAsync = ref.watch(announcementsProvider);
    final progressAsync = ref.watch(progressStreamProvider);
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.user == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Text('My Courses', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Announcements Section (REST API) ----------
            const Text(
              'Announcements',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            announcementsAsync.when(
              data: (announcements) => SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final a = announcements[index];
                    return Container(
                      width: 220,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2979FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2979FF).withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            a.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              loading: () => const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator(color: Color(0xFF2979FF))),
              ),
              error: (e, s) => const SizedBox(
                height: 40,
                child: Center(child: Text('Could not load announcements', style: TextStyle(color: Colors.white38))),
              ),
            ),

            const SizedBox(height: 28),

            // ---------- My Progress Section (Firestore) ----------
            const Text(
              'My Progress',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            progressAsync.when(
              data: (progressList) {
                if (progressList.isEmpty) {
                  return const Text(
                    'No quizzes attempted yet',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  );
                }
                return Column(
                  children: progressList.map((p) {
                    final percent = (p.score / p.totalQuestions * 100).round();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(p.courseTitle, style: const TextStyle(color: Colors.white)),
                          ),
                          Text(
                            '$percent%',
                            style: const TextStyle(color: Color(0xFF2979FF), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const CircularProgressIndicator(color: Color(0xFF2979FF)),
              error: (e, s) => const Text('Could not load progress', style: TextStyle(color: Colors.white38)),
            ),

            const SizedBox(height: 28),

            // ---------- Courses List ----------
            const Text(
              'Courses',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            coursesAsync.when(
              data: (courses) {
                if (courses.isEmpty) {
                  return const Text('No courses available', style: TextStyle(color: Colors.white70));
                }
                return Column(
                  children: courses.map((course) {
                    return Card(
                      color: Colors.white.withOpacity(0.05),
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: course.thumbnailUrl,
                                  width: 90,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(width: 90, height: 70, color: Colors.white10),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(course.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text(
                                      course.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.white60, fontSize: 13),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 14, color: Colors.white38),
                                        const SizedBox(width: 4),
                                        Text(course.duration, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF2979FF))),
              error: (error, stack) => Center(child: Text('Error: $error', style: const TextStyle(color: Colors.redAccent))),
            ),
          ],
        ),
      ),
            ),
        ),
    );
  }
}