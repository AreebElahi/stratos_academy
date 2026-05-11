import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

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
              title: const Text("Knowledge Vault", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.tertiary)),
              actions: [
                IconButton(icon: const Icon(Icons.search, color: Colors.grey), onPressed: () {}),
                IconButton(icon: const Icon(Icons.filter_list, color: Colors.grey), onPressed: () {}),
                const SizedBox(width: 8),
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
                const Text("Recent Files", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFileCard("System_Arch.pdf", "Mobile App Dev", AppTheme.errorColor, Icons.picture_as_pdf),
                      const SizedBox(width: 16),
                      _buildFileCard("Ch4_Notes.docx", "UX Research", AppTheme.primary, Icons.description),
                      const SizedBox(width: 16),
                      _buildFileCard("DB_Schema.png", "Re-engineering", AppTheme.tertiary, Icons.image),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                const Text("Folders", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _buildFolderCard("Lectures", "42 files", AppTheme.primary),
                        _buildFolderCard("Assignments", "15 files", AppTheme.errorColor),
                        _buildFolderCard("Projects", "8 files", AppTheme.tertiary),
                        _buildFolderCard("Resources", "120 files", Colors.amberAccent),
                        _buildFolderCard("Syllabus", "4 files", Colors.tealAccent),
                        _buildFolderCard("Misc", "2 files", Colors.grey),
                      ],
                    );
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileCard(String name, String subject, Color color, IconData icon) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        // Ghost Border Fallback
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Space Grotesk')),
              const SizedBox(height: 4),
              Text(subject.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.onSurfaceVariant.withOpacity(0.6), letterSpacing: 1)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFolderCard(String name, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow, // Solid shift
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.folder, color: color, size: 36),
          const Spacer(),
          Text(name, style: const TextStyle(fontFamily: 'Space Grotesk', fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(count, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
