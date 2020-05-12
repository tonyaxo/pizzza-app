


import 'package:flutter/foundation.dart';

class BottomBarNotifiler extends ChangeNotifier {

  final Map<int, String> routes = {0: '/catalog', 1: '/profile', 2: '/contacts', 3: '/cart'};

  int activeBarItem = 0;

  String get currentRoute => getRoute(activeBarItem);

  String getRoute(int index) {
    return routes.containsKey(index) ? routes[index] : null;
  }
}