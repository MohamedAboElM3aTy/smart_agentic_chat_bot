import 'package:flutter/material.dart';

abstract final class AppColors {
  // Background (dark mode — rich true black)
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xFF141414);
  static const surfaceVariant = Color(0xFF1E1E1E);

  // Glass overlay
  static const glassLight = Color(0x0DFFFFFF); // 5% white
  static const glassMedium = Color(0x1AFFFFFF); // 10% white
  static const glassBorder = Color(0x1FFFFFFF); // 12% white

  // Brand
  static const primary = Color(0xFF8B5CF6); // electric violet
  static const primaryDark = Color(0xFF6D28D9);
  static const primaryLight = Color(0xFFA78BFA);
  static const secondary = Color(0xFF3B82F6); // blue
  static const accent = Color(0xFFF59E0B); // amber (prices)
  static const chat = Color(0xFF10B981); // emerald (chat tab)

  // Text (dark mode)
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFA0A0A0);
  static const textMuted = Color(0xFF5A5A5A);

  // Status
  static const error = Color(0xFFEF4444);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0A0A), Color(0xFF141414)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const chatGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
