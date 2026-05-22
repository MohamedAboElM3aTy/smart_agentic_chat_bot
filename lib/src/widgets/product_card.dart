import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_agentic_chat_bot/src/controllers/cart_controller.dart';
import 'package:smart_agentic_chat_bot/src/core/router/app_router.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/app_colors.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';
import 'package:smart_agentic_chat_bot/src/models/product_model.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, this.compact = false});

  final ProductModel product;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.pushRoute(ProductDetailRoute(id: product.id)),
      child: Container(
        decoration: BoxDecoration(
          color: context.adaptiveSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.adaptiveGlassBorder, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              flex: compact ? 3 : 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(color: context.adaptiveSurfaceVariant),
                  errorWidget: (context, url, error) => Container(
                    color: context.adaptiveSurfaceVariant,
                    child: Icon(Icons.image_outlined, color: context.adaptiveTextMuted, size: 32),
                  ),
                ),
              ),
            ),
            // Product info
            Expanded(
              flex: compact ? 2 : 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(color: context.adaptiveTextPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(0)} EGP',
                          style: const TextStyle(color: AppColors.accent, fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        _AddToCartButton(product: product),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddToCartButton extends ConsumerStatefulWidget {
  const _AddToCartButton({required this.product});

  final ProductModel product;

  @override
  ConsumerState<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends ConsumerState<_AddToCartButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _loading
          ? null
          : () async {
              setState(() => _loading = true);
              await ref.read(cartControllerProvider.notifier).addProduct(widget.product);
              if (context.mounted) {
                setState(() => _loading = false);
                final isDark = Theme.of(context).brightness == Brightness.dark;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${widget.product.name} added to cart',
                      style: TextStyle(color: isDark ? AppColors.success : Colors.white, fontWeight: FontWeight.w500),
                    ),
                    backgroundColor: isDark
                        ? const Color(0xFF064E3B) // dark emerald surface
                        : AppColors.success, // bright emerald
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(8)),
        child: _loading
            ? const Padding(
                padding: EdgeInsets.all(6),
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.add, color: Colors.white, size: 18),
      ),
    );
  }
}

/// Full-bleed image card with frosted glass overlay — used in the Explore tab.
class ExploreProductCard extends ConsumerWidget {
  const ExploreProductCard({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.pushRoute(ProductDetailRoute(id: product.id)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Full-bleed image ──────────────────────────────────────
            CachedNetworkImage(
              imageUrl: product.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: context.adaptiveSurfaceVariant,
              ),
              errorWidget: (context, url, error) => Container(
                color: context.adaptiveSurfaceVariant,
                child: Icon(
                  Icons.image_outlined,
                  color: context.adaptiveTextMuted,
                  size: 36,
                ),
              ),
            ),
            // ── Gradient scrim so glass panel pops ───────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 110,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.65),
                    ],
                  ),
                ),
              ),
            ),
            // ── Category badge ────────────────────────────────────────
            Positioned(
              top: 10,
              left: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ── Frosted glass bottom panel ────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 10, 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${product.price.toStringAsFixed(0)} EGP',
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _AddToCartButton(product: product),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal product card used in chat results
class ProductChatCard extends ConsumerWidget {
  const ProductChatCard({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.pushRoute(ProductDetailRoute(id: product.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.adaptiveSurfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.adaptiveGlassBorder, width: 0.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(width: 56, height: 56, color: context.adaptiveSurface),
                errorWidget: (context, url, error) => Container(
                  width: 56,
                  height: 56,
                  color: context.adaptiveSurface,
                  child: Icon(Icons.image_outlined, color: context.adaptiveTextMuted),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(color: context.adaptiveTextPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(product.category, style: TextStyle(color: context.adaptiveTextMuted, fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toStringAsFixed(0)} EGP',
                    style: const TextStyle(color: AppColors.accent, fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            _AddToCartButton(product: product),
          ],
        ),
      ),
    );
  }
}
