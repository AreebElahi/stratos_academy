import 'package:flutter/material.dart';
import 'dart:math';
import '../models/course_model.dart';
import '../services/course_service.dart';

class CourseController extends ChangeNotifier {
  final CourseService _service = CourseService();

  List<CourseModel> _courses = [];
  List<CourseModel> get courses => _courses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _actionErrorMessage;
  String? get actionErrorMessage => _actionErrorMessage;

  Future<void> fetchCourses({bool force = false}) async {
    // Avoid double fetching if we already have data, unless forced
    if (_courses.isNotEmpty && !force) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _courses = await _service.fetchCourses();
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> addCourse(String title, String description) async {
    _isActionLoading = true;
    _actionErrorMessage = null;
    notifyListeners();

    try {
      final newCourse = await _service.createCourse(title, description);
      
      // Since JSONPlaceholder always returns id: 101, check if we already have it.
      // If so, assign a unique local ID.
      int localId = newCourse.id;
      if (_courses.any((c) => c.id == localId)) {
        localId = _courses.map((c) => c.id).reduce(max) + 1;
      }
      
      final courseToAdd = newCourse.copyWith(id: localId);
      _courses.insert(0, courseToAdd); // Show the new course at the top
      
      _isActionLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isActionLoading = false;
      _actionErrorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCourse(int id, String title, String description) async {
    _isActionLoading = true;
    _actionErrorMessage = null;
    notifyListeners();

    try {
      // If updating a custom locally added post (ID > 100), JSONPlaceholder will 404.
      // So we hit post 1 on the API for demo purposes, but modify the correct ID locally.
      final apiId = id > 100 ? 1 : id;
      await _service.updateCourse(apiId, title, description);

      final index = _courses.indexWhere((c) => c.id == id);
      if (index != -1) {
        _courses[index] = _courses[index].copyWith(
          title: title,
          description: description,
        );
      }
      _isActionLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isActionLoading = false;
      _actionErrorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCourse(int id) async {
    _isActionLoading = true;
    _actionErrorMessage = null;
    notifyListeners();

    try {
      // If deleting a custom locally added post (ID > 100), JSONPlaceholder will 404.
      // So we hit post 1 on the API for demo purposes, but delete the correct ID locally.
      final apiId = id > 100 ? 1 : id;
      await _service.deleteCourse(apiId);

      _courses.removeWhere((c) => c.id == id);
      _isActionLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isActionLoading = false;
      _actionErrorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
