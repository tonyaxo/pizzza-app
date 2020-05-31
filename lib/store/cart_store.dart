
import 'package:mobx/mobx.dart';

import '../models/cart_info.dart';
import '../services/api_service.dart';

part 'cart_store.g.dart';

class CartStore = _CartStoreBase with _$CartStore;

abstract class _CartStoreBase with Store {
  final ApiService _api;

  _CartStoreBase(this._api);

  @observable
  CartInfo info;

  @action
  Future<void> load([String tokenValue]) async {
    if (tokenValue == null) {
      await create();
      print("Created ${info.tokenValue}");
    } else {
      await fetch(tokenValue);
      print("Fetched ${info.tokenValue}");
    }
  }

  /// Creates new cart.
  @action
  Future<bool> create() async {
    try {
      info = await _api.createCart();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Fetchs cart info.
  @action
  Future<bool> fetch(String tokenValue) async {
     try {
      info = await _api.fetchCart(tokenValue);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Adds to cart [productCode] with optional [variantCode].
  @action
  Future<bool> add(String productCode, { String variantCode }) async {
    try {
      info = await _api.addToCartByVariantCode(info.tokenValue, productCode, variantCode: variantCode);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Changes quantity to [quantity] for [cartItemIndex]
  @action
  Future<bool> changeQuantity(int cartItemIndex, int quantity) async {
    try {
      info = await _api.changeCartItemQuantity(info.tokenValue, cartItemIndex.toString(), quantity);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @action
  Future<bool> deleteItem(int cartItemIndex) async {
    try {
      info = await _api.deleteCartItem(info.tokenValue, cartItemIndex.toString());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @action
  Future<bool> applyCoupon(String couponCode) async {
    try {
      info = await _api.applyCoupon(info.tokenValue, couponCode);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @action
  Future<bool> deleteCoupon() async {
    try {
      info = await _api.deleteCoupon(info.tokenValue);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}