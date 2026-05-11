import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/glass_panel.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class TaskItem {
  final String title;
  final String desc;
  final String time;
  final double progress;
  final Color color;
  final IconData icon;
  final String type;

  TaskItem({
    required this.title,
    required this.desc,
    required this.time,
    required this.progress,
    required this.color,
    required this.icon,
    required this.type,
  });
}

class _TasksScreenState extends State<TasksScreen> {
  int selectedTab = 0;

  final List<TaskItem> allTasks = [
    TaskItem(
      title: "UX Research Quiz", 
      desc: "Review chapters 4-6 for adaptive testing algorithm.", 
      time: "Due in 2 hours", 
      progress: 0.0, 
      color: AppTheme.errorColor, 
      icon: Icons.assessment,
      type: "assessment",
    ),
    TaskItem(
      title: "Mobile App Development: Milestone 2", 
      desc: "Integrate Firebase Auth and complete login screen.", 
      time: "Due tomorrow", 
      progress: 0.65, 
      color: AppTheme.primary, 
      icon: Icons.smartphone,
      type: "project",
    ),
    TaskItem(
      title: "System Architecture Diagram", 
      desc: "Draft high-level microservices flow for retail app.", 
      time: "Due in 3 days", 
      progress: 0.2, 
      color: Colors.amberAccent, 
      icon: Icons.architecture,
      type: "project",
    ),
  ];

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
              automaticallyImplyLeading: false,
              title: const Text("Task Matrix", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primary)),
              actions: [
                IconButton(icon: const Icon(Icons.add_circle, color: AppTheme.primary, size: 28), onPressed: () {}),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100, left: 24, right: 24, bottom: 120),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1024),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats
                Row(
                  children: [
                    Expanded(child: _buildTaskStat("12", "Pending", AppTheme.errorColor)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTaskStat("4", "In Progress", AppTheme.primary)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTaskStat("28", "Completed", AppTheme.tertiary)),
                  ],
                ),
                const SizedBox(height: 32),

                // Tabs
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildTab("All", 0),
                    _buildTab("Assessments", 1),
                    _buildTab("Projects", 2),
                  ],
                ),
                const SizedBox(height: 24),

                // List
                ..._buildTaskList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTaskList() {
    // Fallback in case of hot-reload corruption of final fields
    final safeTasks = allTasks; 
    
    List<TaskItem> filteredTasks = [];
    if (selectedTab == 0) {
      filteredTasks = safeTasks;
    } else if (selectedTab == 1) {
      filteredTasks = safeTasks.where((t) => t.type == "assessment").toList();
    } else if (selectedTab == 2) {
      filteredTasks = safeTasks.where((t) => t.type == "project").toList();
    }

    if (filteredTasks.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: Text("No tasks found in this category.", style: TextStyle(color: Colors.grey))),
        )
      ];
    }

    return filteredTasks.map((t) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _buildTaskCard(t.title, t.desc, t.time, t.progress, t.color, t.icon),
    )).toList();
  }

  Widget _buildTaskStat(String count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(count, style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          Text(
            label.toUpperCase(), 
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: isSelected ? AppTheme.primary : Colors.white10),
        ),
        child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF001C8E) : Colors.grey)),
      ),
    );
  }

  Widget _buildTaskCard(String title, String desc, String time, double progress, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(title, style: const TextStyle(fontFamily: 'Space Grotesk', fontSize: 18, fontWeight: FontWeight.bold))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(time, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(desc, style: const TextStyle(fontSize: 14, color: AppTheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                if (progress > 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Progress", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.background,
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    minHeight: 4,
                  ),
                ]
              ],
            ),
          )
        ],
      ),
    );
  }
}
