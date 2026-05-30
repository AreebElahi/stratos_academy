import 'package:flutter/material.dart';

class CourseModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  
  // UI-only properties that are generated dynamically
  final String schedule;
  final Color primaryColor;
  final IconData icon;

  CourseModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.schedule,
    required this.primaryColor,
    required this.icon,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] ?? 0;
    return CourseModel(
      id: id,
      userId: json['userId'] ?? 1,
      title: json['title'] ?? '',
      description: json['body'] ?? '',
      schedule: _getScheduleForId(id),
      primaryColor: _getColorForId(id),
      icon: _getIconForId(id),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': description,
    };
  }

  CourseModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    String? schedule,
    Color? primaryColor,
    IconData? icon,
  }) {
    return CourseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      schedule: schedule ?? this.schedule,
      primaryColor: primaryColor ?? this.primaryColor,
      icon: icon ?? this.icon,
    );
  }

  static String _getScheduleForId(int id) {
    final schedules = [
      "Mon, Wed • 10:00 AM",
      "Tue, Thu • 02:00 PM",
      "Fri • 09:00 AM",
      "Mon, Thu • 11:30 AM",
      "Tue, Fri • 04:00 PM",
      "Wed • 01:00 PM",
    ];
    return schedules[id % schedules.length];
  }

  static Color _getColorForId(int id) {
    final colors = [
      const Color(0xFF6366F1), // Indigo/Primary
      const Color(0xFFEF4444), // Red/Error
      const Color(0xFF10B981), // Emerald/Success
      const Color(0xFFF59E0B), // Amber/Warning
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFEC4899), // Pink
      const Color(0xFF06B6D4), // Cyan
    ];
    return colors[id % colors.length];
  }

  static IconData _getIconForId(int id) {
    final icons = [
      Icons.smartphone,
      Icons.settings_backup_restore,
      Icons.business_center,
      Icons.code,
      Icons.science,
      Icons.calculate,
      Icons.terminal,
      Icons.palette,
      Icons.psychology,
    ];
    return icons[id % icons.length];
  }
}
