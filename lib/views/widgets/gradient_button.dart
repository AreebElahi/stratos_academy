import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const GradientButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isEnabled 
          ? const LinearGradient(
              colors: [AppTheme.primary, AppTheme.primaryDim],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : LinearGradient(
              colors: [AppTheme.outline.withOpacity(0.2), AppTheme.outline.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        boxShadow: isEnabled ? [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isEnabled ? onPressed : null,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Color(0xFF001C8E),
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? const Color(0xFF001C8E) : AppTheme.outline, // on_primary spec
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
