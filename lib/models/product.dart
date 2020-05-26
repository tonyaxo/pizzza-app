
import 'package:flutter/foundation.dart';

/// Product itself.
class Product {
  static const maxPrice = 999999999;
  static const defaultCurrency = 'RUB';

  final String code;
  final String name;
  String description;

  String imageUrl;

  /// The maain category name.
  String mainTaxon;

  /// Ingredients.
  String attributes;

  /// Variants
  Map<VariantKey, ProductVariant> _variants;

  /// All avaliable options.
  Map<String, Option> options = Map<String, Option>();

  /// Constructor.
  Product(this.code, this.name, this._variants);

  Price _minPrice;

  /// Json factory.
  factory Product.fromJson(Map<String, dynamic> json) {

    var result =  Product(json['code'], json['name'], parseVariants(json));

    result.description = json['description'];
    result.mainTaxon = parseMainTaxon(json);
    result.imageUrl = parseImages(json);
    result.attributes = parseAttributes(json);

    result.options = parseOptions(json);

    return result;
  }

  /// All product variants.
  Map<VariantKey, ProductVariant> get variants => Map<VariantKey, ProductVariant>.unmodifiable(_variants);

  /// Minimal price according to variants.
  Price get minPrice => _minPrice == null ? _calculateMinPrice() : _minPrice;

  /// Minimum varian price
  Price _calculateMinPrice() {
    if (variants.isEmpty) {
      return Price(0, defaultCurrency);
    }

    Price price = Price(maxPrice, defaultCurrency);
    variants.forEach((key, varaint) {
      if (price.value > varaint.price.value) {
        price = varaint.price;
      }
    });

    return price;
  }

  static String parseMainTaxon(Map<String, dynamic> json) {
    if (json.containsKey('taxons')) {
      Map<String, dynamic> taxons = json['taxons'];
      if (taxons.containsKey('main')) {
        return taxons['main'];
      } 
    }

    return null;
  }

  static String parseAttributes(Map<String, dynamic> json) {

    String result = '';

    if (json.containsKey('attributes')) {
      List<Map<String, dynamic>> attributes = List.from(json['attributes']);
      if (attributes.isEmpty) {
        return result;
      }
      attributes.forEach((attribute) {
        if (attribute.containsKey('code') && attribute['code'] == 'ingredients') {
          List<String> ingredients = List.from(attribute['value']);
          result = ingredients.join(', ');
        }
      });
    }

    return result;
  }

  static String parseImages(Map<String, dynamic> json) {
    if (json.containsKey('images')) {
      List<Map<String, dynamic>> images = List.from(json['images']);
      if (images.isNotEmpty && images.first.containsKey('cachedPath')) {
        return images.first['cachedPath'];
      }
    }

    return null;
  }

  static Map<VariantKey, ProductVariant> parseVariants(Map<String, dynamic> json) {
    Map<VariantKey, ProductVariant> result = Map<VariantKey, ProductVariant>();

    if (!json.containsKey('variants')) {
      return result;
    }
    
    // `variants` represents as List in cart info struct
    if (json['variants'].runtimeType == List<dynamic>().runtimeType) {
      json['variants'].forEach((value) {
        var variant = ProductVariant.fromJson(value);
        result[variant.key] = variant;
      });
    } else if (json['variants'].runtimeType == Map<String, dynamic>().runtimeType) {
      // `variants` represents as Map in product info
      json['variants'].forEach((key, value) {
        var variant = ProductVariant.fromJson(value);
        result[variant.key] = variant;
      });
    }
    
    return result;
  }

  static Map<String, Option> parseOptions(Map<String, dynamic> json) {
    var result = Map<String, Option>();

    if (json.containsKey('options')) {
      json['options'].forEach((option) {
        result[option['code']] = Option.fromJson(option);
      });
    }

    return result;
  }
}

/// Key for variants map.
class VariantKey {
  List<String> _data;

  String _hash = '';

  VariantKey(List<String> data) {
    value = data;
  }

  set value(List<String> list) {
    _data =  List<String>.from(list);
    _data.sort();
    _data.forEach((element) {
      _hash = _hash + element;
    });
  }

  List<String> get value => _data;

  @override
  bool operator ==(Object other)  {
    return other is VariantKey && listEquals(this.value, other.value);
  }

  @override
  int get hashCode => _hash.hashCode;
}

/// Reperesents option variant of product
/// including price
class ProductVariant {
  final String code;
  String name;

  Price price = Price(0, 'RUB');
  Price originalPrice;

  final VariantKey key;

  ProductVariant({this.code, this.key});

  factory ProductVariant.fromJson(Map<String, dynamic> json) {

    List<String> axis = (json.containsKey('axis')) ? List<String>.from(json['axis']) : List<String>();

    var result =  ProductVariant(
      code: json['code'],
      key: VariantKey(axis),
    );

    if (json.containsKey('price')) {
      result.price = Price.fromJson(json['price']);
    }

    if (json.containsKey('originalPrice')) {
      result.originalPrice = Price.fromJson(json['originalPrice']);
    }

    return result;
  }

  @override
  bool operator ==(Object other) => other is ProductVariant && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

class Price {
  /// Value of price in minimum units.
  /// for example 1$ it equals to 100 cents.
  final int value;

  /// According to ISO-4217 
  /// https://www.currency-iso.org/en/home/tables/table-a1.html
  final String currency;

  Price(this.value, this.currency);

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(json['current'], json['currency']);
  }
}

class Option {
  final String code;
  final String name;

  final int position;

  Map<String, String> values = Map<String, String>();

  Option(this.code, this.name, this.position);

  factory Option.fromJson(Map<String, dynamic> json) {
    var result = Option(json['code'], json['name'], json['position']);

    if (json.containsKey('values')) {
      final Map<String, dynamic> values = json['values'];
      values.forEach((code, value) {
        result.values[code] = value;
      });
    }

    return result;
  }
}

