


import 'package:flutter/foundation.dart';

// TODO remove inherence.
class BottomBarNotifiler extends ChangeNotifier {

  static const cartIndex = 3;

  final Map<int, String> routes = {0: '/catalog', 1: '/profile', 2: '/contacts', cartIndex: '/cart'};

  int activeBarItem = 0;

  String get currentRoute => getRoute(activeBarItem);

  String getRoute(int index) {
    return routes.containsKey(index) ? routes[index] : null;
  }
}