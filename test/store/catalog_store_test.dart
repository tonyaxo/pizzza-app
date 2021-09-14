

import 'package:flutter_test/flutter_test.dart';

import '../../lib/models/cart_info.dart';
import '../../lib/store/catalog_store.dart';
import '../support/mock_api.dart' as mock;

void main() async {
  test('Fetch store list', () async {

    final store = CatalogStore(mock.apiService);
    await store.init();

    expect(store.categories.isNotEmpty, true);
    expect(store.products.isNotEmpty, true);
  });

  test('Create cart', () async {

    CartInfo cart = await mock.apiService.createCart();

    expect(cart.tokenValue, 'c1b5afd9-d066-4c8b-bb65-8c39e712a3e4');
  });

  test('Fetch cart', () async {

    CartInfo cart = await mock.apiService.fetchCart('c1b5afd9-d066-4c8b-bb65-8c39e712a3e4');

    expect(cart.tokenValue, 'c1b5afd9-d066-4c8b-bb65-8c39e712a3e4');
    expect(cart.items.length, 2);
  });
}