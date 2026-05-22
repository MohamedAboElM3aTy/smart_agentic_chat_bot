import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  const CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;

  double get total => price * quantity;

  factory CartItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItemModel(
      productId: data['productId'] as String,
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'] as String? ?? '',
      quantity: (data['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'productId': productId,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': quantity,
      };

  CartItemModel copyWith({int? quantity}) => CartItemModel(
        productId: productId,
        name: name,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity ?? this.quantity,
      );
}
