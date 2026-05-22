import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/app_colors.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';

class NavBarItem {
  const NavBarItem({required this.icon, required this.activeIcon, required this.label});

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class LiquidGlassNavBar extends StatefulWidget {
  const LiquidGlassNavBar({super.key, required this.currentIndex, required this.onTap, this.cartCount = 0});

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartCount;

  static const items = [
    NavBarItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    NavBarItem(icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded, label: 'Explore'),
    NavBarItem(icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome, label: 'Chat'),
    NavBarItem(icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag_rounded, label: 'Cart'),
    NavBarItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  State<LiquidGlassNavBar> createState() => _LiquidGlassNavBarState();
}

class _LiquidGlassNavBarState extends State<LiquidGlassNavBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blobX;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    final count = LiquidGlassNavBar.items.length;
    final initial = widget.currentIndex / (count - 1);
    _blobX = AlwaysStoppedAnimation(initial);
  }

  @override
  void didUpdateWidget(LiquidGlassNavBar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _animateBlob(from: old.currentIndex, to: widget.currentIndex);
    }
  }

  void _animateBlob({required int from, required int to}) {
    final count = LiquidGlassNavBar.items.length;
    _blobX = Tween<double>(
      begin: from / (count - 1),
      end: to / (count - 1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
    _controller
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final count = LiquidGlassNavBar.items.length;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: 64 + bottomPadding,
          padding: EdgeInsets.only(bottom: bottomPadding),
          decoration: BoxDecoration(
            color: context.adaptiveGlassMedium,
            border: Border(
                top: BorderSide(color: context.adaptiveGlassBorder, width: 0.5)),
          ),
          child: AnimatedBuilder(
            animation: _controller.status == AnimationStatus.dismissed
                ? kAlwaysDismissedAnimation
                : _controller,
            builder: (context, _) {
              return Stack(
                children: [
                  // Blob indicator
                  if (_controller.status != AnimationStatus.dismissed)
                    Positioned(
                      top: 8,
                      left: _blobOffset(_blobX.value, MediaQuery.of(context).size.width, count),
                      child: _BlobIndicator(isCenter: _indexFromValue(_blobX.value, count) == 2),
                    )
                  else
                    Positioned(
                      top: 8,
                      left: _blobOffset(widget.currentIndex / (count - 1), MediaQuery.of(context).size.width, count),
                      child: _BlobIndicator(isCenter: widget.currentIndex == 2),
                    ),
                  // Nav items
                  Row(
                    children: List.generate(
                      count,
                      (i) => Expanded(
                        child: _NavItem(
                          item: LiquidGlassNavBar.items[i],
                          isSelected: widget.currentIndex == i,
                          isCenter: i == 2,
                          badge: i == 3 ? widget.cartCount : 0,
                          onTap: () => widget.onTap(i),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  double _blobOffset(double value, double width, int count) {
    final itemWidth = width / count;
    return value * (width - itemWidth) - (48 - itemWidth) / 2;
  }

  int _indexFromValue(double value, int count) {
    return (value * (count - 1)).round();
  }
}

class _BlobIndicator extends StatelessWidget {
  const _BlobIndicator({required this.isCenter});

  final bool isCenter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 48,
      decoration: BoxDecoration(
        gradient: isCenter ? AppColors.chatGradient : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isCenter ? AppColors.chat : AppColors.primary).withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.isCenter,
    required this.onTap,
    required this.badge,
  });

  final NavBarItem item;
  final bool isSelected;
  final bool isCenter;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.white : context.adaptiveTextMuted;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    key: ValueKey(isSelected),
                    color: color,
                    size: isCenter ? 26 : 22,
                  ),
                ),
                if (badge > 0)
                  Positioned(
                    top: -4,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        badge > 99 ? '99+' : '$badge',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}
