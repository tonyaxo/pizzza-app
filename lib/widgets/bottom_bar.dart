

import 'package:flutter/material.dart';
import '../store/bottom_bar_notifiler.dart';
import '../store/cart_store.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class BottomBar extends StatelessWidget {

  final iconSize = 32.0;

  final double height;
  BottomBar({this.height});

  @override
  Widget build(BuildContext context) {
    return height != null ? BottomAppBar(
      child: Container(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: _buildNavigationBar(context),
            )
          ]
        ),
      ),
    )
    : _buildNavigationBar(context);
  }

  Widget _buildNavigationBar(BuildContext context) {
    var cart = Provider.of<CartStore>(context);
    var barModel = Provider.of<BottomBarNotifiler>(context, listen: false);

    return BottomNavigationBar(
      // elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12.0,
      showUnselectedLabels: true,
      unselectedItemColor: Colors.grey,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.local_pizza, size: iconSize),
          title: Text('Меню'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: iconSize),
          title: Text('Профиль'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pin_drop, size: iconSize),
          title: Text('Контакты'),
        ),
        BottomNavigationBarItem(
          // https://stackoverflow.com/a/54094844/5957073
          icon: Stack(
            children: <Widget>[
              Icon(Icons.shopping_basket, size: iconSize),
              Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Observer(
                    builder: (_) => Text(
                      "${cart.info.itemsQuantity}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
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
}