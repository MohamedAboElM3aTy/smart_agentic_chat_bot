import 'package:firebase_ai/firebase_ai.dart';
import 'package:smart_agentic_chat_bot/src/core/constants/app_constants.dart';
import 'package:smart_agentic_chat_bot/src/models/chat_message_model.dart';
import 'package:smart_agentic_chat_bot/src/models/product_model.dart';
import 'package:smart_agentic_chat_bot/src/services/firestore_service.dart';

class AiChatService {
  AiChatService(this._firestoreService) {
    _initModel();
  }

  final FirestoreService _firestoreService;
  late final ChatSession _chat;

  // ── Function declaration for Gemini ───────────────────────────────────────

  static final _searchProductsDecl = FunctionDeclaration(
    'searchProducts',
    'Search and filter products from the store catalog. '
        'Use this whenever the user asks about products, prices, or shopping.',
    parameters: {
      'maxPrice': Schema.number(
        description: 'Maximum product price in EGP (Egyptian Pounds).',
        nullable: true,
      ),
      'minPrice': Schema.number(
        description: 'Minimum product price in EGP.',
        nullable: true,
      ),
      'category': Schema.string(
        description:
            'Filter by category. One of: Electronics, Clothing, Food, Books, Sports.',
        nullable: true,
      ),
      'searchTerm': Schema.string(
        description: 'Keyword to search in product name or description.',
        nullable: true,
      ),
    },
  );

  // ── Model init ────────────────────────────────────────────────────────────

  void _initModel() {
    final model = FirebaseAI.googleAI().generativeModel(
      model: AppConstants.geminiModel,
      systemInstruction: Content.system(
        'You are a helpful shopping assistant for an e-commerce store. '
        'When users ask about products, prices, or want recommendations, '
        'always use the searchProducts function to fetch real data from the store. '
        'Present results in a friendly, concise manner. '
        'Prices are in Egyptian Pounds (EGP).',
      ),
      tools: [
        Tool.functionDeclarations([_searchProductsDecl]),
      ],
      toolConfig: ToolConfig(
        functionCallingConfig: FunctionCallingConfig.auto(),
      ),
    );

    _chat = model.startChat();
  }

  // ── Send message ──────────────────────────────────────────────────────────

  /// Returns a [ChatMessageModel] with the AI's text and any matching products.
  Future<ChatMessageModel> sendMessage(String userText) async {
    var response = await _chat.sendMessage(Content.text(userText));

    List<ProductModel> foundProducts = [];

    // Handle function calling loop (Gemini may chain multiple calls)
    while (true) {
      final functionCalls = response.functionCalls.toList();
      if (functionCalls.isEmpty) break;

      final functionResponses = <FunctionResponse>[];

      for (final call in functionCalls) {
        if (call.name == 'searchProducts') {
          final args = call.args;
          final products = await _firestoreService.searchProducts(
            maxPrice: (args['maxPrice'] as num?)?.toDouble(),
            minPrice: (args['minPrice'] as num?)?.toDouble(),
            category: args['category'] as String?,
            searchTerm: args['searchTerm'] as String?,
          );
          foundProducts = products;

          final productList = products
              .map((p) => {
                    'id': p.id,
                    'name': p.name,
                    'price': p.price,
                    'category': p.category,
                    'description': p.description,
                    'stock': p.stock,
                  })
              .toList();

          functionResponses.add(
            FunctionResponse(call.name, {'products': productList}),
          );
        }
      }

      response = await _chat.sendMessage(
        Content.functionResponses(functionResponses),
      );
    }

    final text = response.text ?? 'Sorry, I could not generate a response.';
    return ChatMessageModel.fromAi(text, products: foundProducts);
  }

  void reset() {
    _initModel();
  }
}
