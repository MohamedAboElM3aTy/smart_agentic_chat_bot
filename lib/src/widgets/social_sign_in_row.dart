import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';

class SocialSignInRow extends StatelessWidget {
  const SocialSignInRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: context.adaptiveTextMuted.withOpacity(0.3))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('OR continue with', style: TextStyle(color: context.adaptiveTextMuted, fontSize: 12)),
            ),
            Expanded(child: Divider(color: context.adaptiveTextMuted.withOpacity(0.3))),
          ],
        ),
        const Gap(16),
        // Buttons
        Row(
          children: [
            Expanded(child: _SocialButton(icon: Image.asset('assets/google_logo.png', width: 36, height: 36))),
            const Gap(12),
            Expanded(
              child: _SocialButton(
                icon: Image.asset('assets/apple_logo.png', width: 36, height: 36, color: context.adaptiveTextPrimary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon});

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: null,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(color: context.adaptiveTextMuted.withOpacity(0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white.withOpacity(0.05),
        disabledForegroundColor: context.adaptiveTextSecondary,
        disabledBackgroundColor: Colors.white.withOpacity(0.05),
      ),
      child: icon,
    );
  }
}
