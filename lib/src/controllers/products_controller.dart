import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_agentic_chat_bot/src/models/product_model.dart';
import 'package:smart_agentic_chat_bot/src/services/firestore_service.dart';

part 'products_controller.g.dart';

// ── Firestore service provider ─────────────────────────────────────────────

@riverpod
FirestoreService firestoreService(Ref ref) {
  return FirestoreService(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
}

// ── Selected category ──────────────────────────────────────────────────────

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => 'All';

  void select(String category) => state = category;
}

// ── Products stream ────────────────────────────────────────────────────────

@riverpod
Stream<List<ProductModel>> products(Ref ref) {
  final category = ref.watch(selectedCategoryProvider);
  return ref
      .watch(firestoreServiceProvider)
      .productsStream(category: category);
}

// ── All products (unfiltered) — used by Home screen ────────────────────────
// Intentionally independent from selectedCategoryProvider so Explore filters
// don't affect the Home feed.

@riverpod
Stream<List<ProductModel>> allProducts(Ref ref) {
  return ref.watch(firestoreServiceProvider).productsStream();
}

// ── Single product ─────────────────────────────────────────────────────────

@riverpod
Future<ProductModel?> product(Ref ref, String id) {
  return ref.watch(firestoreServiceProvider).getProduct(id);
}
