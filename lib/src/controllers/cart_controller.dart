import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_agentic_chat_bot/src/controllers/products_controller.dart';
import 'package:smart_agentic_chat_bot/src/models/cart_item_model.dart';
import 'package:smart_agentic_chat_bot/src/models/product_model.dart';

part 'cart_controller.g.dart';

// ── Cart stream ────────────────────────────────────────────────────────────

@riverpod
Stream<List<CartItemModel>> cart(Ref ref) {
  // Depend on auth state so cart resets on sign-out
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();
  return ref.watch(firestoreServiceProvider).cartStream();
}

// ── Cart controller ────────────────────────────────────────────────────────

@riverpod
class CartController extends _$CartController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> addProduct(ProductModel product, {int quantity = 1}) async {
    final item = CartItemModel(
      productId: product.id,
      name: product.name,
      price: product.price,
      imageUrl: product.imageUrl,
      quantity: quantity,
    );
    await ref.read(firestoreServiceProvider).addToCart(item);
  }

  Future<void> removeProduct(String productId) async {
    await ref.read(firestoreServiceProvider).removeFromCart(productId);
  }

  Future<void> clearCart() async {
    await ref.read(firestoreServiceProvider).clearCart();
  }
}

// ── Cart item count ────────────────────────────────────────────────────────

@riverpod
int cartCount(Ref ref) {
  return ref.watch(cartProvider).maybeWhen(
        data: (items) => items.fold(0, (acc, item) => acc + item.quantity),
        orElse: () => 0,
      );
}

// ── Cart total ─────────────────────────────────────────────────────────────

@riverpod
double cartTotal(Ref ref) {
  return ref.watch(cartProvider).maybeWhen(
        data: (items) => items.fold(0.0, (acc, item) => acc + item.total),
        orElse: () => 0.0,
      );
}
