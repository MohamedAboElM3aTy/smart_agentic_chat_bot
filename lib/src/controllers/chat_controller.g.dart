// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiChatService)
final aiChatServiceProvider = AiChatServiceProvider._();

final class AiChatServiceProvider
    extends $FunctionalProvider<AiChatService, AiChatService, AiChatService>
    with $Provider<AiChatService> {
  AiChatServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatServiceHash();

  @$internal
  @override
  $ProviderElement<AiChatService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiChatService create(Ref ref) {
    return aiChatService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatService>(value),
    );
  }
}

String _$aiChatServiceHash() => r'3ebe652fbd8961ebb02f3c1e64bfe8c9853b80f1';

@ProviderFor(ChatController)
final chatControllerProvider = ChatControllerProvider._();

final class ChatControllerProvider
    extends $NotifierProvider<ChatController, List<ChatMessageModel>> {
  ChatControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatControllerHash();

  @$internal
  @override
  ChatController create() => ChatController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ChatMessageModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ChatMessageModel>>(value),
    );
  }
}

String _$chatControllerHash() => r'0864ba020997cc29b2f93e368381e264cca25765';

abstract class _$ChatController extends $Notifier<List<ChatMessageModel>> {
  List<ChatMessageModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<ChatMessageModel>, List<ChatMessageModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ChatMessageModel>, List<ChatMessageModel>>,
              List<ChatMessageModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
