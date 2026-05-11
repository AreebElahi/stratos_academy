import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/enums.dart';
import '../utils/validators/app_validators.dart';
import 'theme/app_theme.dart';
import 'widgets/gradient_button.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RegistrationScreenBody();
  }
}

class _RegistrationScreenBody extends StatelessWidget {
  const _RegistrationScreenBody();

  void _handleRegister(BuildContext context) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final success = await authController.register();
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.successMessage ?? 'Registration Successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          authController.clearForm(); // Clear form for login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withOpacity(0.1),
                boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.1), blurRadius: 120, spreadRadius: 40)],
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.tertiary.withOpacity(0.1),
                boxShadow: [BoxShadow(color: AppTheme.tertiary.withOpacity(0.1), blurRadius: 120, spreadRadius: 40)],
              ),
            ),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.auto_stories, color: AppTheme.primary, size: 32),
                        SizedBox(width: 8),
                        Text(
                          "Stratos Academy",
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Create your account",
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Join the high-performance community for advanced academic excellence.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Manrope', color: AppTheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 32),
                    
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.1)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 64,
                            offset: Offset(0, 32),
                          )
                        ],
                      ),
                      child: Form(
                        key: controller.registerFormKey,
                        onChanged: controller.validateRegisterForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                              },
                              icon: const Icon(Icons.arrow_back, size: 18),
                              label: const Text("Back to Login"),
                              style: TextButton.styleFrom(iconColor: AppTheme.primary, foregroundColor: AppTheme.primary),
                            ),
                            const SizedBox(height: 16),
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
                              const SizedBox(height: 16),
                            ],
                            
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("FIRST NAME", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.onSurfaceVariant, letterSpacing: 1.5)),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: controller.firstNameController,
                                        decoration: const InputDecoration(hintText: "Alexander"),
                                        validator: (v) => AppValidators.requiredFieldValidator(v, "First Name"),
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("LAST NAME", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.onSurfaceVariant, letterSpacing: 1.5)),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: controller.lastNameController,
                                        decoration: const InputDecoration(hintText: "Pierce"),
                                        validator: (v) => AppValidators.requiredFieldValidator(v, "Last Name"),
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            const Text("EMAIL ADDRESS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.onSurfaceVariant, letterSpacing: 1.5)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: controller.emailController,
                              decoration: const InputDecoration(
                                hintText: "alex.pierce@academy.edu",
                                suffixIcon: Icon(Icons.alternate_email, color: AppTheme.outline),
                              ),
                              validator: AppValidators.emailValidator,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(height: 16),

                            const Text("GENDER", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.onSurfaceVariant, letterSpacing: 1.5)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<Gender>(
                              isExpanded: true,
                              value: controller.selectedGender,
                              items: Gender.values.map((g) => DropdownMenuItem(value: g, child: Text(g.name[0].toUpperCase() + g.name.substring(1), overflow: TextOverflow.ellipsis))).toList(),
                              onChanged: controller.setGender,
                              decoration: const InputDecoration(hintText: "Select Gender"),
                              validator: (v) => v == null ? 'Gender is required' : null,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(height: 16),

                            const Text("CREATE PASSWORD", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.onSurfaceVariant, letterSpacing: 1.5)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: controller.passwordController,
                              obscureText: !controller.isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: "••••••••",
                                suffixIcon: IconButton(
                                  icon: Icon(controller.isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                                  onPressed: controller.togglePasswordVisibility,
                                ),
                              ),
                              validator: AppValidators.passwordValidator,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(height: 16),

                            const Text("CONFIRM PASSWORD", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.onSurfaceVariant, letterSpacing: 1.5)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: controller.confirmPasswordController,
                              obscureText: !controller.isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: "••••••••",
                                suffixIcon: IconButton(
                                  icon: Icon(controller.isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                                  onPressed: controller.togglePasswordVisibility,
                                ),
                              ),
                              validator: (v) => AppValidators.confirmPasswordValidator(v, controller.passwordController.text),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(height: 24),

                            GradientButton(
                              text: "Create Account",
                              onPressed: controller.isRegisterFormValid ? () => _handleRegister(context) : null,
                              isLoading: controller.authState == AppState.loading,
                            ),
                            
                            const SizedBox(height: 24),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("Already have an account?", style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14)),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                                    },
                                    child: const Text("Log In", style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
