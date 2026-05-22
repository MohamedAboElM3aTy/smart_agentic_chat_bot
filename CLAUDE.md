# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run
flutter run

# Build
flutter build apk
flutter build ios

# Test
flutter test
flutter test test/path/to_test.dart   # single file

# Code quality
dart format lib test
dart analyze .
dart fix --apply

# Code generation (required after adding/changing @riverpod annotations)
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs   # watch mode

# Full pre-commit pipeline (gen → format → fix → analyze → test)
./.hooks/pre-commit
```

The pre-commit hook runs automatically and stages changes after fixes — do not bypass it.

## Architecture

Flutter 3.11+ / Dart 3.11+ app targeting Android and iOS.

**Planned source structure:**
```
lib/
└── src/
    ├── models/       # Data classes (immutable)
    ├── widgets/      # Reusable UI components
    ├── views/        # Page/screen widgets
    ├── controllers/  # Riverpod providers / business logic
    └── services/     # Firebase, API, database access
```

**State management:** Riverpod with code generation. Always use `@riverpod` annotation — never hand-write providers. Run `build_runner` after annotation changes to regenerate `.g.dart` files.

**Firebase** (project: `smart-agentic-chat-bot`):
- `firebase_auth` — authentication
- `firebase_ai` — agentic chatbot (natural language → Firestore queries)
- Firestore — product catalog and user data (to be added to pubspec)
- Configured for Android and iOS only; web/desktop platforms are not supported

**HTTP client:** DIO (to be added to pubspec when making external API calls).

**Navigation:** `go_router` or `auto_route` (to be added to pubspec).

## Conventions

- **Naming:** `snake_case` files, `PascalCase` classes/enums, `lowerCamelCase` variables/methods, `_leading` underscore for private members
- Prefer `StatelessWidget` with `const` constructors; use `ConsumerWidget`/`ConsumerStatefulWidget` for Riverpod
- Composition over inheritance for widgets
- Use `ListView.builder` for dynamic lists; `collection if` for conditional rendering
- Keep widgets small — extract into separate widget classes rather than building large trees
- SOLID principles; data classes should be immutable
