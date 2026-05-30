import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'course_detail_screen.dart';
import '../controllers/course_controller.dart';
import '../models/course_model.dart';
import '../utils/validators/app_validators.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseController>().fetchCourses();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditCourseSheet({CourseModel? course}) {
    final isEditing = course != null;
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: course?.title ?? '');
    final descController = TextEditingController(text: course?.description ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: const Border(
                  top: BorderSide(color: Colors.white10),
                  left: BorderSide(color: Colors.white10),
                  right: BorderSide(color: Colors.white10),
                ),
              ),
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 40,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isEditing ? "Edit Course Details" : "Create New Course",
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isEditing
                            ? "Modify fields below to update course information."
                            : "Enter the details to add a new course to Stratos Academy.",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Course Title
                      const Text(
                        "Course Title",
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: "e.g. Advanced Embedded Systems",
                          prefixIcon: Icon(Icons.title, color: AppTheme.outline),
                        ),
                        validator: (value) => AppValidators.requiredFieldValidator(value, 'Course Title'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 24),

                      // Description
                      const Text(
                        "Description / Course Overview",
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: descController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: "Enter comprehensive course outline or syllabus details...",
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 56.0),
                            child: Icon(Icons.description, color: AppTheme.outline),
                          ),
                          alignLabelWithHint: true,
                        ),
                        validator: (value) => AppValidators.requiredFieldValidator(value, 'Course Description'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 32),

                      // Submit Button
                      Consumer<CourseController>(
                        builder: (context, controller, child) {
                          return Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: [AppTheme.primary, Color(0xFF8B5CF6)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                )
                              ]
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: controller.isActionLoading
                                  ? null
                                  : () async {
                                      if (formKey.currentState?.validate() ?? false) {
                                        bool success;
                                        if (isEditing) {
                                          success = await controller.updateCourse(
                                            course.id,
                                            titleController.text.trim(),
                                            descController.text.trim(),
                                          );
                                        } else {
                                          success = await controller.addCourse(
                                            titleController.text.trim(),
                                            descController.text.trim(),
                                          );
                                        }

                                        if (success && context.mounted) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                isEditing
                                                    ? 'Course updated successfully!'
                                                    : 'Course created successfully!',
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              backgroundColor: AppTheme.primary,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                          );
                                        } else if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                controller.actionErrorMessage ?? 'An error occurred. Please try again.',
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              backgroundColor: AppTheme.errorColor,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                          );
                                        }
                                      }
                                    },
                              child: controller.isActionLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(
                                      isEditing ? "Save Changes" : "Create Course",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteCourse(CourseModel course) {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            backgroundColor: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Colors.white10),
            ),
            title: Row(
              children: const [
                Icon(Icons.warning_amber_rounded, color: AppTheme.errorColor, size: 28),
                SizedBox(width: 12),
                Text(
                  "Confirm Deletion",
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            content: Text(
              "Are you sure you want to delete course ID ${course.id}: \"${course.title}\"? This action will make a mock DELETE call to the JSONPlaceholder API and update the local state.",
              style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
              Consumer<CourseController>(
                builder: (context, controller, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: controller.isActionLoading
                        ? null
                        : () async {
                            final success = await controller.deleteCourse(course.id);
                            if (success && context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Course deleted successfully!',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: AppTheme.errorColor,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    controller.actionErrorMessage ?? 'Failed to delete course.',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: AppTheme.errorColor,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            }
                          },
                    child: controller.isActionLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CourseController>();

    // Filter courses based on search query
    final filteredCourses = controller.courses.where((c) {
      final query = _searchQuery.toLowerCase();
      return c.title.toLowerCase().contains(query) ||
          c.description.toLowerCase().contains(query) ||
          c.id.toString().contains(query);
    }).toList();

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
              title: const Text(
                "Academic Courses",
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: AppTheme.primary, size: 28),
                  onPressed: () => _showAddEditCourseSheet(),
                  tooltip: "Add Course",
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Glow Decoration
          Positioned(
            top: 100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.03),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          if (controller.isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.primary),
                  SizedBox(height: 16),
                  Text(
                    "Establishing Link to JSONPlaceholder...",
                    style: TextStyle(
                      color: AppTheme.onSurfaceVariant,
                      fontSize: 14,
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          else if (controller.errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.cloud_off, color: AppTheme.errorColor, size: 48),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Uplink Failed",
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        "Retry Connection",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => controller.fetchCourses(force: true),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                // Search Bar Section
                Padding(
                  padding: const EdgeInsets.only(top: 104, left: 24, right: 24, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.05)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Search courses by title, body or ID...",
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),

                // Courses List
                Expanded(
                  child: RefreshIndicator(
                    color: AppTheme.primary,
                    backgroundColor: const Color(0xFF0F172A),
                    onRefresh: () => controller.fetchCourses(force: true),
                    child: filteredCourses.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                              Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      _searchQuery.isNotEmpty ? Icons.search_off : Icons.school_outlined,
                                      color: Colors.white24,
                                      size: 64,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _searchQuery.isNotEmpty
                                          ? "No search results match \"$_searchQuery\""
                                          : "No courses available.",
                                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
                            itemCount: filteredCourses.length,
                            itemBuilder: (context, index) {
                              final course = filteredCourses[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: _buildCourseListItem(context, course),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: !controller.isLoading && controller.errorMessage == null
          ? Container(
              margin: const EdgeInsets.only(bottom: 80), // Keep it above the bottom navbar
              child: FloatingActionButton(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onPressed: () => _showAddEditCourseSheet(),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            )
          : null,
    );
  }

  Widget _buildCourseListItem(BuildContext context, CourseModel course) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CourseDetailScreen(course: course),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
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
              decoration: BoxDecoration(
                color: course.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(course.icon, color: course.primaryColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: course.primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "ID ${course.id}",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: course.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          course.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12, color: course.primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        course.schedule,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: course.primaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey, size: 20),
                  onPressed: () => _showAddEditCourseSheet(course: course),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                  tooltip: "Edit Course",
                ),
                const SizedBox(height: 12),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppTheme.errorColor, size: 20),
                  onPressed: () => _confirmDeleteCourse(course),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                  tooltip: "Delete Course",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
