import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'course_detail_screen.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              backgroundColor: const Color(0xFF020617).withOpacity(0.6),
              elevation: 0,
              automaticallyImplyLeading: false,
              title: const Text("Academic Courses", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primary)),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 100, left: 24, right: 24, bottom: 120),
        children: [
          _buildCourseListItem(
            context,
            title: "Mobile App Development",
            desc: "Comprehensive study of mobile ecosystems and cross-platform development.",
            icon: Icons.smartphone,
            color: AppTheme.primary,
            schedule: "Mon, Wed • 10:00 AM",
          ),
          const SizedBox(height: 16),
          _buildCourseListItem(
            context,
            title: "Software Re-engineering",
            desc: "Advanced techniques for legacy system modernization and refactoring.",
            icon: Icons.settings_backup_restore,
            color: AppTheme.errorColor,
            schedule: "Tue, Thu • 02:00 PM",
          ),
          const SizedBox(height: 16),
          _buildCourseListItem(
            context,
            title: "Management Information Systems (MIS)",
            desc: "Strategic application of IT systems in modern business environments.",
            icon: Icons.business_center,
            color: AppTheme.tertiary,
            schedule: "Fri • 09:00 AM",
          ),
        ],
      ),
    );
  }

  Widget _buildCourseListItem(BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required String schedule,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailScreen(
        title: title,
        description: desc,
        schedule: schedule,
        primaryColor: color,
      ))),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(desc, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12, color: color),
                      const SizedBox(width: 4),
                      Text(schedule, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
                    ],
                  )
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
