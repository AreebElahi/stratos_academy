import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/course_controller.dart';
import '../models/course_model.dart';
import 'theme/app_theme.dart';
import 'widgets/glass_panel.dart';
import 'login_screen.dart';
import 'course_detail_screen.dart';
import 'notifications_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseController>().fetchCourses();
    });
  }

  void _logout(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    authController.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final authController = Provider.of<AuthController>(context);
    final courseController = Provider.of<CourseController>(context);
    final displayName = authController.currentUser?.fullName ?? "Student";
    final registeredCourses = courseController.courses
        .where((c) => courseController.registeredCourseIds.contains(c.id))
        .toList();

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
              title: Row(
                children: [
                  Container(
                    width: isMobile ? 32 : 40,
                    height: isMobile ? 32 : 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                      image: const DecorationImage(
                        image: NetworkImage("https://picsum.photos/seed/user/200"),
                        fit: BoxFit.cover,
                      )
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Stratos Academy",
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: isMobile ? 14 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Text(
                        "STUDENT PORTAL",
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: Colors.blueGrey[400],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                if (!isMobile)
                  TextButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout, size: 14, color: AppTheme.onSurface),
                    label: const Text("Logout", style: TextStyle(color: AppTheme.onSurface, fontSize: 12, fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.surfaceContainerHighest.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.logout, color: AppTheme.onSurface),
                    onPressed: () => _logout(context),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Badge(
                    child: Icon(Icons.notifications, color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                  },
                ),
                SizedBox(width: isMobile ? 4 : 16),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100, left: 24, right: 24, bottom: 100),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1024),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontFamily: 'Space Grotesk', fontSize: isMobile ? 28 : 36, fontWeight: FontWeight.bold, color: AppTheme.onSurface),
                    children: [
                      const TextSpan(text: "Welcome, "),
                      TextSpan(text: displayName, style: const TextStyle(color: AppTheme.primary)),
                    ]
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  courseController.isLoading 
                      ? "Loading your academic dashboard..."
                      : "You are currently registered in ${registeredCourses.length} course${registeredCourses.length == 1 ? '' : 's'}.",
                  style: TextStyle(fontFamily: 'Manrope', fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.w500, color: AppTheme.onSurfaceVariant),
                ),
                const SizedBox(height: 40),

                // Subject Cards Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Active Courses", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text(
                      "(JSONPlaceholder API)",
                      style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Course List
                if (courseController.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48.0),
                      child: CircularProgressIndicator(color: AppTheme.primary),
                    ),
                  )
                else if (courseController.errorMessage != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, color: AppTheme.errorColor, size: 36),
                          const SizedBox(height: 12),
                          Text(
                            "Failed to load courses: ${courseController.errorMessage}",
                            style: const TextStyle(color: AppTheme.errorColor, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else if (registeredCourses.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.05)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.school, color: AppTheme.primary, size: 36),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "No Enrolled Courses",
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "You are not registered in any courses yet. Navigate to the 'Courses' tab below to view and enroll in academic courses.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: registeredCourses
                        .map((course) => _buildCourseCardWrapper(context, isMobile, course))
                        .toList(),
                  ),
                
                const SizedBox(height: 40),

                // Stats Section
                GlassPanel(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ACADEMIC PERFORMANCE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppTheme.primary.withOpacity(0.7))),
                            const SizedBox(height: 8),
                            const Text("Excellence Index: 3.82 GPA", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Icon(Icons.show_chart, color: AppTheme.primary, size: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCardWrapper(BuildContext context, bool isMobile, CourseModel course) {
    return SizedBox(
      width: isMobile ? double.infinity : (1024 - 48 - 32) / 3,
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailScreen(
          course: course,
        ))),
        child: _buildCourseCard(
          icon: course.icon,
          title: course.title,
          desc: course.description,
          progress: 0.65 + (course.id % 5) * 0.05, // mock progress based on ID
          color: course.primaryColor,
          status: "ENROLLED",
        ),
      ),
    );
  }

  Widget _buildCourseCard({required IconData icon, required String title, required String desc, required double progress, required Color color, required String status}) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: 280, // Keep height consistent for wrap items
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color, letterSpacing: 1)),
              )
            ],
          ),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Expanded(
            child: Text(desc, style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("PROGRESS", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
              Text("${(progress * 100).toInt()}%", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.surfaceContainerLowest,
            color: color,
            borderRadius: BorderRadius.circular(8),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
