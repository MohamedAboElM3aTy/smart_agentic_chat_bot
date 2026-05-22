import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:smart_agentic_chat_bot/src/controllers/auth_controller.dart';
import 'package:smart_agentic_chat_bot/src/controllers/products_controller.dart';
import 'package:smart_agentic_chat_bot/src/controllers/theme_controller.dart';
import 'package:smart_agentic_chat_bot/src/core/router/app_router.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/app_colors.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';
import 'package:smart_agentic_chat_bot/src/widgets/glass_container.dart';

@RoutePage()
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final firestoreService = ref.watch(firestoreServiceProvider);
    final isDark = ref.watch(themeControllerProvider) == ThemeMode.dark;

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: context.adaptiveBackgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Gap(20),
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      (user?.displayName?.isNotEmpty == true
                              ? user!.displayName![0]
                              : user?.email?[0] ?? '?')
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                Text(
                  user?.displayName ?? 'User',
                  style: TextStyle(
                    color: context.adaptiveTextPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(4),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: context.adaptiveTextSecondary,
                    fontSize: 14,
                  ),
                ),
                const Gap(32),
                // Workshop: Seed data button
                GlassContainer(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _ProfileTile(
                        icon: Icons.inventory_2_outlined,
                        iconColor: AppColors.chat,
                        title: 'Seed Sample Products',
                        subtitle: 'Add demo products to Firestore',
                        onTap: () async {
                          await firestoreService.seedSampleProducts();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Sample products added to Firestore!'),
                              ),
                            );
                          }
                        },
                      ),
                      Divider(color: context.adaptiveGlassBorder, height: 0.5),
                      _ProfileTile(
                        icon: isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        iconColor: AppColors.accent,
                        title: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                        subtitle: isDark ? 'Use a bright, clean theme' : 'Use a dark glass theme',
                        trailing: Switch(
                          value: isDark,
                          onChanged: (_) => ref
                              .read(themeControllerProvider.notifier)
                              .toggle(),
                          activeThumbColor: AppColors.primary,
                        ),
                        onTap: () =>
                            ref.read(themeControllerProvider.notifier).toggle(),
                      ),
                      Divider(color: context.adaptiveGlassBorder, height: 0.5),
                      _ProfileTile(
                        icon: Icons.notifications_outlined,
                        iconColor: AppColors.primary,
                        title: 'Notifications',
                        subtitle: 'Manage push notifications',
                        onTap: () {},
                      ),
                      Divider(color: context.adaptiveGlassBorder, height: 0.5),
                      _ProfileTile(
                        icon: Icons.help_outline_rounded,
                        iconColor: AppColors.secondary,
                        title: 'About',
                        subtitle: 'GDG Cairo — Build with AI',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                GlassContainer(
                  padding: EdgeInsets.zero,
                  child: _ProfileTile(
                    icon: Icons.logout_rounded,
                    iconColor: AppColors.error,
                    title: 'Sign Out',
                    subtitle: 'See you next time!',
                    onTap: () async {
                      await ref
                          .read(authControllerProvider.notifier)
                          .signOut();
                      if (context.mounted) {
                        context.replaceRoute(const LoginRoute());
                      }
                    },
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

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: context.adaptiveTextPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: context.adaptiveTextMuted, fontSize: 12),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_right_rounded,
            color: context.adaptiveTextMuted,
            size: 18,
          ),
    );
  }
}
