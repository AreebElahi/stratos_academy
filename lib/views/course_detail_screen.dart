import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

class CourseDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String category;
  final String bannerUrl;
  final String professor;
  final String level;
  final String schedule;
  final Color primaryColor;

  const CourseDetailScreen({
    super.key,
    this.title = "Mobile App Development",
    this.description = "Dive into the architecture and ecosystem of modern mobile platforms. This course covers everything from cross-platform development with Flutter to native Android and iOS paradigms.\n\nStudents will engage in end-to-end product development, starting from UX wireframing in Figma to deploying high-performance applications on the App Store and Google Play.",
    this.category = "ENGINEERING & DESIGN • SEM 2",
    this.bannerUrl = "https://picsum.photos/seed/course_details/1200/600",
    this.professor = "Prof. Julian Vane",
    this.level = "Level 400",
    this.schedule = "Tue & Thu • 02:00 PM — 03:30 PM",
    this.primaryColor = AppTheme.primary,
  });

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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text("COURSE DETAILS", style: TextStyle(fontFamily: 'Manrope', fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.blueAccent)),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner & Header Section
            SizedBox(
              height: 450,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    bannerUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppTheme.background,
                          AppTheme.background.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 24,
                    right: 24,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1024),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: primaryColor.withOpacity(0.3)),
                              ),
                              child: Text(category, style: TextStyle(color: primaryColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'Space Grotesk',
                                fontSize: isMobile ? 36 : 56,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                _buildHeaderBadge(Icons.person_outline, professor),
                                const SizedBox(width: 16),
                                _buildHeaderBadge(Icons.trending_up, level),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            // Content Section
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1024),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 32, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: isMobile ? 1 : 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle("Course Overview"),
                                Text(
                                  description,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.8,
                                    color: AppTheme.onSurfaceVariant.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 48),
                                _buildSectionTitle("Learning Outcomes"),
                                _buildOutcomeItem("Master cross-platform architecture with Flutter and Dart."),
                                _buildOutcomeItem("Implement advanced state management and reactive patterns."),
                                _buildOutcomeItem("Integrate robust backend services and cloud APIs."),
                                _buildOutcomeItem("Design high-fidelity interactive prototypes in Figma."),
                                const SizedBox(height: 48),
                                _buildSectionTitle("Curriculum & Syllabus"),
                                _buildSyllabusItem("01", "Foundation of Mobile Ecosystems", "Introduction to ARM architecture and OS kernels."),
                                _buildSyllabusItem("02", "Reactive UI & Layout Systems", "Deep dive into the Flutter rendering pipeline."),
                                _buildSyllabusItem("03", "Data Persistence & Cloud Sync", "SQLite, Hive, and Firebase Realtime integration."),
                                _buildSyllabusItem("04", "Performance Optimization", "Memory management, profiling, and jank reduction."),
                              ],
                            ),
                          ),
                          if (!isMobile) ...[
                            const SizedBox(width: 64),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  _buildSidePanel(),
                                  const SizedBox(height: 32),
                                  _buildProfessorCard(),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (isMobile) ...[
                        const SizedBox(height: 48),
                        _buildSidePanel(),
                        const SizedBox(height: 32),
                        _buildProfessorCard(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildOutcomeItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15, height: 1.5))),
        ],
      ),
    );
  }

  Widget _buildSyllabusItem(String number, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(number, style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor.withOpacity(0.3))),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfessorCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: const NetworkImage("https://picsum.photos/seed/professor/200"),
            backgroundColor: primaryColor.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          Text(professor, style: const TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("Senior Engineering Fellow", style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          Text(
            "An industry veteran with 15+ years of experience in distributed systems and mobile architecture.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.5, color: AppTheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: TextStyle(fontFamily: 'Manrope', fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2, color: primaryColor)),
          const SizedBox(height: 8),
          Container(width: 40, height: 3, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(2))),
        ],
      ),
    );
  }

  Widget _buildSidePanel() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 40, offset: const Offset(0, 20))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Schedule Information", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildInfoRow(Icons.timer_outlined, "Class Timing", schedule),
          const SizedBox(height: 24),
          _buildInfoRow(Icons.location_on_outlined, "Location", "Academic Building • Room 402"),
          const SizedBox(height: 24),
          _buildInfoRow(Icons.assignment_turned_in_outlined, "Requirements", "90% Attendance Required"),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [primaryColor, primaryColor.withOpacity(0.7)]),
              boxShadow: [
                BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
              ]
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {},
              child: const Text("Register for Course", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4)),
            ],
          ),
        )
      ],
    );
  }
}
