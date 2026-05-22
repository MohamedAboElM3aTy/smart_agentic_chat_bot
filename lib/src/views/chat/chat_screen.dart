import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:smart_agentic_chat_bot/src/controllers/chat_controller.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/app_colors.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/theme_colors.dart';
import 'package:smart_agentic_chat_bot/src/widgets/chat_bubble.dart';
import 'package:smart_agentic_chat_bot/src/widgets/glass_container.dart';

@RoutePage()
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _textCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    _textCtrl.clear();
    await ref.read(chatControllerProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatControllerProvider);

    // Auto-scroll when new messages arrive
    ref.listen(chatControllerProvider, (prev, next) => _scrollToBottom());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.adaptiveBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.chatGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                    ),
                    const Gap(12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Build With AI Assistant',
                          style: TextStyle(
                            color: context.adaptiveTextPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Powered by Gemini (GDG Cairo)',
                          style: TextStyle(color: context.adaptiveTextMuted, fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => ref.read(chatControllerProvider.notifier).clearChat(),
                      icon: Icon(Icons.refresh_rounded, color: context.adaptiveTextSecondary),
                      tooltip: 'Clear chat',
                    ),
                  ],
                ),
              ),
              Divider(color: context.adaptiveGlassBorder, height: 1),
              // Messages
              Expanded(
                child: messages.isEmpty
                    ? _EmptyState(onSuggestionTap: _send)
                    : ListView.builder(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        itemCount: messages.length,
                        itemBuilder: (context, i) => ChatBubble(message: messages[i]),
                      ),
              ),
              // Input
              _ChatInput(controller: _textCtrl, onSend: _send),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty state with suggestion chips ─────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onSuggestionTap});

  final ValueChanged<String> onSuggestionTap;

  static const _suggestions = [
    'Show me products under 50 EGP',
    'What electronics do you have?',
    'Give me books under 100 EGP',
    'Show all clothing items',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: AppColors.chatGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppColors.chat.withValues(alpha: 0.3), blurRadius: 24, spreadRadius: 4)],
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 36),
            ),
            const Gap(20),
            Text(
              'Ask me anything!',
              style: TextStyle(color: context.adaptiveTextPrimary, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const Gap(8),
            Text(
              'I can search products by price,\ncategory, or keywords.',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.adaptiveTextSecondary, fontSize: 14, height: 1.5),
            ),
            const Gap(32),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _suggestions
                  .map(
                    (s) => GestureDetector(
                      onTap: () => onSuggestionTap(s),
                      child: GlassContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        borderRadius: 20,
                        child: Text(s, style: TextStyle(color: context.adaptiveTextSecondary, fontSize: 13)),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Chat input ─────────────────────────────────────────────────────────────

class _ChatInput extends StatelessWidget {
  const _ChatInput({required this.controller, required this.onSend});

  final TextEditingController controller;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: context.adaptiveTextPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Ask about products...',
                hintStyle: TextStyle(color: context.adaptiveTextMuted, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: context.adaptiveGlassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: context.adaptiveGlassBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.chat, width: 1.5),
                ),
                filled: true,
                fillColor: context.adaptiveGlassMedium,
              ),
              onSubmitted: onSend,
              textInputAction: TextInputAction.send,
            ),
          ),
          const Gap(10),
          GestureDetector(
            onTap: () => onSend(controller.text),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.chatGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: AppColors.chat.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
