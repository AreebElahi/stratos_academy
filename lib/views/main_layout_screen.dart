import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'tasks_screen.dart';
import 'vault_screen.dart';
import 'courses_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CoursesScreen(),
    const TasksScreen(),
    const VaultScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
       // Just showing it's possible to tap but not fully implemented, or we can just redirect to index 0 
       // We'll leave index 1 as a placeholder view
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 80,
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: const Color(0xFF020617).withOpacity(0.8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 24, offset: const Offset(0, -8))
          ]
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.dashboard, "Dashboard", 0),
                _buildNavItem(Icons.auto_stories, "Courses", 1),
                _buildNavItem(Icons.checklist, "Tasks", 2),
                _buildNavItem(Icons.folder_special, "Vault", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 80,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isActive ? 8 : 0),
              decoration: BoxDecoration(
                color: isActive ? Colors.blueAccent.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isActive ? Colors.blueAccent : Colors.grey, size: isActive ? 28 : 24),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? Colors.blueAccent : Colors.grey)),
          ],
        ),
      ),
    );
  }
}
