import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:smart_agentic_chat_bot/src/controllers/cart_controller.dart';
import 'package:smart_agentic_chat_bot/src/core/router/app_router.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/app_colors.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';
import 'package:smart_agentic_chat_bot/src/models/cart_item_model.dart';

@RoutePage()
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.adaptiveBackgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 20),
                child: Row(
                  children: [
                    Text(
                      'Cart',
                      style: TextStyle(
                        color: context.adaptiveTextPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    cartAsync.maybeWhen(
                      data: (items) => items.isNotEmpty
                          ? IconButton(
                              onPressed: () => _confirmClearCart(context, ref),
                              icon: const Icon(
                                Icons.delete_sweep_outlined,
                                color: AppColors.error,
                              ),
                              tooltip: 'Clear cart',
                            )
                          : const SizedBox.shrink(),
                      orElse: () => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: cartAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (e, _) => Center(
                    child: Text('Error: $e',
                        style: TextStyle(color: context.adaptiveTextSecondary)),
                  ),
                  data: (items) => items.isEmpty
                      ? const _EmptyCart()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                          itemCount: items.length,
                          itemBuilder: (context, i) =>
                              _CartItem(item: items[i]),
                        ),
                ),
              ),
              // Checkout bar
              cartAsync.maybeWhen(
                data: (items) => items.isNotEmpty
                    ? _CheckoutBar(total: total)
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _confirmClearCart(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Clear cart?'),
      content: const Text(
          'This will remove all items from your cart. This cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Clear'),
        ),
      ],
    ),
  );

  if (confirmed == true && context.mounted) {
    await ref.read(cartControllerProvider.notifier).clearCart();
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined,
              color: context.adaptiveTextMuted, size: 64),
          const Gap(16),
          Text(
            'Your cart is empty',
            style: TextStyle(color: context.adaptiveTextSecondary, fontSize: 16),
          ),
          const Gap(8),
          Text(
            'Add products from the Home or Chat screen',
            style: TextStyle(color: context.adaptiveTextMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _CartItem extends ConsumerWidget {
  const _CartItem({required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(item.productId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      onDismissed: (_) =>
          ref.read(cartControllerProvider.notifier).removeProduct(item.productId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.adaptiveSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.adaptiveGlassBorder, width: 0.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(width: 64, height: 64, color: context.adaptiveSurfaceVariant),
                errorWidget: (context, url, error) => Container(
                  width: 64,
                  height: 64,
                  color: context.adaptiveSurfaceVariant,
                  child: Icon(Icons.image_outlined, color: context.adaptiveTextMuted),
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      color: context.adaptiveTextPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Text(
                    '${item.price.toStringAsFixed(0)} EGP × ${item.quantity}',
                    style: TextStyle(color: context.adaptiveTextMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
            Text(
              '${item.total.toStringAsFixed(0)} EGP',
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutBar extends ConsumerWidget {
  const _CheckoutBar({required this.total});

  final double total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: context.adaptiveSurface,
        border: Border(top: BorderSide(color: context.adaptiveGlassBorder)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total',
                  style: TextStyle(
                      color: context.adaptiveTextSecondary, fontSize: 13)),
              Text(
                '${total.toStringAsFixed(0)} EGP',
                style: TextStyle(
                  color: context.adaptiveTextPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Gap(20),
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.pushRoute(const CheckoutRoute()),
              child: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
