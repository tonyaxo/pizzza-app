import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import '../models/cart_info.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/error_response.dart';

/// Service for https://app.swaggerhub.com/apis/Sylius/sylius-shop-api/1.0.0
// todo client.close()
class ApiService {

  final Uri baseUrl;

  http.Client client;

  ApiService(String baseUrl, [http.Client client])
    : this.client = (client == null ? http.Client() : client),
      this.baseUrl = Uri.parse(baseUrl);

  /// Returns all categories.
  Future<Map<String, Category>> fetchCategories() async {
    Map<String, Category> result = Map<String, Category>();

    try {
      final response  = await client.get(_buildUrl('/taxons'), headers: <String, String>{'Accept': 'application/json'});
      
      if (response.statusCode == 200) {
        Iterable iterator = json.decode(response.body);
        iterator.forEach((categoryJson) {
          Category category =  Category.fromJson(categoryJson);
          result[category.code] = category;
        });
        return result;
      } else {
        throw _processError(response);
      }
      
    } catch (e) {
      print(e);
      return result;
    }
  }

  /// Returns all products corresponding to categories.
  Future<Map<String, Product>> fetchProducts(String categoryCode) async {
    Map<String, Product> result = Map<String, Product>();

    try {
      final response  = await client.get(
        _buildUrl('/taxon-products/by-code/$categoryCode', {'limit': '1000'}), 
        headers: <String, String>{'Accept': 'application/json'}
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> results = json.decode(response.body);
        int _ = results['total'];
        Iterable iterator = results['items'];

        iterator.forEach((productJson) {
          Product product =  Product.fromJson(productJson);
          result[product.code] = product;
        });
        return result;
      } else {
        throw _processError(response);
      }
      
    } catch (e) {
      print(e);
      return result;
    }
  }

  /// Creates new cart.
  Future<CartInfo> createCart() async {
    try {
      final response  = await client.post(_buildUrl('/carts'), headers: <String, String>{'Accept': 'application/json'}, body: {});
      
      if (response.statusCode == 201) {
        Map<String, dynamic> info = json.decode(response.body);
        return CartInfo.fromJson(info);
      } else {
        throw _processError(response);
      }
      
    } catch (e) {
      print(e);
      return CartInfo(null);
    }
  }

  /// Removes cart by [tokenValue],
  /// returns `null` on success and "error string" on faluer.
  Future<String> deleteCart(String tokenValue) async {
    try {
      final response  = await client.delete(_buildUrl('/carts/$tokenValue'), headers: <String, String>{'Accept': 'application/json'});
      
      if (response.statusCode == 204) {
        return null;
      } else {
        throw _processError(response);
      }
      
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  /// Returns cart info by [tokenValue].
  Future<CartInfo> fetchCart(String tokenValue) async {
    try {
      final response  = await client.get(_buildUrl('/carts/$tokenValue'), headers: <String, String>{'Accept': 'application/json'});
      
      if (response.statusCode == 200) {
        Map<String, dynamic> info = json.decode(response.body);
        return CartInfo.fromJson(info);
      } else {
        throw _processError(response);
      }
      
    } catch (e) {
      print(e);
      return CartInfo(null);
    }
  }

  /// Add item to cart by [productCode], if broduct configurable you have to set [variantCode].
  /// Optional paramenter [quantity] is `1` by default.
  Future<CartInfo> addToCartByVariantCode(String tokenValue, String productCode, {String variantCode, int quantity = 1}) async {
    try {
      
      var requestBody = variantCode == null 
        ? { 'productCode': productCode, 'quantity': quantity }
        : { 'productCode': productCode, 'quantity': quantity, 'variantCode': variantCode };

      final response  = await client.post(
        _buildUrl('/carts/$tokenValue/items'), 
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );
      
      if (response.statusCode == 201) {
        Map<String, dynamic> info = json.decode(response.body);
        return CartInfo.fromJson(info);
      } else {
        throw _processError(response);
      }
      
    } catch (e) {
      print(e);
      return CartInfo(null);
    }
  }

  /// Changes item [quantity] with index [identifier] for cart [tokenValue],
  /// returns `null` on success and "error string" on faluer.
  Future<CartInfo> changeCartItemQuantity(String tokenValue, String identifier, int quantity) async {
    try {
      final response  = await client.put(
        _buildUrl('/carts/$tokenValue/items/$identifier'), 
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'quantity': quantity
        })
      );
      
      if (response.statusCode == 200) {
        Map<String, dynamic> info = json.decode(response.body);
        return CartInfo.fromJson(info);
      } else {
        throw _processError(response);
      }
    } catch (e) {
      print(e);
      return CartInfo(null);
    }
  }

  /// Removes cart item by [identifier].
  Future<CartInfo> deleteCartItem(String tokenValue, String identifier) async {
    try {
      final response  = await client.delete(
        _buildUrl('/carts/$tokenValue/items/$identifier'), 
        headers: <String, String>{'Accept': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        Map<String, dynamic> info = json.decode(response.body);
        return CartInfo.fromJson(info);
      } else {
        throw _processError(response);
      }
      
    } catch (e) {
      print(e);
      return CartInfo(null);
    }
  }

  /// Applys [coupon] code to cart.
  Future<CartInfo> applyCoupon(String tokenValue, String coupon) async {
    try {
      final response  = await client.put(_buildUrl('/carts/$tokenValue/coupon'), 
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'coupon': coupon
        })
      );
      
      if (response.statusCode == 200) {
        Map<String, dynamic> info = json.decode(response.body);
        return CartInfo.fromJson(info);
      } else {
        throw _processError(response);
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<CartInfo> deleteCoupon(String tokenValue) async {
    try {
      final response  = await client.delete(
        _buildUrl('/carts/$tokenValue/coupon'), 
        headers: <String, String>{'Accept': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        Map<String, dynamic> info = json.decode(response.body);
        return CartInfo.fromJson(info);
      } else {
        throw _processError(response);
      }
      
    } catch (e) {
      print(e);
      return CartInfo(null);
    }
  }

  /// Creates url with params.
  String _buildUrl(String path, [Map<String, dynamic> params]) {
    Uri result = baseUrl.replace(path: '${baseUrl.pathSegments.join('/')}$path');
    if (params != null) {
      result = result.replace(queryParameters: params);
    }

    return result.toString();
  }

  /// Throws exception with formatted error message.
  Exception _processError(http.Response response) {
    if (response.statusCode == 400) {
      Map<String, dynamic> err = json.decode(response.body);
      var responseErr =  ErrorResponse.fromJson(err);

      return Exception('Error ${responseErr.code}: ${responseErr.message}');
    } else if(response.statusCode >= 300) {
      return Exception('Request error ${response.statusCode}');
    } else {
      return Exception('Unexpected response code: ${response.statusCode}');
    }
  }
}