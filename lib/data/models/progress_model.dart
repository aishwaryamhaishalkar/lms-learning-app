class Progress {
  final String courseId;
  final String courseTitle;
  final int score;
  final int totalQuestions;

  Progress({
    required this.courseId,
    required this.courseTitle,
    required this.score,
    required this.totalQuestions,
  });

  factory Progress.fromFirestore(Map<String, dynamic> data) {
    return Progress(
      courseId: data['courseId'] ?? '',
      courseTitle: data['courseTitle'] ?? '',
      score: data['score'] ?? 0,
      totalQuestions: data['totalQuestions'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'courseTitle': courseTitle,
      'score': score,
      'totalQuestions': totalQuestions,
      'completedAt': DateTime.now().toIso8601String(),
    };
  }
}