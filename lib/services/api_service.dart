import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/product.dart';

// todo client.close()
class ApiService {

  final Uri baseUrl;

  http.Client client;

  ApiService(String baseUrl, [http.Client client])
    : this.client = (client == null ? http.Client() : client),
      this.baseUrl = Uri.parse(baseUrl);

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
        throw Exception('Request error ${response.statusCode}');
      }
      
    } catch (e) {
      print(e);
      return result;
    }
  }

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
        throw Exception('Request error ${response.statusCode}');
      }
      
    } catch (e) {
      print(e);
      return result;
    }
  }

  String _buildUrl(String path, [Map<String, dynamic> params]) {
    Uri result = baseUrl.replace(path: '${baseUrl.pathSegments.join('/')}$path');
    if (params != null) {
      result = result.replace(queryParameters: params);
    }

    return result.toString();
  }

}