import 'package:meta/meta.dart';

class Product {

  String code;
  String name;
  String slug;
  String description;
  String imageUrl;

  /// The maain category name.
  String mainTaxon;

  /// Ingredients.
  String attributes;

  Product({@required this.code, @required this.name, this.description});

  factory Product.fromJson(Map<String, dynamic> json) {

    var result =  Product(
      code: json['code'],
      name: json['name'],
      description: json['description'],
      // slug: json['slug'],
    );

    result.mainTaxon = parseMainTaxon(json);
    result.imageUrl = parseImages(json);
    result.attributes = parseAttributes(json);

    return result;
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
}

