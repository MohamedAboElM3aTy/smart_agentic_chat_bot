# ShopAI — GDG Cairo Build with AI Workshop

> A production-ready Flutter e-commerce app powered by **Firebase AI (Gemini 2.5 Flash)** with function calling, Firestore, and a beautiful liquid-glass UI.

---

## What We're Building

| Feature | Description |
|---|---|
| Auth | Sign up / login with Firebase Auth (email + username + password) |
| Product catalog | Home feed with hero banner + category carousels, 28 products |
| Category explorer | Browse by category (Electronics, Clothing, Food, Books, Sports) with icons + live count |
| Cart & Checkout | Add to cart with loading state, swipe to dismiss, confirm-clear, dummy order flow |
| **AI Chatbot** | Ask in natural language → Gemini calls Firestore → shows product cards in chat |
| Theme toggle | Dark glass ↔ light mode, persisted across restarts with SharedPreferences |
| Seed data | One-tap "Seed Sample Products" button (28 products, no manual DB entry needed) |

**The demo moment:** type _"show me products under 50 EGP"_ in the Chat tab — Gemini's function calling fires `searchProducts(maxPrice: 50)`, queries Firestore in real-time, and renders matching product cards with "Add to Cart" inside the chat bubble.

---

## Prerequisites

| Tool | Minimum version |
|---|---|
| Flutter | 3.11+ |
| Dart | 3.11+ |
| Firebase CLI | latest (`npm install -g firebase-tools`) |
| A Firebase project | with Firestore, Auth, and Firebase AI Logic enabled |

---

## Quick Start

### 1. Clone and install dependencies

```bash
git clone <your-repo-url>
cd smart_agentic_chat_bot
flutter pub get
```

### 2. Configure Firebase

The app already has `firebase_options.dart` and `google-services.json` configured for the `smart-agentic-chat-bot` project. If you're using your own Firebase project, run:

```bash
firebase login
flutterfire configure
```

### 3. Set up Firestore

#### a) Create the database
Go to [Firebase Console](https://console.firebase.google.com) → your project → **Firestore Database** → **Create database** → choose a region → start in **Production mode**.

#### b) Deploy security rules and indexes

```bash
firebase use --add          # select your project
firebase deploy --only firestore
```

This deploys `firestore.rules` (auth-gated access) and `firestore.indexes.json` (composite indexes for price + category queries).

> **Alternatively**, paste the rules directly in Firebase Console → Firestore → Rules tab:
> ```
> rules_version = '2';
> service cloud.firestore {
>   match /databases/{database}/documents {
>     function isSignedIn() { return request.auth != null; }
>     function isOwner(uid) { return request.auth.uid == uid; }
>     match /users/{uid}          { allow read, write: if isSignedIn() && isOwner(uid); }
>     match /products/{productId} { allow read, write: if isSignedIn(); }
>     match /cart/{uid}           { allow read, write: if isSignedIn() && isOwner(uid);
>       match /items/{itemId}     { allow read, write: if isSignedIn() && isOwner(uid); }
>     }
>   }
> }
> ```

### 4. Enable Firebase AI Logic (Gemini) — **FREE, no billing required**

1. Firebase Console → **Build** → **Firebase AI Logic** → **Get started**
2. Choose **Gemini Developer API** ← the free Spark plan option
3. Complete the wizard — it enables the APIs and links an API key automatically
4. **Do NOT choose Vertex AI** (that requires billing)

### 5. Generate code and run

```bash
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## Seed Sample Products

The app ships with **28 demo products** across 5 categories with prices ranging from 25–750 EGP — no manual data entry needed.

To load them into Firestore:
1. Sign up / log in
2. Go to **Profile** tab
3. Tap **Seed Sample Products**

| Category | Products | Price range |
|---|---|---|
| Electronics | USB-C Charger, Earbuds, USB Hub, Headphones, Speaker, Laptop Stand, Smart Watch | 35–750 EGP |
| Clothing | T-Shirt, Cap, Jeans, Hoodie, Sneakers | 35–320 EGP |
| Food | Tea, Chocolate, Coffee, Honey, Nuts, Oatmeal | 25–85 EGP |
| Books | The Alchemist, Clean Code, Atomic Habits, Flutter Cookbook, Rich Dad Poor Dad | 30–145 EGP |
| Sports | Water Bottle, Jump Rope, Bands, Yoga Mat, Dumbbells | 28–280 EGP |

> Tap "Seed Sample Products" again to add the new products if you already seeded before.

---

## Project Structure

```
lib/
├── main.dart                          # Entry point — Firebase + ProviderScope + Router
├── firebase_options.dart              # Auto-generated Firebase config
└── src/
    ├── core/
    │   ├── constants/app_constants.dart
    │   ├── theme/
    │   │   ├── app_colors.dart        # Brand color palette
    │   │   ├── app_theme.dart         # ThemeData (dark + light)
    │   │   └── theme_colors.dart      # BuildContext extension for adaptive colors
    │   ├── router/app_router.dart     # auto_route config (11 routes)
    │   └── di/providers.dart          # DIO singleton
    ├── models/
    │   ├── user_model.dart
    │   ├── product_model.dart
    │   ├── cart_item_model.dart
    │   └── chat_message_model.dart
    ├── services/
    │   ├── auth_service.dart           # Firebase Auth (sign up saves to Firestore)
    │   ├── firestore_service.dart      # Products, cart CRUD, seedSampleProducts()
    │   └── ai_chat_service.dart        # Gemini function calling ← MAIN FEATURE
    ├── controllers/                    # Riverpod @riverpod providers
    │   ├── auth_controller.dart
    │   ├── products_controller.dart    # Includes allProductsProvider + productsProvider
    │   ├── cart_controller.dart
    │   ├── chat_controller.dart
    │   └── theme_controller.dart       # ThemeMode + SharedPreferences persistence
    ├── widgets/
    │   ├── liquid_glass_navbar.dart    # Custom animated glass nav bar (5 tabs)
    │   ├── glass_container.dart        # Reusable BackdropFilter card
    │   ├── product_card.dart           # Grid card + horizontal chat card
    │   ├── chat_bubble.dart            # User / AI / typing indicator bubbles
    │   └── social_sign_in_row.dart
    └── views/
        ├── splash/                     # Animated splash → auth check
        ├── auth/                       # Login + Signup screens
        ├── shell/                      # AutoTabsRouter shell
        ├── home/                       # Hero banner + per-category carousels
        ├── categories/                 # Category filter grid with icons
        ├── product_detail/             # SliverAppBar + add to cart
        ├── cart/                       # Dismissible items + confirm-clear
        ├── chat/                       # AI chatbot with suggestion chips
        ├── checkout/                   # Dummy order confirmation
        └── profile/                    # Avatar, seed button, theme toggle, sign out
```

---

## Key Architecture Concepts (Workshop Focus)

### 1. Riverpod v3 with code generation

```dart
// Define a provider with an annotation — build_runner generates the rest
@riverpod
Stream<List<ProductModel>> products(Ref ref) {
  final category = ref.watch(selectedCategoryProvider);
  return ref.watch(firestoreServiceProvider).productsStream(category: category);
}

// Unfiltered stream for the Home feed (independent of category selection)
@riverpod
Stream<List<ProductModel>> allProducts(Ref ref) {
  return ref.watch(firestoreServiceProvider).productsStream();
}

// Use in a widget
final products = ref.watch(productsProvider);
```

### 2. Gemini Function Calling — the heart of the demo

```dart
// Step 1: Declare what functions Gemini can call
FunctionDeclaration('searchProducts', 'Search store products',
  parameters: {
    'maxPrice': Schema.number(nullable: true),
    'minPrice': Schema.number(nullable: true),
    'category': Schema.string(nullable: true),
    'searchTerm': Schema.string(nullable: true),
  },
)

// Step 2: Send user message
final response = await _chat.sendMessage(Content.text("products under 50 EGP"));

// Step 3: Gemini returns a FunctionCall — execute it against Firestore
final products = await _firestoreService.searchProducts(maxPrice: 50);

// Step 4: Send results back — Gemini composes a natural language response
await _chat.sendMessage(Content.functionResponses([
  FunctionResponse('searchProducts', {'products': productList}),
]));
```

Full implementation: [`lib/src/services/ai_chat_service.dart`](lib/src/services/ai_chat_service.dart)

### 3. Adaptive theming with BuildContext extension

```dart
// theme_colors.dart — reads Theme.of(context).brightness at runtime
extension AppThemeColors on BuildContext {
  Color get adaptiveTextPrimary =>
      _isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A);
  LinearGradient get adaptiveBackgroundGradient => _isDark
      ? const LinearGradient(colors: [Color(0xFF0A0A0A), Color(0xFF141414)])
      : const LinearGradient(colors: [Colors.white, Colors.white]);
}

// Usage in any widget — no context.watch() needed
Text('Hello', style: TextStyle(color: context.adaptiveTextPrimary))
```

### 4. Theme persistence with SharedPreferences

```dart
@riverpod
class ThemeController extends _$ThemeController {
  @override
  ThemeMode build() {
    _loadSaved(); // async: reads prefs, then updates state
    return ThemeMode.light;
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', next == ThemeMode.light ? 'light' : 'dark');
  }
}
```

### 5. Clean Architecture layers

```
UI (views) → Controllers (Riverpod) → Services → Firebase
```

---

## Development Commands

```bash
# Install packages
flutter pub get

# Generate code (run after any @riverpod or @RoutePage change)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on save)
dart run build_runner watch --delete-conflicting-outputs

# Lint & format
dart analyze .
dart format lib

# Run on a connected device/emulator
flutter run

# Build release APK
flutter build apk --release
```

---

## Firestore Schema

```
users/{uid}
  uid, username, email, createdAt

products/{productId}
  name, description, price (EGP), category, imageUrl, stock

cart/{uid}/items/{productId}
  productId, name, price, imageUrl, quantity
```

**Security rules:** users can only read/write their own profile and cart; any authenticated user can read/write products (for the demo seed button).

**Composite indexes** (auto-deployed via `firestore.indexes.json`):
- `category ASC + price ASC`
- `category ASC + price DESC`
- `price ASC + name ASC`

---

## Try These Chatbot Queries

| Query | What Gemini does |
|---|---|
| `show me products under 50 EGP` | `searchProducts(maxPrice: 50)` |
| `what electronics do you have?` | `searchProducts(category: "Electronics")` |
| `books between 30 and 150 EGP` | `searchProducts(minPrice: 30, maxPrice: 150, category: "Books")` |
| `search for yoga mat` | `searchProducts(searchTerm: "yoga mat")` |
| `cheap sports gear` | `searchProducts(category: "Sports", maxPrice: 100)` |
| `show me the most expensive item` | `searchProducts()` → client sorts |

---

## Tech Stack

| | Package | Version |
|---|---|---|
| **Framework** | Flutter / Dart | 3.11+ |
| **State management** | flutter_riverpod + riverpod_annotation | ^3.x / ^4.x |
| **Navigation** | auto_route | ^10.0.0 |
| **AI** | firebase_ai (Gemini 2.5 Flash + function calling) | ^3.x |
| **Backend** | Firebase Auth + Cloud Firestore | latest |
| **HTTP** | dio + pretty_dio_logger | ^5.x |
| **Loading skeleton** | skeletonizer | ^2.x |
| **Image caching** | cached_network_image | ^3.x |
| **Animations** | flutter_animate | ^4.x |
| **Typography** | google_fonts (Poppins) | ^8.x |
| **Persistence** | shared_preferences | ^2.x |
| **Spacing** | gap | ^3.x |

---

## Workshop Demo Script

1. **Intro** — show app running, dark glass UI on device
2. **Auth** — sign up live on stage (username + email + password)
3. **Home** — Skeletonizer loading skeleton → hero banner + category carousels appear
4. **Category filter** — tap "Food" chip in Explore tab, real-time Firestore stream filters, see item count update
5. **Product detail** — tap a product → SliverAppBar image → Add to Cart
6. **Cart** — view items, swipe to dismiss one, see total update
7. **Checkout** — tap Checkout → dummy order confirmation screen
8. **THE MAIN DEMO** — Chat tab → type `"show me products under 50 EGP"`
   - Watch the typing indicator (animated dots)
   - Gemini calls `searchProducts(maxPrice: 50)` via function calling
   - Products appear as cards inside the chat bubble
   - Tap "Add to Cart" directly from chat
9. **Follow-up query** — type `"what books do you have?"` — no page navigation needed
10. **Theme toggle** — Profile tab → flip dark ↔ light, restart app to show it persists
11. **Code walkthrough** — open `ai_chat_service.dart`, explain the function calling loop (lines 17–115)

---

Built with ❤️ for **GDG Cairo — Build with AI**
