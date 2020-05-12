

import 'package:flutter_test/flutter_test.dart';

import '../../lib/store/catalog_store.dart';
import '../support/mock_api.dart' as mock;

void main() async {
  test('Fetch store list', () async {

    final store = CatalogStore(mock.apiService);
    await store.init();

    expect(store.categories.isNotEmpty, true);
    expect(store.products.isNotEmpty, true);
  });
}