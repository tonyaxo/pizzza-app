

import '../models/product.dart';

class CartInfo {
  final String tokenValue;
  
  String currency;
  String checkoutState;

  String locale;
  String channel;

  Total totals = Total(0,0,0,0,0);

  int itemsQuantity = 0;

  String couponCode;
  String couponPromo;

  /// Discounts <promotionName, Promotion>
  Map<String, Promotion> discounts = Map<String, Promotion>();

  /// Items <itemID, CartItem>
  Map<int, CartItem> items = Map<int, CartItem>();

  CartInfo(this.tokenValue);

  bool get hasCoupon => couponCode != null;

  factory CartInfo.fromJson(Map<String, dynamic> json) {
    var result = CartInfo(json['tokenValue']);

    result.channel = json['channel'];
    result.currency = json['currency'];
    result.locale = json['locale'];
    result.checkoutState = json['checkoutState'];
    result.totals = Total.fromJson(json['totals']);

    result.discounts = parseDiscounts(json);

    if (json.containsKey('couponCode')) {
      result.couponCode = json['couponCode'];

      // search for coupon key in discounts.
      // result.discounts.forEach((key, value) {
      //   if (result.couponCode == value.name) {
      //     result.couponPromo = key;
      //   }
      // });

      // if (result.couponPromo != null) {
      //   result.discounts[result.couponPromo].isCoupon = true;
      // }
    }

    if (json.containsKey('items')) {
      json['items'].forEach((value) {
        var item = CartItem.fromJson(value);
        result.itemsQuantity += item.quantity;
        result.items[item.id] = item;
      });
    }

    return result;
  }

  static Map<String, Promotion> parseDiscounts(Map<String, dynamic> json) {
    Map<String, Promotion> result = Map<String, Promotion>();

    if (json.containsKey('cartDiscounts')) {
      if (json['cartDiscounts'].isNotEmpty) {
        Map<String, dynamic> cartDiscounts = json['cartDiscounts'];
      
        cartDiscounts.forEach((key, value) {
          result[key] = Promotion.fromJson(value);
        });
      }
    }

    return result;
  }

  /// Whether cart empty.
  bool get isEmpty => items.isEmpty;
}

class CartItem {
  int id;
  int quantity;
  int total;

  Product product;

  CartItem(this.id, this.quantity, this.total, this.product);

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      json['id'],
      json['quantity'],
      json['total'],
      Product.fromJson(json['product'])
    );
  }
}

class Promotion {
  final String name;

  final int currentAmount;

  final String currency;

  bool isCoupon;

  Promotion(this.name, this.currentAmount, this.currency): isCoupon = false;

  factory Promotion.fromJson(Map<String, dynamic> json) {

    return Promotion(
      json['name'],
      json['amount']['current'],
      json['amount']['currency'],
    );
  }
}

class Total {
  int total = 0;
  int items = 0;
  int taxes = 0;
  int shipping = 0;
  int promotion = 0;

  Total(this.total, this.items, this.taxes, this.shipping, this.promotion);

  factory Total.fromJson(Map<String, dynamic> json) {

    return Total(json['total'], json['items'], json['taxes'], json['shipping'], json['promotion']);
  }
}