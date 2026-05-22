import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_agentic_chat_bot/firebase_options.dart';
import 'package:smart_agentic_chat_bot/src/controllers/theme_controller.dart';
import 'package:smart_agentic_chat_bot/src/core/router/app_router.dart';
import 'package:smart_agentic_chat_bot/src/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: ShopAiApp()));
}

class ShopAiApp extends ConsumerStatefulWidget {
  const ShopAiApp({super.key});

  @override
  ConsumerState<ShopAiApp> createState() => _ShopAiAppState();
}

class _ShopAiAppState extends ConsumerState<ShopAiApp> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    return MaterialApp.router(
      title: 'ShopAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: _router.config(),
    );
  }
}
