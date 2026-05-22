import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_agentic_chat_bot/src/models/user_model.dart';
import 'package:smart_agentic_chat_bot/src/services/auth_service.dart';

part 'auth_controller.g.dart';

// ── Auth state stream ──────────────────────────────────────────────────────

@riverpod
Stream<User?> authState(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}

// ── Auth service provider ──────────────────────────────────────────────────

@riverpod
AuthService authService(Ref ref) {
  return AuthService(FirebaseAuth.instance, FirebaseFirestore.instance);
}

// ── Auth controller ────────────────────────────────────────────────────────

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<UserModel?> build() => const AsyncData(null);

  Future<void> signUp({required String email, required String password, required String username}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceProvider).signUp(email: email, password: password, username: username),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authServiceProvider).signIn(email: email, password: password);
      return null;
    });
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
    if (ref.mounted) state = const AsyncData(null);
  }
}
