import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';

/// A frosted-glass container using [BackdropFilter].
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderColor,
    this.sigmaX = 20,
    this.sigmaY = 20,
    this.width,
    this.height,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final double sigmaX;
  final double sigmaY;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final fill = color ?? context.adaptiveGlassFill;
    final border = borderColor ?? context.adaptiveGlassBorder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: border, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
