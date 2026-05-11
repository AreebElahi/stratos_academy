import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../models/enums.dart';
import 'theme/app_theme.dart';
import 'login_screen.dart';
import 'main_layout_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // Wait for a minimum time for the animation/splash to show
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    final authController = Provider.of<AuthController>(context, listen: false);
    
    // If the auth controller is still loading, we wait for it to finish
    if (authController.authState == AppState.loading || authController.authState == AppState.initial) {
      // We can use a listener or just wait briefly. 
      // For simplicity in a basic app, we'll wait for the next frame or check again.
      // Better: we wait until the state is no longer initial/loading.
      while (authController.authState == AppState.loading || authController.authState == AppState.initial) {
        await Future.delayed(const Duration(milliseconds: 200));
        if (!mounted) return;
      }
    }

    if (authController.authState == AppState.authenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainLayoutScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(painter: GridPainter()),
            ),
          ),
          // Ambient Glow
          Center(
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withOpacity(0.05),
                boxShadow: [
                  BoxShadow(color: AppTheme.primary.withOpacity(0.1), blurRadius: 120, spreadRadius: 60),
                ],
              ),
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Mark
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ScaleTransition(
                      scale: _animation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primary.withOpacity(0.2),
                          boxShadow: [
                            BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 60, spreadRadius: 10),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 40, spreadRadius: -10),
                        ]
                      ),
                      child: const Icon(Icons.rocket_launch, color: AppTheme.primary, size: 48),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                
                // Brand Typography
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.onSurface, letterSpacing: 2),
                    children: [
                      TextSpan(text: "STRATOS "),
                      TextSpan(text: "ACADEMY", style: TextStyle(color: AppTheme.primary)),
                    ]
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "THE ACADEMIC PULSE",
                  style: TextStyle(fontFamily: 'Manrope', fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 6, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Tech Elements (Desktop)
          Positioned(
            top: 48,
            left: 48,
            child: Opacity(
              opacity: 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("SYS_VER: 2.0.4_BETA", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 10, color: AppTheme.primary)),
                  Text("AUTH_TOKEN: VALIDATED", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 10, color: AppTheme.primary)),
                  Text("SYNC: ACTIVE", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 10, color: AppTheme.primary)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            right: 48,
            child: Opacity(
              opacity: 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text("ESTABLISHING UPLINK...", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 10, color: AppTheme.primary)),
                  Text("SECURE_SHELL_ACTIVE", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 10, color: AppTheme.primary)),
                  Text("© 2024 STRATOS GROUP", style: TextStyle(fontFamily: 'Space Grotesk', fontSize: 10, color: AppTheme.primary)),
                ],
              ),
            ),
          ),
          
          // Bottom Status section
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  width: 240,
                  height: 4,
                  decoration: BoxDecoration(color: AppTheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(2)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: const LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "INITIALIZING NEURAL GRID",
                  style: TextStyle(fontFamily: 'Manrope', fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 4, color: Colors.grey),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary
      ..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 32) {
      for (double j = 0; j < size.height; j += 32) {
        canvas.drawCircle(Offset(i, j), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
