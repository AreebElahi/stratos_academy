import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'theme/app_theme.dart';
import 'widgets/glass_panel.dart';
import 'login_screen.dart';
import 'course_detail_screen.dart';
import 'notifications_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
    final controller = Provider.of<AuthController>(context);
    final displayName = controller.currentUser?.fullName ?? "Student";

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
                  "You have 3 lectures today and 1 pending assignment.",
                  style: TextStyle(fontFamily: 'Manrope', fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.w500, color: AppTheme.onSurfaceVariant),
                ),
                const SizedBox(height: 40),

                // Subject Cards Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Active Courses", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 20, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: isMobile ? const SizedBox() : const Text("View All"),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                
                // Course List
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildCourseCardWrapper(
                      context,
                      isMobile,
                      title: "Mobile App Development",
                      desc: "Comprehensive study of mobile ecosystems and cross-platform development.",
                      icon: Icons.smartphone,
                      color: AppTheme.primary,
                      schedule: "Mon, Wed • 10:00 AM",
                    ),
                    _buildCourseCardWrapper(
                      context,
                      isMobile,
                      title: "Software Re-engineering",
                      desc: "Advanced techniques for legacy system modernization and refactoring.",
                      icon: Icons.settings_backup_restore,
                      color: AppTheme.errorColor,
                      schedule: "Tue, Thu • 02:00 PM",
                    ),
                    _buildCourseCardWrapper(
                      context,
                      isMobile,
                      title: "Management Information Systems (MIS)",
                      desc: "Strategic application of IT systems in modern business environments.",
                      icon: Icons.business_center,
                      color: AppTheme.tertiary,
                      schedule: "Fri • 09:00 AM",
                    ),
                  ],
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

  Widget _buildCourseCardWrapper(BuildContext context, bool isMobile, {
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required String schedule,
  }) {
    return SizedBox(
      width: isMobile ? double.infinity : (1024 - 48 - 32) / 3,
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailScreen(
          title: title,
          description: desc,
          schedule: schedule,
          primaryColor: color,
        ))),
        child: _buildCourseCard(
          icon: icon,
          title: title,
          desc: desc,
          progress: 0.65,
          color: color,
          status: "ENROLLED",
        ),
      ),
    );
  }

  Widget _buildCourseCard({required IconData icon, required String title, required String desc, required double progress, required Color color, required String status}) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Text(title, style: const TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 24),
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
