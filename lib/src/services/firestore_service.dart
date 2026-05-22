import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_agentic_chat_bot/src/core/constants/app_constants.dart';
import 'package:smart_agentic_chat_bot/src/models/cart_item_model.dart';
import 'package:smart_agentic_chat_bot/src/models/product_model.dart';

class FirestoreService {
  FirestoreService(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  String get _uid => _auth.currentUser!.uid;

  // ── Products ───────────────────────────────────────────────────────────────

  Stream<List<ProductModel>> productsStream({String? category}) {
    Query<Map<String, dynamic>> query =
        _db.collection(AppConstants.productsCollection);

    if (category != null && category != AppConstants.allCategory) {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map(
          (snap) => snap.docs.map(ProductModel.fromFirestore).toList(),
        );
  }

  Future<ProductModel?> getProduct(String id) async {
    final doc =
        await _db.collection(AppConstants.productsCollection).doc(id).get();
    if (!doc.exists) return null;
    return ProductModel.fromFirestore(doc);
  }

  /// Used by the AI chatbot function calling to search products.
  Future<List<ProductModel>> searchProducts({
    double? maxPrice,
    double? minPrice,
    String? category,
    String? searchTerm,
  }) async {
    Query<Map<String, dynamic>> query =
        _db.collection(AppConstants.productsCollection);

    if (category != null && category != AppConstants.allCategory) {
      query = query.where('category', isEqualTo: category);
    }
    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }
    if (minPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: minPrice);
    }

    final snap = await query.get();
    var results = snap.docs.map(ProductModel.fromFirestore).toList();

    // Client-side name filter (Firestore doesn't support full-text search)
    if (searchTerm != null && searchTerm.isNotEmpty) {
      final term = searchTerm.toLowerCase();
      results = results
          .where((p) =>
              p.name.toLowerCase().contains(term) ||
              p.description.toLowerCase().contains(term))
          .toList();
    }

    return results;
  }

  // ── Cart ───────────────────────────────────────────────────────────────────

  Stream<List<CartItemModel>> cartStream() {
    return _db
        .collection(AppConstants.cartCollection)
        .doc(_uid)
        .collection(AppConstants.cartItemsSubcollection)
        .snapshots()
        .map((snap) => snap.docs.map(CartItemModel.fromFirestore).toList());
  }

  Future<void> addToCart(CartItemModel item) async {
    final ref = _db
        .collection(AppConstants.cartCollection)
        .doc(_uid)
        .collection(AppConstants.cartItemsSubcollection)
        .doc(item.productId);

    final existing = await ref.get();
    if (existing.exists) {
      final currentQty = (existing.data()!['quantity'] as num).toInt();
      await ref.update({'quantity': currentQty + item.quantity});
    } else {
      await ref.set(item.toFirestore());
    }
  }

  Future<void> removeFromCart(String productId) async {
    await _db
        .collection(AppConstants.cartCollection)
        .doc(_uid)
        .collection(AppConstants.cartItemsSubcollection)
        .doc(productId)
        .delete();
  }

  Future<void> clearCart() async {
    final snap = await _db
        .collection(AppConstants.cartCollection)
        .doc(_uid)
        .collection(AppConstants.cartItemsSubcollection)
        .get();

    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ── Seed Data ──────────────────────────────────────────────────────────────

  Future<void> seedSampleProducts() async {
    final batch = _db.batch();
    final col = _db.collection(AppConstants.productsCollection);

    for (final product in _sampleProducts) {
      batch.set(col.doc(), product);
    }

    await batch.commit();
  }

  static const _sampleProducts = [
    // Food — sub 50 EGP
    {
      'name': 'Tea Box (100 bags)',
      'description': 'Premium Egyptian tea, perfect for your morning brew.',
      'price': 25.0,
      'category': 'Food',
      'imageUrl': 'https://picsum.photos/seed/tea/400/400',
      'stock': 50,
    },
    {
      'name': 'Dark Chocolate Box',
      'description': '70% cocoa Belgian-style dark chocolate assortment.',
      'price': 45.0,
      'category': 'Food',
      'imageUrl': 'https://picsum.photos/seed/choco/400/400',
      'stock': 30,
    },
    {
      'name': 'Ground Coffee Bag',
      'description': 'Rich Arabica blend, medium roast, 250g.',
      'price': 65.0,
      'category': 'Food',
      'imageUrl': 'https://picsum.photos/seed/coffee/400/400',
      'stock': 40,
    },
    // Books — sub 50 EGP
    {
      'name': 'The Alchemist (Novel)',
      'description': "Paulo Coelho's timeless classic about following your dreams.",
      'price': 30.0,
      'category': 'Books',
      'imageUrl': 'https://picsum.photos/seed/book1/400/400',
      'stock': 20,
    },
    {
      'name': 'Clean Code',
      'description': 'A handbook of Agile software craftsmanship by Robert C. Martin.',
      'price': 120.0,
      'category': 'Books',
      'imageUrl': 'https://picsum.photos/seed/book2/400/400',
      'stock': 15,
    },
    // Clothing — sub 50 EGP
    {
      'name': 'Classic White T-Shirt',
      'description': '100% cotton premium-quality unisex tee.',
      'price': 35.0,
      'category': 'Clothing',
      'imageUrl': 'https://picsum.photos/seed/tshirt/400/400',
      'stock': 100,
    },
    {
      'name': 'Slim-Fit Jeans',
      'description': 'Modern slim fit denim jeans, available in various sizes.',
      'price': 180.0,
      'category': 'Clothing',
      'imageUrl': 'https://picsum.photos/seed/jeans/400/400',
      'stock': 45,
    },
    {
      'name': 'Running Sneakers',
      'description': 'Lightweight mesh sneakers for everyday comfort.',
      'price': 320.0,
      'category': 'Clothing',
      'imageUrl': 'https://picsum.photos/seed/shoes/400/400',
      'stock': 25,
    },
    // Electronics — sub 50 EGP
    {
      'name': 'USB-C Fast Charger',
      'description': '20W fast charging adapter compatible with all USB-C devices.',
      'price': 45.0,
      'category': 'Electronics',
      'imageUrl': 'https://picsum.photos/seed/charger/400/400',
      'stock': 60,
    },
    {
      'name': '7-Port USB Hub',
      'description': 'USB 3.0 multi-port hub with LED indicator.',
      'price': 89.0,
      'category': 'Electronics',
      'imageUrl': 'https://picsum.photos/seed/hub/400/400',
      'stock': 35,
    },
    {
      'name': 'Wireless Headphones',
      'description': 'Bluetooth 5.0 headphones with 30-hour battery life.',
      'price': 250.0,
      'category': 'Electronics',
      'imageUrl': 'https://picsum.photos/seed/headphones/400/400',
      'stock': 20,
    },
    {
      'name': 'Smart Watch',
      'description': 'Fitness tracker with heart rate, GPS, and 7-day battery.',
      'price': 750.0,
      'category': 'Electronics',
      'imageUrl': 'https://picsum.photos/seed/watch/400/400',
      'stock': 10,
    },
    // Sports — sub 50 EGP
    {
      'name': 'Stainless Steel Water Bottle',
      'description': 'Insulated 750ml bottle, keeps drinks cold 24h.',
      'price': 40.0,
      'category': 'Sports',
      'imageUrl': 'https://picsum.photos/seed/bottle/400/400',
      'stock': 80,
    },
    {
      'name': 'Non-Slip Yoga Mat',
      'description': '6mm thick eco-friendly yoga and exercise mat.',
      'price': 130.0,
      'category': 'Sports',
      'imageUrl': 'https://picsum.photos/seed/yoga/400/400',
      'stock': 30,
    },
    // Food — additional
    {
      'name': 'Honey Jar (500g)',
      'description': 'Pure natural Egyptian clover honey.',
      'price': 55.0,
      'category': 'Food',
      'imageUrl': 'https://picsum.photos/seed/honey/400/400',
      'stock': 40,
    },
    {
      'name': 'Mixed Nuts Pack',
      'description': 'Premium blend of almonds, cashews, and walnuts, 300g.',
      'price': 85.0,
      'category': 'Food',
      'imageUrl': 'https://picsum.photos/seed/nuts/400/400',
      'stock': 35,
    },
    {
      'name': 'Instant Oatmeal Box',
      'description': 'Whole grain oats, 12 individual sachets.',
      'price': 38.0,
      'category': 'Food',
      'imageUrl': 'https://picsum.photos/seed/oats/400/400',
      'stock': 60,
    },
    // Books — additional
    {
      'name': 'Atomic Habits',
      'description': 'James Clear\'s guide to building good habits and breaking bad ones.',
      'price': 95.0,
      'category': 'Books',
      'imageUrl': 'https://picsum.photos/seed/book3/400/400',
      'stock': 25,
    },
    {
      'name': 'Flutter & Dart Cookbook',
      'description': 'Practical recipes for building beautiful cross-platform apps.',
      'price': 145.0,
      'category': 'Books',
      'imageUrl': 'https://picsum.photos/seed/book4/400/400',
      'stock': 12,
    },
    {
      'name': 'Rich Dad Poor Dad',
      'description': 'Robert Kiyosaki\'s personal finance classic.',
      'price': 48.0,
      'category': 'Books',
      'imageUrl': 'https://picsum.photos/seed/book5/400/400',
      'stock': 18,
    },
    // Clothing — additional
    {
      'name': 'Hoodie Sweatshirt',
      'description': 'Cozy fleece-lined pullover hoodie, unisex fit.',
      'price': 220.0,
      'category': 'Clothing',
      'imageUrl': 'https://picsum.photos/seed/hoodie/400/400',
      'stock': 40,
    },
    {
      'name': 'Sports Cap',
      'description': 'Adjustable breathable mesh baseball cap.',
      'price': 42.0,
      'category': 'Clothing',
      'imageUrl': 'https://picsum.photos/seed/cap/400/400',
      'stock': 70,
    },
    // Electronics — additional
    {
      'name': 'Portable Bluetooth Speaker',
      'description': 'Waterproof mini speaker with 10-hour playtime.',
      'price': 175.0,
      'category': 'Electronics',
      'imageUrl': 'https://picsum.photos/seed/speaker/400/400',
      'stock': 22,
    },
    {
      'name': 'Laptop Stand',
      'description': 'Adjustable aluminium laptop stand for ergonomic desk setup.',
      'price': 95.0,
      'category': 'Electronics',
      'imageUrl': 'https://picsum.photos/seed/stand/400/400',
      'stock': 28,
    },
    {
      'name': 'Wired Earbuds',
      'description': 'High-fidelity in-ear earphones with mic, 3.5mm jack.',
      'price': 35.0,
      'category': 'Electronics',
      'imageUrl': 'https://picsum.photos/seed/earbuds/400/400',
      'stock': 55,
    },
    // Sports — additional
    {
      'name': 'Jump Rope',
      'description': 'Speed skipping rope with ball-bearing handles.',
      'price': 28.0,
      'category': 'Sports',
      'imageUrl': 'https://picsum.photos/seed/jumprope/400/400',
      'stock': 45,
    },
    {
      'name': 'Resistance Bands Set',
      'description': 'Set of 5 resistance levels for home workouts.',
      'price': 75.0,
      'category': 'Sports',
      'imageUrl': 'https://picsum.photos/seed/bands/400/400',
      'stock': 38,
    },
    {
      'name': 'Dumbbell Pair (5kg)',
      'description': 'Rubber-coated hex dumbbells, sold as a pair.',
      'price': 280.0,
      'category': 'Sports',
      'imageUrl': 'https://picsum.photos/seed/dumbbell/400/400',
      'stock': 15,
    },
  ];
}
