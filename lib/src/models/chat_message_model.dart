import 'package:smart_agentic_chat_bot/src/models/product_model.dart';

enum MessageSender { user, ai }

class ChatMessageModel {
  const ChatMessageModel({
    required this.text,
    required this.sender,
    required this.timestamp,
    this.products = const [],
    this.isTyping = false,
  });

  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final List<ProductModel> products;
  final bool isTyping;

  bool get isUser => sender == MessageSender.user;
  bool get hasProducts => products.isNotEmpty;

  static ChatMessageModel typing() => ChatMessageModel(
        text: '',
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
        isTyping: true,
      );

  static ChatMessageModel fromUser(String text) => ChatMessageModel(
        text: text,
        sender: MessageSender.user,
        timestamp: DateTime.now(),
      );

  static ChatMessageModel fromAi(String text, {List<ProductModel> products = const []}) =>
      ChatMessageModel(
        text: text,
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
        products: products,
      );
}
