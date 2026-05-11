import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  
  const GlassPanel({super.key, required this.child, this.padding = const EdgeInsets.all(32)});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.1)),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
