// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CatalogStore on _CatalogStoreBase, Store {
  final _$activeAtom = Atom(name: '_CatalogStoreBase.active');

  @override
  model.Category get active {
    _$activeAtom.context.enforceReadPolicy(_$activeAtom);
    _$activeAtom.reportObserved();
    return super.active;
  }

  @override
  set active(model.Category value) {
    _$activeAtom.context.conditionallyRunInAction(() {
      super.active = value;
      _$activeAtom.reportChanged();
    }, _$activeAtom, name: '${_$activeAtom.name}_set');
  }

  final _$fetchCategoriesFutureAtom =
      Atom(name: '_CatalogStoreBase.fetchCategoriesFuture');

  @override
  ObservableFuture<dynamic> get fetchCategoriesFuture {
    _$fetchCategoriesFutureAtom.context
        .enforceReadPolicy(_$fetchCategoriesFutureAtom);
    _$fetchCategoriesFutureAtom.reportObserved();
    return super.fetchCategoriesFuture;
  }

  @override
  set fetchCategoriesFuture(ObservableFuture<dynamic> value) {
    _$fetchCategoriesFutureAtom.context.conditionallyRunInAction(() {
      super.fetchCategoriesFuture = value;
      _$fetchCategoriesFutureAtom.reportChanged();
    }, _$fetchCategoriesFutureAtom,
        name: '${_$fetchCategoriesFutureAtom.name}_set');
  }

  final _$categoriesAtom = Atom(name: '_CatalogStoreBase.categories');

  @override
  ObservableMap<String, model.Category> get categories {
    _$categoriesAtom.context.enforceReadPolicy(_$categoriesAtom);
    _$categoriesAtom.reportObserved();
    return super.categories;
  }

  @override
  set categories(ObservableMap<String, model.Category> value) {
    _$categoriesAtom.context.conditionallyRunInAction(() {
      super.categories = value;
      _$categoriesAtom.reportChanged();
    }, _$categoriesAtom, name: '${_$categoriesAtom.name}_set');
  }

  final _$productsAtom = Atom(name: '_CatalogStoreBase.products');

  @override
  ObservableMap<String, Product> get products {
    _$productsAtom.context.enforceReadPolicy(_$productsAtom);
    _$productsAtom.reportObserved();
    return super.products;
  }

  @override
  set products(ObservableMap<String, Product> value) {
    _$productsAtom.context.conditionallyRunInAction(() {
      super.products = value;
      _$productsAtom.reportChanged();
    }, _$productsAtom, name: '${_$productsAtom.name}_set');
  }

  final _$initAsyncAction = AsyncAction('init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$loadDataAsyncAction = AsyncAction('loadData');

  @override
  Future<void> loadData() {
    return _$loadDataAsyncAction.run(() => super.loadData());
  }

  @override
  String toString() {
    final string =
        'active: ${active.toString()},fetchCategoriesFuture: ${fetchCategoriesFuture.toString()},categories: ${categories.toString()},products: ${products.toString()}';
    return '{$string}';
  }
}
