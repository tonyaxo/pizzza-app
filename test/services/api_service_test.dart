
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:foodcourt/services/api_service.dart';

void main() {
  test('Test fetch categories', () async {
    final api = ApiService('http://localhost/shop-api');
    api.client = MockClient((request) async {
      final categoriesJson = [
          {
              "code": "pizza",
              "name": "Pizza",
              "slug": "pitstsa",
              "description": "Qui harum harum quas iusto. Illum quisquam voluptatum ut id. Vero quidem et nulla itaque assumenda iusto consequatur.",
              "position": 0,
              "children": [],
              "images": []
          },
          {
              "code": "roll",
              "name": "Roll",
              "slug": "roly",
              "description": "Explicabo maxime vero dolorem sapiente ut. Quasi atque temporibus rem repellat esse. Non laudantium possimus et modi. Quasi voluptatibus mollitia harum veniam est.",
              "position": 1,
              "children": [],
              "images": []
          }
      ];
      return Response(json.encode(categoriesJson), 200);
    });

    final categories = await api.fetchCategories();
    expect(categories.isNotEmpty, true);
    expect(categories.length, 2);
    categories.forEach((code, category) {
      expect(category.name.isNotEmpty, true);
    });
  });

  test('Test fetch categories empty', () async {
    final api = ApiService('http://localhost/shop-api');
    api.client = MockClient((request) async {
      final categoriesJson = [];
      return Response(json.encode(categoriesJson), 200);
    });

    final categories = await api.fetchCategories();
    expect(categories.isEmpty, true);
  });

  test('Test fetch products of category empty', () async {
    final api = ApiService('http://localhost/shop-api');
    api.client = MockClient((request) async {
      final productsJson = {
          "page": 1,
          "limit": 100,
          "pages": 1,
          "total": 0,
          "_links": {
              "self": "/shop-api/taxon-products/by-code/pizza?limit=100&page=1",
              "first": "/shop-api/taxon-products/by-code/pizza?limit=100&page=1",
              "last": "/shop-api/taxon-products/by-code/pizza?limit=100&page=1",
              "next": "/shop-api/taxon-products/by-code/pizza?limit=100&page=1"
          },
          "items": []
      };
      return Response(json.encode(productsJson), 200);
    });

    final products = await api.fetchProducts('pizza');
    expect(products.isEmpty, true);
  });

  test('Test fetch products of category', () async {
    final api = ApiService('http://localhost/shop-api');
    api.client = MockClient((request) async {
      final productsJson = {
          "page": 1,
          "limit": 100,
          "pages": 1,
          "total": 3,
          "_links": {
              "self": "/shop-api/taxon-products/by-code/pizza?limit=100&page=1",
              "first": "/shop-api/taxon-products/by-code/pizza?limit=100&page=1",
              "last": "/shop-api/taxon-products/by-code/pizza?limit=100&page=1",
              "next": "/shop-api/taxon-products/by-code/pizza?limit=100&page=1"
          },
          "items": [
              {
                  "code": "pizza_pepperoni",
                  "name": "Pepperoni",
                  "slug": "pepperoni",
                  "channelCode": "main_channel",
                  "description": "Ut odit minima odit autem deleniti. Iure et dolorem ducimus omnis dolorum.\n\nQui optio amet qui iusto impedit. Vel rerum dolorum neque id enim. Praesentium est sed non. Et facilis molestiae optio dolore inventore sunt ut.\n\nPossimus eveniet non omnis illo. Fugiat voluptates eligendi porro et et maxime. Dolores numquam ut facilis hic. Saepe molestiae distinctio in distinctio.",
                  "shortDescription": "Culpa dolor quas quas magni. Rem et laboriosam voluptas rerum aspernatur. Quibusdam quos ipsa eum. Rerum et repellendus totam aperiam debitis ad fuga.",
                  "averageRating": 0,
                  "taxons": {
                      "main": "pizza",
                      "others": [
                          "pizza"
                      ]
                  },
                  "variants": {},
                  "attributes": [],
                  "associations": [],
                  "images": [
                      {
                          "code": "main",
                          "path": "b5/0f/9b9793fdd63a72e351936b71c192.jpeg",
                          "cachedPath": "http://localhost/media/cache/sylius_shop_api/b5/0f/9b9793fdd63a72e351936b71c192.jpeg"
                      }
                  ],
                  "_links": {
                      "self": {
                          "href": "/shop-api/products/by-slug/pepperoni"
                      }
                  }
              },
              {
                  "code": "pizza_margarita",
                  "name": "Margarita",
                  "slug": "margarita",
                  "channelCode": "main_channel",
                  "description": "Corporis excepturi ipsa quisquam occaecati iste tenetur maiores. Perspiciatis doloremque minus debitis voluptate. Blanditiis dolorem laudantium et id minus est id. Minima et beatae id.\n\nPerferendis ut laudantium sint fuga reprehenderit similique. Tenetur et sed ea quo repellat. Ratione aspernatur voluptatem sit ratione. Natus ut nihil numquam qui nulla.\n\nOfficiis eum nihil et soluta molestiae. Quia enim vero amet voluptatem. Assumenda non nam sit ipsam.",
                  "shortDescription": "Aperiam consequatur eius voluptas placeat non alias. Velit velit molestiae blanditiis quam reiciendis eaque. Nemo ut sequi tempore ut qui dolorem. Dolor officiis non ex ab et nesciunt molestiae. Rerum nemo laborum architecto minus qui.",
                  "averageRating": 0,
                  "taxons": {
                      "main": "pizza",
                      "others": [
                          "pizza"
                      ]
                  },
                  "variants": {},
                  "attributes": [],
                  "associations": [],
                  "images": [
                      {
                          "code": "main",
                          "path": "83/34/a6c0abd2e90564b93f774123ae44.jpeg",
                          "cachedPath": "http://localhost/media/cache/sylius_shop_api/83/34/a6c0abd2e90564b93f774123ae44.jpeg"
                      }
                  ],
                  "_links": {
                      "self": {
                          "href": "/shop-api/products/by-slug/margarita"
                      }
                  }
              },
              {
                  "code": "pizza_hawaiian",
                  "name": "Hawaiian",
                  "slug": "gavaiskaia",
                  "channelCode": "main_channel",
                  "description": "Laudantium nihil vero occaecati voluptatem asperiores quas. Autem omnis temporibus non beatae voluptates id accusantium. Pariatur dolor beatae voluptatem architecto sint magni sint. Sed recusandae aut est sed minima et.\n\nQuidem enim et qui dolores nemo ab. Tempore sequi eum nesciunt quia ducimus blanditiis. Vel quia temporibus non ut.\n\nIn aut consectetur quia. Et et quia quidem qui culpa totam et. Est non aperiam et dolore animi. Expedita ex ex excepturi eius. Aut possimus inventore voluptatem quis.",
                  "shortDescription": "Vero vitae laboriosam nisi voluptas. Id commodi vitae accusamus enim sed aut. Qui veniam aspernatur quae distinctio et sit.",
                  "averageRating": 0,
                  "taxons": {
                      "main": "pizza",
                      "others": [
                          "pizza"
                      ]
                  },
                  "variants": {},
                  "attributes": [],
                  "associations": [],
                  "images": [
                      {
                          "code": "main",
                          "path": "05/0f/a1ce8d2c84e85bfd5bc8824f8a8c.jpeg",
                          "cachedPath": "http://localhost/media/cache/sylius_shop_api/05/0f/a1ce8d2c84e85bfd5bc8824f8a8c.jpeg"
                      }
                  ],
                  "_links": {
                      "self": {
                          "href": "/shop-api/products/by-slug/gavaiskaia"
                      }
                  }
              }
          ]
      };
      return Response(json.encode(productsJson), 200);
    });

    final products = await api.fetchProducts('pizza');
    expect(products.isNotEmpty, true);
    expect(products.length, 3);
    products.forEach((code, product) {
      expect(product.name.isNotEmpty, true);
    });
  });
}