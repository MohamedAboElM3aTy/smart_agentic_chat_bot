import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:smart_agentic_chat_bot/src/controllers/cart_controller.dart';
import 'package:smart_agentic_chat_bot/src/controllers/products_controller.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/app_colors.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';
import 'package:smart_agentic_chat_bot/src/widgets/glass_container.dart';

@RoutePage()
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, @PathParam('id') required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productProvider(id));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.adaptiveBackgroundGradient),
        child: productAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => Center(
            child: Text('Error: $e',
                style: TextStyle(color: context.adaptiveTextSecondary)),
          ),
          data: (product) {
            if (product == null) {
              return Center(
                child: Text('Product not found',
                    style: TextStyle(color: context.adaptiveTextSecondary)),
              );
            }

            return CustomScrollView(
              slivers: [
                // Product image
                SliverAppBar(
                  expandedHeight: 320,
                  pinned: true,
                  backgroundColor: context.adaptiveSurface,
                  leading: GestureDetector(
                    onTap: () => context.router.maybePop(),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: GlassContainer(
                        padding: EdgeInsets.all(8),
                        borderRadius: 12,
                        child: Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: context.adaptiveSurfaceVariant),
                      errorWidget: (context, url, error) => Container(
                        color: context.adaptiveSurfaceVariant,
                        child: Icon(Icons.image_outlined,
                            color: context.adaptiveTextMuted, size: 64),
                      ),
                    ),
                  ),
                ),
                // Product details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            product.category,
                            style: const TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 300.ms),
                        const Gap(12),
                        Text(
                          product.name,
                          style: TextStyle(
                            color: context.adaptiveTextPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 50.ms, duration: 300.ms),
                        const Gap(8),
                        Text(
                          '${product.price.toStringAsFixed(0)} EGP',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 100.ms, duration: 300.ms),
                        const Gap(20),
                        // Stock
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: product.stock > 0
                                    ? AppColors.success
                                    : AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Gap(6),
                            Text(
                              product.stock > 0
                                  ? '${product.stock} in stock'
                                  : 'Out of stock',
                              style: TextStyle(
                                color: product.stock > 0
                                    ? AppColors.success
                                    : AppColors.error,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),
                        // Description
                        Text(
                          'Description',
                          style: TextStyle(
                            color: context.adaptiveTextPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          product.description,
                          style: TextStyle(
                            color: context.adaptiveTextSecondary,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const Gap(32),
                        ElevatedButton.icon(
                          onPressed: product.stock == 0
                              ? null
                              : () async {
                                  await ref
                                      .read(cartControllerProvider.notifier)
                                      .addProduct(product);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text('Added to cart!')),
                                    );
                                  }
                                },
                          icon: const Icon(Icons.shopping_bag_outlined),
                          label: const Text('Add to Cart'),
                        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                        const Gap(40),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
