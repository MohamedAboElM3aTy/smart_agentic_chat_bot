// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firestoreService)
final firestoreServiceProvider = FirestoreServiceProvider._();

final class FirestoreServiceProvider
    extends
        $FunctionalProvider<
          FirestoreService,
          FirestoreService,
          FirestoreService
        >
    with $Provider<FirestoreService> {
  FirestoreServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firestoreServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firestoreServiceHash();

  @$internal
  @override
  $ProviderElement<FirestoreService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirestoreService create(Ref ref) {
    return firestoreService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirestoreService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirestoreService>(value),
    );
  }
}

String _$firestoreServiceHash() => r'3998bb0191dc8e9a16862b8ef8a95354dec81e6f';

@ProviderFor(SelectedCategory)
final selectedCategoryProvider = SelectedCategoryProvider._();

final class SelectedCategoryProvider
    extends $NotifierProvider<SelectedCategory, String> {
  SelectedCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCategoryHash();

  @$internal
  @override
  SelectedCategory create() => SelectedCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedCategoryHash() => r'873cc9786873565f02210a29edbbf92297e6c5a4';

abstract class _$SelectedCategory extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(products)
final productsProvider = ProductsProvider._();

final class ProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductModel>>,
          List<ProductModel>,
          Stream<List<ProductModel>>
        >
    with
        $FutureModifier<List<ProductModel>>,
        $StreamProvider<List<ProductModel>> {
  ProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productsHash();

  @$internal
  @override
  $StreamProviderElement<List<ProductModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ProductModel>> create(Ref ref) {
    return products(ref);
  }
}

String _$productsHash() => r'9893918813aa092ff30f457cd30665ac060d73c6';

@ProviderFor(allProducts)
final allProductsProvider = AllProductsProvider._();

final class AllProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductModel>>,
          List<ProductModel>,
          Stream<List<ProductModel>>
        >
    with
        $FutureModifier<List<ProductModel>>,
        $StreamProvider<List<ProductModel>> {
  AllProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allProductsHash();

  @$internal
  @override
  $StreamProviderElement<List<ProductModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ProductModel>> create(Ref ref) {
    return allProducts(ref);
  }
}

String _$allProductsHash() => r'bd61358db7ee38c9678e5977d9a1e99f51805908';

@ProviderFor(product)
final productProvider = ProductFamily._();

final class ProductProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProductModel?>,
          ProductModel?,
          FutureOr<ProductModel?>
        >
    with $FutureModifier<ProductModel?>, $FutureProvider<ProductModel?> {
  ProductProvider._({
    required ProductFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productHash();

  @override
  String toString() {
    return r'productProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProductModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProductModel?> create(Ref ref) {
    final argument = this.argument as String;
    return product(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productHash() => r'54b90aeda6e5b8e16ebf7b9c1eaaa1477ca161da';

final class ProductFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProductModel?>, String> {
  ProductFamily._()
    : super(
        retry: null,
        name: r'productProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductProvider call(String id) =>
      ProductProvider._(argument: id, from: this);

  @override
  String toString() => r'productProvider';
}
