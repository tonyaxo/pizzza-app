
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/product.dart';
import 'product_route_builder.dart';
import '../screens/contacts_screen.dart';
import '../screens/product_screen.dart';

class Router {

  /// The product screeen route path.
  static const productPath = '/product';

  /// Implements default routing beaheviour.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case productPath:
        final Product product = settings.arguments;
        return ProductRoute(wiget: ProductScreen(product));
        break;

      default:
        return MaterialPageRoute(
          builder: (context) => ContactsScreen()
        );
        break;
    }
  }
}