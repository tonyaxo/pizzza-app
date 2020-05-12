

import 'package:flutter/material.dart';
import 'package:foodcourt/store/bottom_bar_notifiler.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomBarNotifiler>(
      builder: (_, barModel, child) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12.0,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.local_pizza),
              title: Text('Меню'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Профиль'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pin_drop),
              title: Text('Контакты'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              title: Text('Корзина'),
            ),
          ],
          currentIndex: barModel.activeBarItem,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            barModel.activeBarItem = index;
            Navigator.pushNamed(context, barModel.getRoute(index));
          },
        );
      }
    );
  }
}