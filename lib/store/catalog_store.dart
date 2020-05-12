
import 'package:async/async.dart';

import 'package:mobx/mobx.dart';

import '../models/category.dart' as model;
import '../models/product.dart';
import '../services/api_service.dart';

part 'catalog_store.g.dart';

class CatalogStore = _CatalogStoreBase with _$CatalogStore;

abstract class _CatalogStoreBase with Store {

  final ApiService _api;
  final AsyncMemoizer _asyncMemorizer = AsyncMemoizer();

  _CatalogStoreBase(this._api);

  @observable
  model.Category active;

  @observable
  ObservableFuture fetchCategoriesFuture;

  @observable
  ObservableMap<String, model.Category> categories = ObservableMap<String, model.Category>();

  @observable
  ObservableMap<String, Product> products = ObservableMap<String, Product>();

  @action
  Future<void> init() async {
    return _asyncMemorizer.runOnce(() async {
      await loadData();

      return true;
    });
  }

  @action
  Future<void> loadData() async {
      categories.clear();
      products.clear();

      var taxons = await _api.fetchCategories();

      var responses = await Future.wait(taxons.entries.map((entry) => _api.fetchProducts(entry.key)));

      responses.forEach((categoryProducts) {
        if (categoryProducts.isNotEmpty) {
          Product product = categoryProducts.entries.first.value;
          products.addAll(categoryProducts);

          if (taxons.containsKey(product.mainTaxon)) {
            taxons[product.mainTaxon].productsCount = categoryProducts.length;
          }
        }
      });

      categories.addAll(taxons);
  }
}