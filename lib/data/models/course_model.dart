class Course {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
  });

  factory Course.fromFirestore(String id, Map<String, dynamic> data) {
    return Course(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      duration: data['duration'] ?? '',
    );
  }
}