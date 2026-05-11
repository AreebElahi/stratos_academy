import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                icon: const Icon(Icons.arrow_back, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text("Notifications", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text("Mark all as read", style: TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 40),
        children: [
          _buildNotificationGroup("TODAY"),
          _buildNotificationItem(
            icon: Icons.assignment_late,
            color: AppTheme.errorColor,
            title: "Assignment Due Soon",
            desc: "UX Research Quiz is due in 2 hours.",
            time: "2m ago",
            isNew: true,
          ),
          _buildNotificationItem(
            icon: Icons.grade,
            color: AppTheme.tertiary,
            title: "Grade Posted",
            desc: "Your grade for Mobile App Dev Milestone 1 is available.",
            time: "1h ago",
            isNew: true,
          ),
          const SizedBox(height: 24),
          _buildNotificationGroup("YESTERDAY"),
          _buildNotificationItem(
            icon: Icons.forum,
            color: AppTheme.primary,
            title: "New Announcement",
            desc: "Prof. Vane posted an update regarding the mid-terms.",
            time: "1d ago",
            isNew: false,
          ),
          _buildNotificationItem(
            icon: Icons.system_update,
            color: Colors.blueGrey,
            title: "System Update",
            desc: "Stratos Academy portal will be under maintenance at 2 AM.",
            time: "1d ago",
            isNew: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationGroup(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey),
      ),
    );
  }

  Widget _buildNotificationItem({required IconData icon, required Color color, required String title, required String desc, required String time, required bool isNew}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNew ? color.withOpacity(0.05) : AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isNew ? color.withOpacity(0.2) : Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: isNew ? FontWeight.bold : FontWeight.w500, color: Colors.white)),
                    Text(time, style: TextStyle(fontSize: 10, color: isNew ? color : Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
