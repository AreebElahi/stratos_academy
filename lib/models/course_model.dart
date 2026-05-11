import 'package:flutter/material.dart';

class CourseModel {
  final String title;
  final String description;
  final String schedule;
  final Color primaryColor;
  final IconData icon;

  CourseModel({
    required this.title,
    required this.description,
    required this.schedule,
    required this.primaryColor,
    required this.icon,
  });
}
