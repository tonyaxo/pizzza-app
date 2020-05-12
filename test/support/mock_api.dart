
import '../../lib/services/api_service.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart' as test;

import 'data_helper.dart';

final testBaseUrl = 'http://localhost/shop-api';

final ApiService apiService = ApiService(testBaseUrl, client);

final test.MockClient client = test.MockClient((request) async {
  var factory = _ResponseFactory(request);
  return await factory.response();
});

class _ResponseFactory {

  final Request _request;

  final Map<_Route, String> pathMap = {
    _Route('POST', '/shop-api/carts'): 'cart',
    _Route('GET', '/shop-api/taxons'): 'categories',
    _Route('GET', '/shop-api/taxon-products/by-code/pizza'): 'pizza_products',
  };

  _ResponseFactory(this._request);

  Future<Response> response() async {

    _Route route = _Route(_request.method, _request.url.path);
    try {

      if (pathMap.containsKey(route)) {
        String dataName = pathMap[route];
        return Response(await DataHelper().asString(dataName) , 200, headers: <String, String>{'Content-Type': 'application/json'});
      }

      return Response('', 404);
    } catch (e) {
      print(e);
      return Response('', 500);
    }
  }
}

class _Route {
  String method;
  String path;

  _Route(this.method, this.path);

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is _Route &&
    runtimeType == other.runtimeType &&
    method == other.method &&
    path == other.path
    ;

  @override
  int get hashCode => method.hashCode & path.hashCode;
}

