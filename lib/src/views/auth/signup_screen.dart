import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:smart_agentic_chat_bot/src/controllers/auth_controller.dart';
import 'package:smart_agentic_chat_bot/src/core/router/app_router.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';
import 'package:smart_agentic_chat_bot/src/widgets/glass_container.dart';
import 'package:smart_agentic_chat_bot/src/widgets/social_sign_in_row.dart';

@RoutePage()
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).signUp(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          username: _usernameCtrl.text.trim(),
        );

    if (!mounted) return;
    final state = ref.read(authControllerProvider);
    if (state is AsyncError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error.toString())),
      );
    } else {
      context.replaceRoute(const MainShellRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.adaptiveBackgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.router.maybePop(),
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: context.adaptiveTextPrimary),
                ),
                const Gap(16),
                Text(
                  'Create your\naccount ✨',
                  style: TextStyle(
                    color: context.adaptiveTextPrimary,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2),
                const Gap(8),
                Text(
                  'Join us and start shopping smarter',
                  style: TextStyle(
                    color: context.adaptiveTextSecondary,
                    fontSize: 15,
                  ),
                ).animate().fadeIn(delay: 100.ms),
                const Gap(40),
                GlassContainer(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameCtrl,
                          style: TextStyle(color: context.adaptiveTextPrimary),
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person_outline,
                                color: context.adaptiveTextMuted),
                          ),
                          validator: (v) =>
                              v == null || v.length < 3 ? 'Minimum 3 characters' : null,
                        ),
                        const Gap(16),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: context.adaptiveTextPrimary),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined,
                                color: context.adaptiveTextMuted),
                          ),
                          validator: (v) =>
                              v == null || !v.contains('@') ? 'Enter a valid email' : null,
                        ),
                        const Gap(16),
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscurePassword,
                          style: TextStyle(color: context.adaptiveTextPrimary),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outlined,
                                color: context.adaptiveTextMuted),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: context.adaptiveTextMuted,
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) =>
                              v == null || v.length < 6 ? 'Minimum 6 characters' : null,
                        ),
                        const Gap(24),
                        ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Create Account'),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.1),
                const Gap(24),
                const SocialSignInRow().animate().fadeIn(delay: 350.ms, duration: 500.ms),
                const Gap(16),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(color: context.adaptiveTextSecondary),
                      ),
                      TextButton(
                        onPressed: () => context.router.maybePop(),
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
