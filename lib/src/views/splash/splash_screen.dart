import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_agentic_chat_bot/src/core/router/app_router.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/app_colors.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.replaceRoute(const MainShellRoute());
    } else {
      context.replaceRoute(const LoginRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.adaptiveBackgroundGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 32,
                            spreadRadius: 4),
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome,
                        color: Colors.white, size: 48),
                  )
                  .animate()
                  .scale(
                      begin: const Offset(0.5, 0.5),
                      duration: 600.ms,
                      curve: Curves.elasticOut)
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              Text(
                    'ShopAI',
                    style: TextStyle(
                      color: context.adaptiveTextPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 500.ms)
                  .slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOut),
              const SizedBox(height: 8),
              Text(
                'Your intelligent shopping assistant',
                style: TextStyle(
                    color: context.adaptiveTextSecondary, fontSize: 14),
              ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
              const SizedBox(height: 60),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.primary),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
