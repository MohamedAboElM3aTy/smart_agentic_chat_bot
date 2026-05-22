import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:smart_agentic_chat_bot/src/controllers/cart_controller.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/app_colors.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';

@RoutePage()
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _ordered = false;

  @override
  Widget build(BuildContext context) {
    final total = ref.watch(cartTotalProvider);

    if (_ordered) return _OrderConfirmation();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.adaptiveBackgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: IconButton(
                  onPressed: () => context.router.maybePop(),
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: context.adaptiveTextPrimary),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Checkout',
                        style: TextStyle(
                          color: context.adaptiveTextPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(24),
                      // Delivery info (dummy)
                      _SectionCard(
                        title: 'Delivery Address',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cairo, Egypt',
                                style: TextStyle(
                                    color: context.adaptiveTextPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            const Gap(4),
                            Text('GDG Cairo — Greek Campus',
                                style: TextStyle(
                                    color: context.adaptiveTextSecondary,
                                    fontSize: 13)),
                            const Gap(4),
                            Text('Build With AI',
                                style: TextStyle(
                                    color: context.adaptiveTextSecondary,
                                    fontSize: 13)),
                            const Gap(12),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit_outlined, size: 14),
                              label: const Text('Change'),
                            ),
                          ],
                        ),
                      ),
                      const Gap(16),
                      // Payment (dummy)
                      _SectionCard(
                        title: 'Payment Method',
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 28,
                              decoration: BoxDecoration(
                                color: context.adaptiveSurfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.credit_card_rounded,
                                  color: AppColors.primary, size: 18),
                            ),
                            const Gap(12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('•••• •••• •••• 4242',
                                    style: TextStyle(
                                        color: context.adaptiveTextPrimary,
                                        fontSize: 14)),
                                Text('Cash on delivery',
                                    style: TextStyle(
                                        color: context.adaptiveTextMuted,
                                        fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gap(16),
                      // Order summary
                      _SectionCard(
                        title: 'Order Summary',
                        child: Column(
                          children: [
                            _SummaryRow(label: 'Subtotal', value: total),
                            const Gap(8),
                            const _SummaryRow(
                                label: 'Delivery', value: 0, isFree: true),
                            Divider(color: context.adaptiveGlassBorder),
                            _SummaryRow(
                                label: 'Total',
                                value: total,
                                isBold: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(cartControllerProvider.notifier)
                        .clearCart();
                    setState(() => _ordered = true);
                  },
                  child: Text(
                      'Place Order — ${total.toStringAsFixed(0)} EGP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.adaptiveBackgroundGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.4),
                          width: 2),
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: AppColors.success, size: 40),
                  )
                      .animate()
                      .scale(
                          begin: const Offset(0.5, 0.5),
                          duration: 500.ms,
                          curve: Curves.elasticOut)
                      .fadeIn(duration: 400.ms),
                  const Gap(24),
                  Text(
                    'Order Placed!',
                    style: TextStyle(
                      color: context.adaptiveTextPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  const Gap(8),
                  Text(
                    'Your order has been placed successfully.\nThank you for shopping with ShopAI!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.adaptiveTextSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                  const Gap(40),
                  ElevatedButton(
                    onPressed: () => context.router.maybePop(),
                    child: const Text('Continue Shopping'),
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.adaptiveSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.adaptiveGlassBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: context.adaptiveTextMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const Gap(12),
          child,
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isFree = false,
  });

  final String label;
  final double value;
  final bool isBold;
  final bool isFree;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? context.adaptiveTextPrimary : context.adaptiveTextSecondary,
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          isFree ? 'Free' : '${value.toStringAsFixed(0)} EGP',
          style: TextStyle(
            color: isBold
                ? AppColors.accent
                : isFree
                    ? AppColors.success
                    : context.adaptiveTextPrimary,
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
