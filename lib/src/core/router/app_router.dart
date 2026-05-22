import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_agentic_chat_bot/src/views/auth/login_screen.dart';
import 'package:smart_agentic_chat_bot/src/views/auth/signup_screen.dart';
import 'package:smart_agentic_chat_bot/src/views/cart/cart_screen.dart';
import 'package:smart_agentic_chat_bot/src/views/categories/categories_screen.dart';
import 'package:smart_agentic_chat_bot/src/views/chat/chat_screen.dart';
import 'package:smart_agentic_chat_bot/src/views/checkout/checkout_screen.dart';
import 'package:smart_agentic_chat_bot/src/views/home/home_screen.dart';
import 'package:smart_agentic_chat_bot/src/views/product_detail/product_detail_screen.dart';
import 'package:smart_agentic_chat_bot/src/views/profile/profile_screen.dart';
import 'package:smart_agentic_chat_bot/src/views/shell/main_shell.dart';
import 'package:smart_agentic_chat_bot/src/views/splash/splash_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page, path: '/login'),
        AutoRoute(page: SignupRoute.page, path: '/signup'),
        AutoRoute(
          page: MainShellRoute.page,
          path: '/main',
          children: [
            AutoRoute(page: HomeRoute.page, path: 'home', initial: true),
            AutoRoute(page: CategoriesRoute.page, path: 'categories'),
            AutoRoute(page: ChatRoute.page, path: 'chat'),
            AutoRoute(page: CartRoute.page, path: 'cart'),
            AutoRoute(page: ProfileRoute.page, path: 'profile'),
          ],
        ),
        AutoRoute(page: ProductDetailRoute.page, path: '/product/:id'),
        AutoRoute(page: CheckoutRoute.page, path: '/checkout'),
      ];
}
