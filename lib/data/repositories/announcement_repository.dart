import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/announcement_model.dart';

class AnnouncementRepository {
  // REST API call — Flutter ke latest official updates fetch karne ke liye
  // (GitHub's public API, koi authentication/key ki zaroorat nahi)
  Future<List<Announcement>> getAnnouncements() async {
    final response = await http.get(
      Uri.parse('https://api.github.com/repos/flutter/flutter/releases?per_page=3'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Announcement.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load announcements');
    }
  }
}