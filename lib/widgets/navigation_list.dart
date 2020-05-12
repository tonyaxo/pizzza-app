
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../models/category.dart' as model;

class NavigationList extends StatelessWidget {

  final Map<String, model.Category> _categories;

  final void Function(String) onSelect;

  final String activeItem;

  NavigationList(this._categories, this.activeItem, this.onSelect);

  @override
  Widget build(BuildContext context) {
    return _buildListView();
  }

  Widget _buildListView() {

    return Observer(
      builder: (_) => ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(16.0),
        children: _categories.entries.map((entry) {
            
            model.Category category = entry.value;
            
            var res = GestureDetector(
              onTap: () { 
                onSelect(category.code);
              },
              child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  '${category.name} (${category.productsCount})',
                  style: TextStyle(fontWeight: activeItem == category.code ? FontWeight.bold : FontWeight.normal),
                ),
              )
            );

            // productListBaseOffset = productListBaseOffset == 0.0 ? 65.0 : productListBaseOffset;

            return res;
          }
        ).toList(),
      )
    );
  }
}