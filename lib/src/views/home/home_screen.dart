import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smart_agentic_chat_bot/src/controllers/auth_controller.dart';
import 'package:smart_agentic_chat_bot/src/controllers/products_controller.dart';
import 'package:smart_agentic_chat_bot/src/core/constants/app_constants.dart';
import 'package:smart_agentic_chat_bot/src/core/router/app_router.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/app_colors.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';
import 'package:smart_agentic_chat_bot/src/models/product_model.dart';
import 'package:smart_agentic_chat_bot/src/widgets/product_card.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProductsAsync = ref.watch(allProductsProvider);
    final authState = ref.watch(authStateProvider);
    final username = authState.asData?.value?.displayName ?? 'there';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.adaptiveBackgroundGradient),
        child: SafeArea(
          child: allProductsAsync.when(
            loading: () => const _HomeScreenSkeleton(),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Error loading products: $e',
                  style: TextStyle(color: context.adaptiveTextSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            data: (products) => _HomeContent(
              username: username,
              products: products,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Main content ────────────────────────────────────────────────────────────

class _HomeContent extends ConsumerWidget {
  const _HomeContent({required this.username, required this.products});

  final String username;
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined,
                  color: context.adaptiveTextMuted, size: 56),
              const Gap(16),
              Text(
                'No products yet.',
                style: TextStyle(
                  color: context.adaptiveTextPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(8),
              Text(
                'Go to Profile to seed sample data.',
                style: TextStyle(
                    color: context.adaptiveTextSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Pick featured product (highest price = most premium feel on the banner)
    final featured = products.reduce(
      (a, b) => a.price >= b.price ? a : b,
    );

    // Group by category (preserve AppConstants order, skip 'All')
    final grouped = {
      for (final cat in AppConstants.categories.skip(1))
        cat: products.where((p) => p.category == cat).toList()
    }..removeWhere((_, v) => v.isEmpty);

    return CustomScrollView(
      slivers: [
        // ── Header ───────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $username 👋',
                        style: TextStyle(
                          color: context.adaptiveTextSecondary,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'What are you\nlooking for?',
                        style: TextStyle(
                          color: context.adaptiveTextPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms),
          ),
        ),

        // ── Hero banner ───────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _HeroBannerCard(product: featured)
              .animate()
              .fadeIn(delay: 100.ms, duration: 500.ms)
              .slideY(begin: 0.05, end: 0, delay: 100.ms, duration: 500.ms),
        ),

        // ── Category carousels ────────────────────────────────────────────
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final entry = grouped.entries.elementAt(i);
              return _CategoryCarousel(
                category: entry.key,
                products: entry.value,
                onSeeAll: () {
                  ref
                      .read(selectedCategoryProvider.notifier)
                      .select(entry.key);
                  AutoTabsRouter.of(context).setActiveIndex(1);
                },
              ).animate().fadeIn(
                    delay: Duration(milliseconds: 200 + i * 80),
                    duration: 400.ms,
                  );
            },
            childCount: grouped.length,
          ),
        ),

        const SliverToBoxAdapter(child: Gap(100)),
      ],
    );
  }
}

// ── Hero banner ─────────────────────────────────────────────────────────────

class _HeroBannerCard extends StatelessWidget {
  const _HeroBannerCard({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushRoute(ProductDetailRoute(id: product.id)),
      child: Container(
        height: 210,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    Container(color: context.adaptiveSurfaceVariant),
                errorWidget: (_, _, _) => Container(
                  color: context.adaptiveSurfaceVariant,
                  child: Icon(Icons.image_outlined,
                      color: context.adaptiveTextMuted, size: 40),
                ),
              ),
              // Left-to-right gradient scrim
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    stops: const [0.35, 1.0],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'FEATURED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Text(
                      product.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(6),
                    Text(
                      '${product.price.toStringAsFixed(0)} EGP',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Gap(14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Shop Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Category carousel section ───────────────────────────────────────────────

class _CategoryCarousel extends StatelessWidget {
  const _CategoryCarousel({
    required this.category,
    required this.products,
    required this.onSeeAll,
  });

  final String category;
  final List<ProductModel> products;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 8, 14),
            child: Row(
              children: [
                Text(
                  category,
                  style: TextStyle(
                    color: context.adaptiveTextPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See all',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Horizontal product carousel
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, i) => SizedBox(
                width: 148,
                child: ProductCard(product: products[i])
                    .animate()
                    .fadeIn(
                      delay: Duration(milliseconds: i * 50),
                      duration: 350.ms,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading skeleton ─────────────────────────────────────────────────────────

class _HomeScreenSkeleton extends StatelessWidget {
  const _HomeScreenSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 110,
                        height: 13,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 6)),
                    Container(width: 170, height: 22, color: Colors.white),
                    const SizedBox(height: 4),
                    Container(width: 150, height: 22, color: Colors.white),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
          ),
          // Hero banner
          Container(
            height: 210,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          // Two carousel sections
          ...List.generate(
            2,
            (_) => Padding(
              padding: const EdgeInsets.only(top: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                    child: Container(
                        width: 120, height: 18, color: Colors.white),
                  ),
                  SizedBox(
                    height: 220,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 3,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: 12),
                      itemBuilder: (_, _) => Container(
                        width: 148,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
