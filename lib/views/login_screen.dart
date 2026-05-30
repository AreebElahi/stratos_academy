import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/enums.dart';
import '../utils/validators/app_validators.dart';
import 'theme/app_theme.dart';
import 'widgets/glass_panel.dart';
import 'widgets/gradient_button.dart';
import 'package:provider/provider.dart';
import 'main_layout_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LoginScreenBody();
  }
}

class _LoginScreenBody extends StatelessWidget {
  const _LoginScreenBody();

  void _handleLogin(BuildContext context) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final success = await authController.login();
    if (success && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainLayoutScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final controller = Provider.of<AuthController>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Ambient Light decoration
          Positioned(
            top: -size.height * 0.1,
            left: -size.width * 0.1,
            child: Container(
              width: size.width * 0.4,
              height: size.height * 0.4,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.05),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppTheme.primary.withOpacity(0.05), blurRadius: 120, spreadRadius: 0)
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -size.height * 0.1,
            right: -size.width * 0.1,
            child: Container(
              width: size.width * 0.4,
              height: size.height * 0.4,
              decoration: BoxDecoration(
                color: AppTheme.tertiary.withOpacity(0.05),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppTheme.tertiary.withOpacity(0.05), blurRadius: 120, spreadRadius: 0)
                ],
              ),
            ),
          ),

          Row(
            children: [
              // Main content (Form)
              Expanded(
                flex: 5,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 448), // max-w-md approx
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Brand Identity
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_stories,
                              color: AppTheme.primary,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Stratos Academy",
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "SECURE PERFORMANCE PORTAL",
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.5,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Form Panel
                          GlassPanel(
                            child: Form(
                              key: controller.loginFormKey,
                              onChanged: controller.validateLoginForm,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (controller.errorMessage != null) ...[
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppTheme.errorColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.error_outline, color: AppTheme.errorColor, size: 18),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(controller.errorMessage!, style: const TextStyle(color: AppTheme.errorColor, fontSize: 13))),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],

                                  // Email
                                  const Text(
                                    "Institutional Email",
                                    style: TextStyle(
                                      fontFamily: 'Space Grotesk',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: controller.emailController,
                                    decoration: const InputDecoration(
                                      hintText: "alex.pierce@academy.edu",
                                      prefixIcon: Icon(Icons.alternate_email, color: AppTheme.outline),
                                    ),
                                    validator: AppValidators.emailValidator,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                  ),
                                  const SizedBox(height: 24),

                                  // Password
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Security Key",
                                        style: TextStyle(
                                          fontFamily: 'Space Grotesk',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                        ),
                                        child: const Text(
                                          "Forgot Password?",
                                          style: TextStyle(
                                            color: AppTheme.primary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: controller.passwordController,
                                    obscureText: !controller.isPasswordVisible,
                                    decoration: InputDecoration(
                                      hintText: "••••••••",
                                      prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.outline),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                          color: AppTheme.outline,
                                        ),
                                        onPressed: controller.togglePasswordVisibility,
                                      ),
                                    ),
                                    validator: AppValidators.passwordValidator,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                  ),
                                  const SizedBox(height: 16),

                                  // Remember Me
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: controller.rememberMe,
                                          onChanged: controller.toggleRememberMe,
                                          activeColor: AppTheme.primary,
                                          checkColor: AppTheme.background,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Remember Me",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  GradientButton(
                                    text: "Login",
                                    onPressed: controller.isLoginFormValid ? () => _handleLogin(context) : null,
                                    isLoading: controller.authState == AppState.loading,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                "New to the system?",
                                style: TextStyle(
                                  color: AppTheme.onSurfaceVariant,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegistrationScreen()));
                                },
                                child: const Text(
                                  "Register Now",
                                  style: TextStyle(
                                    color: AppTheme.tertiary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Side Visual for Desktop
              if (isDesktop)
                Expanded(
                  flex: 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        "https://images.unsplash.com/photo-1523050854058-8df90110c9f1?q=80&w=2070&auto=format&fit=crop",
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.background, AppTheme.background.withOpacity(0.0)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 48,
                        left: 48,
                        right: 48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Master your academic journey.",
                              style: TextStyle(
                                fontFamily: 'Space Grotesk',
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                leadingDistribution: TextLeadingDistribution.even,
                                color: AppTheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    _buildAvatar("https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop"),
                                    Transform.translate(offset: const Offset(-8, 0), child: _buildAvatar("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=1974&auto=format&fit=crop")),
                                    Transform.translate(
                                      offset: const Offset(-16, 0),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.surfaceContainerHighest,
                                          border: Border.all(color: AppTheme.background, width: 2),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text("+12k", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: const Text(
                                    "Join high-performing students today.",
                                    style: TextStyle(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String url) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.background, width: 2),
      ),
      child: ClipOval(
        child: Image.network(url, fit: BoxFit.cover),
      ),
    );
  }
}
