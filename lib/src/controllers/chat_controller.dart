import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_agentic_chat_bot/src/controllers/products_controller.dart';
import 'package:smart_agentic_chat_bot/src/models/chat_message_model.dart';
import 'package:smart_agentic_chat_bot/src/services/ai_chat_service.dart';

part 'chat_controller.g.dart';

// ── AI chat service provider ───────────────────────────────────────────────

@riverpod
AiChatService aiChatService(Ref ref) {
  return AiChatService(ref.watch(firestoreServiceProvider));
}

// ── Chat controller ────────────────────────────────────────────────────────

@riverpod
class ChatController extends _$ChatController {
  @override
  List<ChatMessageModel> build() => [];

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    state = [...state, ChatMessageModel.fromUser(text)];

    // Add typing indicator
    state = [...state, ChatMessageModel.typing()];

    try {
      final response =
          await ref.read(aiChatServiceProvider).sendMessage(text);

      // Replace typing indicator with real response
      state = [
        ...state.where((m) => !m.isTyping),
        response,
      ];
    } catch (e, st) {
      // ignore: avoid_print
      print('[ChatController] error: $e\n$st');
      state = [
        ...state.where((m) => !m.isTyping),
        ChatMessageModel.fromAi('Sorry, something went wrong: $e'),
      ];
    }
  }

  void clearChat() {
    state = [];
    ref.read(aiChatServiceProvider).reset();
  }
}
