class Announcement {
  final String title;
  final String body;

  Announcement({required this.title, required this.body});

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      title: json['name'] ?? json['tag_name'] ?? 'Flutter Update',
      body: (json['body'] ?? 'New release available').toString().split('\n').first,
    );
  }
}