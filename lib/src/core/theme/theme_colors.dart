import 'package:flutter/material.dart';

/// Adaptive color extension — returns the correct color for the current theme.
/// Use for surface/text/glass colors that differ between dark and light.
/// Brand colors (primary, accent, error, etc.) stay in AppColors.
extension AppThemeColors on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  // ── Text ─────────────────────────────────────────────────────────────────
  Color get adaptiveTextPrimary =>
      _isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A);

  Color get adaptiveTextSecondary =>
      _isDark ? const Color(0xFFA0A0A0) : const Color(0xFF555566);

  Color get adaptiveTextMuted =>
      _isDark ? const Color(0xFF5A5A5A) : const Color(0xFF999999);

  // ── Surfaces ─────────────────────────────────────────────────────────────
  Color get adaptiveSurface =>
      _isDark ? const Color(0xFF141414) : Colors.white;

  Color get adaptiveSurfaceVariant =>
      _isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);

  // ── Glass overlays ────────────────────────────────────────────────────────
  Color get adaptiveGlassBorder =>
      _isDark ? const Color(0x1FFFFFFF) : const Color(0xFFEBEBEB);

  Color get adaptiveGlassFill =>
      _isDark ? const Color(0x0DFFFFFF) : Colors.white.withValues(alpha: 0.85);

  Color get adaptiveGlassMedium =>
      _isDark ? const Color(0x1AFFFFFF) : Colors.white.withValues(alpha: 0.95);

  // ── Gradients ────────────────────────────────────────────────────────────
  LinearGradient get adaptiveBackgroundGradient => _isDark
      ? const LinearGradient(
          colors: [Color(0xFF0A0A0A), Color(0xFF141414)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      : const LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
}
