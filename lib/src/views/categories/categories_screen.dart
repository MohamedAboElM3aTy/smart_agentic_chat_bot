import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smart_agentic_chat_bot/src/controllers/products_controller.dart';
import 'package:smart_agentic_chat_bot/src/core/constants/app_constants.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/app_colors.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';
import 'package:smart_agentic_chat_bot/src/models/product_model.dart';
import 'package:smart_agentic_chat_bot/src/widgets/product_card.dart';

@RoutePage()
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  static const _categoryIcons = {
    'All': Icons.apps_rounded,
    'Electronics': Icons.devices_rounded,
    'Clothing': Icons.checkroom_rounded,
    'Food': Icons.restaurant_rounded,
    'Books': Icons.menu_book_rounded,
    'Sports': Icons.sports_soccer_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.adaptiveBackgroundGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── Header ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Explore',
                                  style: TextStyle(
                                    color: context.adaptiveTextPrimary,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Text(
                                  'Discover what you love',
                                  style: TextStyle(
                                    color: context.adaptiveTextSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          productsAsync.maybeWhen(
                            data: (p) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${p.length} items',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            orElse: () => const SizedBox.shrink(),
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms),
                      const Gap(20),
                      // ── Category chips with icons ───────────────────
                      SizedBox(
                        height: 44,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppConstants.categories.length,
                          separatorBuilder: (_, _) => const Gap(8),
                          itemBuilder: (context, i) {
                            final cat = AppConstants.categories[i];
                            final isSelected = cat == selectedCategory;
                            final icon = _categoryIcons[cat] ??
                                Icons.category_rounded;
                            return GestureDetector(
                              onTap: () => ref
                                  .read(selectedCategoryProvider.notifier)
                                  .select(cat),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? AppColors.primaryGradient
                                      : null,
                                  color: isSelected
                                      ? null
                                      : context.adaptiveSurfaceVariant,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : context.adaptiveGlassBorder,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      icon,
                                      size: 15,
                                      color: isSelected
                                          ? Colors.white
                                          : context.adaptiveTextSecondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      cat,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : context.adaptiveTextSecondary,
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ).animate().fadeIn(delay: 100.ms),
                      const Gap(20),
                      // ── Section label ───────────────────────────────
                      Row(
                        children: [
                          Text(
                            selectedCategory == AppConstants.allCategory
                                ? 'All Products'
                                : selectedCategory,
                            style: TextStyle(
                              color: context.adaptiveTextPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          productsAsync.maybeWhen(
                            data: (p) => Text(
                              '${p.length} results',
                              style: TextStyle(
                                color: context.adaptiveTextMuted,
                                fontSize: 12,
                              ),
                            ),
                            orElse: () => const SizedBox.shrink(),
                          ),
                        ],
                      ).animate().fadeIn(delay: 150.ms),
                      const Gap(12),
                    ],
                  ),
                ),
              ),
              // ── Product grid ───────────────────────────────────────────
              productsAsync.when(
                loading: () {
                  final dummies =
                      List.generate(6, (_) => ProductModel.placeholder);
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    sliver: Skeletonizer.sliver(
                      child: SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: dummies.length,
                        itemBuilder: (context, i) =>
                            ExploreProductCard(product: dummies[i]),
                      ),
                    ),
                  );
                },
                error: (e, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 52),
                        const Gap(16),
                        Text(
                          'Something went wrong',
                          style: TextStyle(
                            color: context.adaptiveTextPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          '$e',
                          style: TextStyle(
                            color: context.adaptiveTextSecondary,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                data: (products) => products.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(48),
                          child: Column(
                            children: [
                              Icon(Icons.inventory_2_outlined,
                                  color: context.adaptiveTextMuted, size: 56),
                              const Gap(16),
                              Text(
                                'No products found',
                                style: TextStyle(
                                  color: context.adaptiveTextPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(8),
                              Text(
                                'Try a different category',
                                style: TextStyle(
                                  color: context.adaptiveTextSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        sliver: SliverGrid.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, i) => ExploreProductCard(
                            product: products[i],
                          )
                              .animate()
                              .fadeIn(
                                delay: Duration(milliseconds: i * 40),
                                duration: 400.ms,
                              ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
