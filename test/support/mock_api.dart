
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

  final Map<_Route, Map<int, String>> pathMap = {
    _Route('POST', '/shop-api/carts'): {201: 'cart_create'},
    _Route.regExp('GET', r'^/shop\-api/carts/([0-9a-f]{8}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{12})'): {200: 'cart'},
    _Route('GET', '/shop-api/taxons'): {200: 'categories'},
    _Route('GET', '/shop-api/taxon-products/by-code/pizza'): {200: 'pizza_products'},
  };

  /// Constructor.
  _ResponseFactory(this._request);

  /// Returns response corresponding to [pathMap].
  Future<Response> response() async {
    _Route route = _Route(_request.method, _request.url.path);
    try {

      if (pathMap.containsKey(route)) {
        Map<int, String> data = pathMap[route];
        int statusCode = data.entries.first.key;
        String dataName = data.entries.first.value;

        return Response(await DataHelper().asString(dataName), statusCode, headers: <String, String>{
          'Content-Type': 'application/json'
        });
      }

      return Response('', 404);
    } catch (e) {
      print(e);
      return Response('', 500);
    }
  }
}

class _Route {
  final String method;
  
  final String path;

  final RegExp pattern;

  final bool _isRegExp;

  _Route(this.method, this.path): _isRegExp = false, pattern = null;

  _Route.regExp(this.method, this.path): _isRegExp = true, pattern = RegExp(path);

  bool get isRegExp => _isRegExp;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
    other is _Route &&
    runtimeType == other.runtimeType &&
    method == other.method && (
      (isRegExp == false && other.isRegExp == false && path == other.path) ||
      (isRegExp && other.isRegExp == false && (pattern.firstMatch(other.path) != null)) ||
      (isRegExp == false && other.isRegExp && (other.pattern.firstMatch(path) != null)) ||
      (isRegExp && other.isRegExp && path == other.path)
    )
    ;
  }

  @override
  int get hashCode => method.hashCode;  // TODO its wrong!
}

