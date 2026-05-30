import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_model.dart';

class CourseService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<CourseModel>> fetchCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => CourseModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load courses from API (Status: ${response.statusCode})');
    }
  }

  Future<CourseModel> createCourse(String title, String description) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'title': title,
        'body': description,
        'userId': 1,
      }),
    );
    if (response.statusCode == 201) {
      return CourseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create course on API (Status: ${response.statusCode})');
    }
  }

  Future<CourseModel> updateCourse(int id, String title, String description) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'id': id,
        'title': title,
        'body': description,
        'userId': 1,
      }),
    );
    if (response.statusCode == 200) {
      return CourseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update course on API (Status: ${response.statusCode})');
    }
  }

  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete course on API (Status: ${response.statusCode})');
    }
  }
}
