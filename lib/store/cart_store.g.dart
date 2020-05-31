// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CartStore on _CartStoreBase, Store {
  final _$infoAtom = Atom(name: '_CartStoreBase.info');

  @override
  CartInfo get info {
    _$infoAtom.context.enforceReadPolicy(_$infoAtom);
    _$infoAtom.reportObserved();
    return super.info;
  }

  @override
  set info(CartInfo value) {
    _$infoAtom.context.conditionallyRunInAction(() {
      super.info = value;
      _$infoAtom.reportChanged();
    }, _$infoAtom, name: '${_$infoAtom.name}_set');
  }

  final _$loadAsyncAction = AsyncAction('load');

  @override
  Future<void> load([String tokenValue]) {
    return _$loadAsyncAction.run(() => super.load(tokenValue));
  }

  final _$createAsyncAction = AsyncAction('create');

  @override
  Future<bool> create() {
    return _$createAsyncAction.run(() => super.create());
  }

  final _$fetchAsyncAction = AsyncAction('fetch');

  @override
  Future<bool> fetch(String tokenValue) {
    return _$fetchAsyncAction.run(() => super.fetch(tokenValue));
  }

  final _$addAsyncAction = AsyncAction('add');

  @override
  Future<bool> add(String productCode, {String variantCode}) {
    return _$addAsyncAction
        .run(() => super.add(productCode, variantCode: variantCode));
  }

  final _$changeQuantityAsyncAction = AsyncAction('changeQuantity');

  @override
  Future<bool> changeQuantity(int cartItemIndex, int quantity) {
    return _$changeQuantityAsyncAction
        .run(() => super.changeQuantity(cartItemIndex, quantity));
  }

  final _$deleteItemAsyncAction = AsyncAction('deleteItem');

  @override
  Future<bool> deleteItem(int cartItemIndex) {
    return _$deleteItemAsyncAction.run(() => super.deleteItem(cartItemIndex));
  }

  @override
  String toString() {
    final string = 'info: ${info.toString()}';
    return '{$string}';
  }
}
