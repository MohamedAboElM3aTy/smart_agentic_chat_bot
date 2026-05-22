abstract final class AppConstants {
  // Firestore collections
  static const usersCollection = 'users';
  static const productsCollection = 'products';
  static const cartCollection = 'cart';
  static const cartItemsSubcollection = 'items';

  // Product categories
  static const allCategory = 'All';
  static const categories = [
    allCategory,
    'Electronics',
    'Clothing',
    'Food',
    'Books',
    'Sports',
  ];

  // AI model
  static const geminiModel = 'gemini-2.5-flash';


  // UI
  static const borderRadius = 16.0;
  static const cardRadius = 20.0;
  static const navBarHeight = 72.0;
}
