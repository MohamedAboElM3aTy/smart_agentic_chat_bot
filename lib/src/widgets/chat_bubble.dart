import 'package:flutter/material.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/app_colors.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';
import 'package:smart_agentic_chat_bot/src/models/chat_message_model.dart';
import 'package:smart_agentic_chat_bot/src/widgets/product_card.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    if (message.isTyping) return const _TypingIndicator();
    if (message.isUser) return _UserBubble(message: message);
    return _AiBubble(message: message);
  }
}

// ── User bubble ────────────────────────────────────────────────────────────

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.message});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── AI bubble ──────────────────────────────────────────────────────────────

class _AiBubble extends StatelessWidget {
  const _AiBubble({required this.message});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI avatar
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8, top: 4),
            decoration: BoxDecoration(
              gradient: AppColors.chatGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 16,
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text bubble
                if (message.text.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: context.adaptiveSurface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                      border: Border.all(
                          color: context.adaptiveGlassBorder, width: 0.5),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: context.adaptiveTextPrimary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                // Product cards
                if (message.hasProducts) ...[
                  const SizedBox(height: 8),
                  ...message.products.map((p) => ProductChatCard(product: p)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Typing indicator ───────────────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: AppColors.chatGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: context.adaptiveSurface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border:
                  Border.all(color: context.adaptiveGlassBorder, width: 0.5),
            ),
            child: Row(
              children: List.generate(3, (i) {
                final delay = i * 0.2;
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final t =
                        ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
                    final s = 0.6 + 0.4 * (t < 0.5 ? t * 2 : (1 - t) * 2);
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: s),
                        shape: BoxShape.circle,
                      ),
                      transform: Matrix4.diagonal3Values(s, s, 1),
                      transformAlignment: Alignment.center,
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
