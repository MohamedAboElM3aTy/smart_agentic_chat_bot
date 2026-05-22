import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.stock,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final int stock;

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] as String,
      description: data['description'] as String? ?? '',
      price: (data['price'] as num).toDouble(),
      category: data['category'] as String,
      imageUrl: data['imageUrl'] as String? ?? '',
      stock: (data['stock'] as num?)?.toInt() ?? 0,
    );
  }

  factory ProductModel.fromMap(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,
      name: data['name'] as String,
      description: data['description'] as String? ?? '',
      price: (data['price'] as num).toDouble(),
      category: data['category'] as String,
      imageUrl: data['imageUrl'] as String? ?? '',
      stock: (data['stock'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'imageUrl': imageUrl,
        'stock': stock,
      };

  // Used for Skeletonizer loading placeholders
  static ProductModel get placeholder => const ProductModel(
        id: '',
        name: 'Product Name Here',
        description: 'Product description text',
        price: 99.99,
        category: 'Category',
        imageUrl: '',
        stock: 10,
      );
}
